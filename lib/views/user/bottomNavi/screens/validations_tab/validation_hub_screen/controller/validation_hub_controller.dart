import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/task_service.dart';
import 'package:red_balloon_app/services/wallet_service.dart';

class ValidationHubController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TaskService _taskService = TaskService();
  final WalletService _walletService = WalletService();
  final NotificationService _notificationService = NotificationService.instance;

  StreamSubscription<QuerySnapshot>? _subscription;

  RxList<Map<String, dynamic>> validations = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  
  // 🔥 Unread validation counter
  RxInt unreadValidationCount = 0.obs;
  DateTime? lastSeenTimestamp;
  RxBool isScreenVisible = false.obs;

  Timer? _timer;
  RxMap<String, String> remainingTimes = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Load last seen timestamp from storage if needed
    _loadLastSeenTimestamp();
    // First time load: 2 seconds delay
    fetchValidations(minDelay: const Duration(seconds: 2));
    _startTimer();
  }
  
  @override
  void onClose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateRemainingTimes();
    });
  }

  void _updateRemainingTimes() {
    for (var validation in validations) {
        final rejectedAtTimestamp = validation['rejectedAt'];
        if (rejectedAtTimestamp != null) {
          DateTime rejectedAt;
          if (rejectedAtTimestamp is Timestamp) {
            rejectedAt = rejectedAtTimestamp.toDate();
          } else if (rejectedAtTimestamp is String) {
            rejectedAt = DateTime.parse(rejectedAtTimestamp);
          } else {
            rejectedAt = DateTime.now();
          }
          final now = DateTime.now();
          final difference = now.difference(rejectedAt);
          final remainingMinutes = 15 - difference.inMinutes;

        if (remainingMinutes <= 0) {
          remainingTimes[validation['validationId']] = "0 min left to validate";
          // 🔥 Auto-finalize if time expired
          _autoFinalizeValidation(validation);
        } else {
          remainingTimes[validation['validationId']] =
              "$remainingMinutes min left to validate";
        }
      }
    }
  }

  /// Flag to avoid redundant calls for the same validation in one session
  final Map<String, bool> _isFinalizing = {};

  Future<void> _autoFinalizeValidation(Map<String, dynamic> validation) async {
    final validationId = validation['validationId'];
    final taskId = validation['taskId'];

    if (_isFinalizing[validationId] == true) return;
    _isFinalizing[validationId] = true;

    try {
      print('⏰ Validation $validationId expired. Auto-finalizing...');

      // 0. Check if already distributed in DB (to handle manual resets correctly)
      final vDoc = await _firestore.collection('validations').doc(validationId).get();
      if (vDoc.exists && (vDoc.data() as Map<String, dynamic>)['isFundsDistributed'] == true) {
        print('ℹ️ Validation $validationId already paid. Closing.');
        await _firestore.collection('validations').doc(validationId).update({'isVotingCompleted': true});
        return;
      }

      // 1. Fetch latest voting data
      final votingDoc = await _firestore.collection('voting').doc(taskId).get();

      String? winner;
      int helperVotes = 0;
      int requesterVotes = 0;

      if (votingDoc.exists) {
        final data = votingDoc.data()!;
        final voters = List<Map<String, dynamic>>.from(data['voters'] ?? []);
        helperVotes = voters.where((v) => v['voteType'] == 'helper').length;
        requesterVotes = voters.where((v) => v['voteType'] == 'requester').length;

        // 🔥 Consensus reached if one side has 5+ votes
        if (helperVotes >= 5 || requesterVotes >= 5) {
          winner = helperVotes >= 5 ? 'helper' : 'requester';
        } else {
          // 🔥 No consensus reached within 15 mins (both < 5) -> Admin review
          winner = null; 
        }
      }

      final validationRef = _firestore.collection('validations').doc(validationId);

      if (winner != null) {
        // 1. Fetch task and proof info first
        final taskData = await _taskService.getTaskById(taskId);
        if (taskData != null) {
          final totalAmount = (taskData['budget'] ?? 0.0).toDouble();
          final helperUid = taskData['acceptedOfferUid'];
          final requesterUid = taskData['uid'];
          final taskTitle = taskData['title'] ?? 'Task';

          // Get voters who voted for the winner
          final data = votingDoc.data()!;
          final voters = List<Map<String, dynamic>>.from(data['voters'] ?? []);
          final winnerVoterUids = voters
              .where((v) => v['voteType'] == winner)
              .map((v) => (v['userId'] ?? v['uid']) as String)
              .toList();

          // 2. Distribute Funds (Updates Wallet, Escrow, and Validation doc's isFundsDistributed)
          final distributionResult = await _walletService.distributeValidationFunds(
            validationId: validationId,
            taskId: taskId,
            winner: winner,
            winnerVoterUids: winnerVoterUids,
            totalAmount: totalAmount,
            taskTitle: taskTitle,
            helperUid: helperUid,
            requesterUid: requesterUid,
          );

          if (distributionResult['success'] == true) {
            // 3. Mark Task as payment finalized
            await _firestore.collection('tasks').doc(taskId).update({
              'isPaymentFinalized': true,
              'status': winner == 'helper' ? 'completed' : 'refunded',
            });

            // 4. Send Notifications
            await _notificationService.notifyValidationWinner(
              winnerId: winner == 'helper' ? helperUid : requesterUid,
              taskTitle: taskTitle,
              taskId: taskId,
              amount: distributionResult['winnerAmount'],
              isRefund: winner == 'requester',
            );

            if (winnerVoterUids.isNotEmpty) {
              final sharePerVoter = (distributionResult['voterShareTotal'] ?? 0.0) / winnerVoterUids.length;
              for (var vUid in winnerVoterUids) {
                await _notificationService.notifyValidationVoterReward(
                  voterId: vUid,
                  taskTitle: taskTitle,
                  taskId: taskId,
                  amount: sharePerVoter,
                );
              }
            }

            // 5. FINALLY Mark validation as completed so it disappears from the hub
            await validationRef.update({
              'isVotingCompleted': true,
              'winner': winner,
              'helperVotes': helperVotes,
              'requesterVotes': requesterVotes,
              'completedAt': FieldValue.serverTimestamp(),
            });

            print('✅ Auto-finalized validation $validationId. Winner: $winner');
          } else {
             print('⚠️ Fund distribution failed: ${distributionResult['message']}');
          }
        }
      } else {
        // Send to admin (No consensus)
        await validationRef.update({
          'isVotingCompleted': true,
          'sentToAdmin': true,
          'helperVotes': helperVotes,
          'requesterVotes': requesterVotes,
          'completedAt': FieldValue.serverTimestamp(),
        });
        print('📤 Auto-sent validation $validationId to admin');
      }
    } catch (e) {
      print('❌ Error in auto-finalizing validation: $e');
    } finally {
      // Keep it true for a while to avoid retries if update fails or takes time
      Future.delayed(const Duration(minutes: 2), () {
        _isFinalizing.remove(validationId);
      });
    }
  }

  // Fetch validations from Firestore with real-time updates
  Future<void> fetchValidations({Duration minDelay = Duration.zero}) async {
    try {
      // Cancel previous subscription to avoid duplicates
      await _subscription?.cancel();
      
      isLoading.value = true;
      final Completer<void> completer = Completer<void>();

      // Start the delay timer
      final delayFuture = Future.delayed(minDelay);

      // 🔥 Stream validations where isVotingCompleted is false
      _subscription = _firestore
          .collection('validations')
          .where('isVotingCompleted', isEqualTo: false)
          .snapshots()
          .listen((snapshot) async {
            
        try {
          final List<Map<String, dynamic>> fetchedValidations = [];

          for (var doc in snapshot.docs) {
            final validationData = doc.data();
            final taskId = validationData['taskId'];
            final rejectedBy =
                validationData['rejectedBy']; // UID of user who rejected

            // Fetch userId from users collection using rejectedBy UID
            String userId = 'RB-00000'; // Default
            if (rejectedBy != null && rejectedBy.isNotEmpty) {
              try {
                final userDoc = await _firestore
                    .collection('users')
                    .doc(rejectedBy)
                    .get();

                if (userDoc.exists) {
                  final userData = userDoc.data();
                  userId = userData?['userId'] ?? 'RB-00000';
                }
              } catch (e) {
                print('Error fetching user data: $e');
              }
            }

            // Fetch task details using taskId
            if (taskId != null) {
              final taskData = await _taskService.getTaskById(taskId);
              if (taskData != null) {
                final validationMap = {
                  'validationId': doc.id,
                  'taskId': taskId,
                  'taskTitle': taskData['title'] ?? 'No Title',
                  'userId': userId, // From users collection
                  'beforePhotoUrl': validationData['beforePhotoUrl'] ?? '',
                  'afterPhotoUrl': validationData['afterPhotoUrl'] ?? '',
                  'proofId': validationData['proofId'] ?? '',
                  'status': validationData['status'] ?? 'pending',
                  'rejectedAt': validationData['rejectedAt'] ?? Timestamp.now(),
                  'winner': validationData['winner'],
                  'sentToAdmin': validationData['sentToAdmin'] ?? false,
                };
                fetchedValidations.add(validationMap);
              }
            }
          }

          // If this is the initial load (completer not done), wait for delay
          if (!completer.isCompleted) {
            await delayFuture;
          }

          validations.value = fetchedValidations;
          _updateRemainingTimes(); // Initial calculation
          _calculateUnreadCount(); // 🔥 Calculate unread validations
          isLoading.value = false;

          // Complete the future if it hasn't been completed
          if (!completer.isCompleted) {
            completer.complete();
          }
          
        } catch (e) {
          print('Error processing validation stream: $e');
          // Even on error, we should complete to stop listeners waiting indefinitely
          if (!completer.isCompleted) { 
             isLoading.value = false; // ensure loader hides
             completer.complete(); 
          }
        }
      }, onError: (e) {
         print('Stream error: $e');
         isLoading.value = false;
         if (!completer.isCompleted) completer.complete();
      });

      return completer.future;
    } catch (e) {
      print('Error initializing validation stream: $e');
      isLoading.value = false;
    }
  }

  /// Load last seen timestamp (can be from SharedPreferences or Firestore)
  void _loadLastSeenTimestamp() {
    // For now, set to current time on first load
    // In production, load from SharedPreferences
    lastSeenTimestamp = DateTime.now();
  }

  /// Mark all current validations as seen
  void markValidationsAsSeen() {
    lastSeenTimestamp = DateTime.now();
    unreadValidationCount.value = 0;
    // Optionally save to SharedPreferences for persistence
  }

  /// Calculate unread count based on validations added after lastSeenTimestamp
  void _calculateUnreadCount() {
    if (!isScreenVisible.value && lastSeenTimestamp != null) {
      int count = 0;
      for (var validation in validations) {
        final rejectedAt = validation['rejectedAt'];
        DateTime validationTime;
        
        if (rejectedAt is Timestamp) {
          validationTime = rejectedAt.toDate();
        } else if (rejectedAt is String) {
          validationTime = DateTime.parse(rejectedAt);
        } else {
          continue;
        }
        
        // Count validations that came after last seen
        if (validationTime.isAfter(lastSeenTimestamp!)) {
          count++;
        }
      }
      unreadValidationCount.value = count;
    } else if (isScreenVisible.value) {
      // If screen is visible, no unread count
      unreadValidationCount.value = 0;
    }
  }

  /// Call this when user enters the validation hub screen
  void onScreenVisible() {
    isScreenVisible.value = true;
    markValidationsAsSeen();
  }

  /// Call this when user leaves the validation hub screen
  void onScreenHidden() {
    isScreenVisible.value = false;
  }
}
