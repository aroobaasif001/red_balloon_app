import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/task_service.dart';
import 'package:red_balloon_app/services/wallet_service.dart';

class ValidationScreenController extends GetxController {
  final TaskService _taskService = TaskService();
  final WalletService _walletService = WalletService();
  final NotificationService _notificationService = NotificationService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables for task data
  var isLoading = true.obs;
  var taskTitle = ''.obs;
  var taskId = ''.obs;
  var taskDescription = ''.obs;
  var userId = ''.obs;
  var beforePhotoUrl = ''.obs;
  var afterPhotoUrl = ''.obs;
  var submittedTime = ''.obs;
  var votesReceived = 0.obs;
  var votesNeeded = 0.obs;
  var isTaskOwner = false.obs; // 🔥 Check if current user owns the task
  var hasVoted = false.obs; // 🔥 Check if user already voted
  var isProofSubmitter =
      false.obs; // 🔥 Check if current user submitted the proof
  var submittedTimeDisplay = ''.obs; // 🔥 For static display of time ago

  // 🔥 Timer observables
  var remainingTime = '15:00'.obs; // Display format MM:SS
  var remainingSeconds = 900.obs; // 15 minutes = 900 seconds
  Timer? _timer;

  // 🔥 Voting calculation
  var helperVotes = 0.obs;
  var requesterVotes = 0.obs;
  var validationId = ''.obs;
  var rejectedAt = Rx<DateTime?>(null);
  var completedAt = Rx<DateTime?>(null); // 🔥 For "Submitted time ago"

  // 🔥 Participant Names
  var requesterName = 'Requester'.obs;
  var helperName = 'Helper'.obs;
  var requesterPhotoUrl = ''.obs;
  var helperPhotoUrl = ''.obs;
  var requesterRating = 5.0.obs;
  var helperRating = 5.0.obs;

  // 🔥 Track Current User's Vote
  var myVote = ''.obs; // 'helper' or 'requester'

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Format time ago for "Submitted ... ago"
  String getSubmittedTimeAgo() {
    if (completedAt.value == null) return '';

    final now = DateTime.now();
    final difference = now.difference(completedAt.value!);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months m ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }

  /// Fetch task details using taskId from validation
  /// Fetch task details using taskId from validation
  Future<void> fetchTaskDetails({
    required String validationTaskId,
    required String validationUserId,
    required String validationBeforePhoto,
    required String validationAfterPhoto,
    String? proofId,
    String? validationDocId, // 🔥 Added validationDocId
  }) async {
    try {
      isLoading.value = true;
      print('🔍 ValidationScreenController: Fetching details for Task $validationTaskId');

      // 1. Set initial data from params
      taskId.value = validationTaskId;
      userId.value = validationUserId;
      beforePhotoUrl.value = (validationBeforePhoto == 'null' || !validationBeforePhoto.trim().startsWith('http')) 
          ? '' : validationBeforePhoto.trim();
      afterPhotoUrl.value = (validationAfterPhoto == 'null' || !validationAfterPhoto.trim().startsWith('http')) 
          ? '' : validationAfterPhoto.trim();

      // 2. 🔥 FETCH VALIDATION DOC FIRST (to get photos from there as shown in screenshot)
      DocumentSnapshot? vDoc;
      if (validationDocId != null && validationDocId.isNotEmpty) {
        vDoc = await _firestore.collection('validations').doc(validationDocId).get();
      } else {
        final vSnap = await _firestore
            .collection('validations')
            .where('taskId', isEqualTo: validationTaskId)
            .limit(1)
            .get();
        if (vSnap.docs.isNotEmpty) {
          vDoc = vSnap.docs.first;
        }
      }

      if (vDoc != null && vDoc.exists) {
        final vData = vDoc.data() as Map<String, dynamic>;
        validationId.value = vDoc.id;
        
        // Update photos if found in doc
        String? b = vData['beforePhotoUrl'] ?? vData['beforeImageUrl'];
        String? a = vData['afterPhotoUrl'] ?? vData['afterImageUrl'];
        
        if (b != null && b.trim().isNotEmpty && b != 'null') {
          beforePhotoUrl.value = b.trim();
          print('📸 Photo from Validation Doc (Before): ${beforePhotoUrl.value}');
        }
        if (a != null && a.trim().isNotEmpty && a != 'null') {
          afterPhotoUrl.value = a.trim();
          print('📸 Photo from Validation Doc (After): ${afterPhotoUrl.value}');
        }

        // Set timestamps
        if (vData['completedAt'] != null) {
          completedAt.value = (vData['completedAt'] as Timestamp).toDate();
          submittedTimeDisplay.value = getSubmittedTimeAgo(); // Set initial value
        }
        if (vData['rejectedAt'] != null) {
          rejectedAt.value = (vData['rejectedAt'] as Timestamp).toDate();
          _startTimer();
        }
      }

      // 3. Fetch task details from tasks collection
      final taskData = await _taskService.getTaskById(validationTaskId);

      if (taskData != null) {
        taskTitle.value = taskData['title'] ?? 'No Title';
        taskDescription.value =
            taskData['description'] ?? 'No description available';

        // Fallback: If beforePhotoUrl is still empty, use task image
        if (beforePhotoUrl.value.isEmpty && taskData['imageUrl'] != null) {
          beforePhotoUrl.value = taskData['imageUrl'];
          print('📸 Task Image Fallback (Before): ${beforePhotoUrl.value}');
        }

        // Check if current user owns this task
        final currentUserId = _auth.currentUser?.uid;
        final taskOwnerId = taskData['uid'];
        isTaskOwner.value = (currentUserId == taskOwnerId);

        // Fetch Requester Name & Rating
        if (taskOwnerId != null) {
          final userDoc = await _firestore.collection('users').doc(taskOwnerId).get();
          if (userDoc.exists) {
            final data = userDoc.data();
            requesterName.value = data?['displayName'] ?? 'Requester';
            requesterPhotoUrl.value = data?['photoURL'] ?? '';
            _fetchUserRating(taskOwnerId, isHelper: false);
          }
        }

        // 4. Fetch proof submitter data & Proof Image Fallback
        String finalProofId = proofId ?? vDoc?.get('proofId') ?? '';
        if (finalProofId.isNotEmpty) {
          await _fetchProofSubmitterUserId(finalProofId, currentUserId);
        }

        // 5. Final fallback for After photo from task document if still empty
        if (afterPhotoUrl.value.isEmpty) {
           afterPhotoUrl.value = taskData['afterPhotoUrl'] ?? 
                                 taskData['afterImageUrl'] ?? 
                                 taskData['after_photo_url'] ?? '';
           if (afterPhotoUrl.value.isNotEmpty) {
             print('📸 Task Doc Fallback (After): ${afterPhotoUrl.value}');
           }
        }

        // Fetch voting data
        await _fetchVotingData(validationTaskId);
      }

      print('✅ ValidationScreenController Fetch Complete:');
      print('📊 Final Before: "${beforePhotoUrl.value}"');
      print('📊 Final After: "${afterPhotoUrl.value}"');

      isLoading.value = false;
    } catch (e) {
      print('❌ Error fetching task details: $e');
      isLoading.value = false;
    }
  }

  /// Fetch proof submitter's userId and Name from task_proofs collection
  Future<void> _fetchProofSubmitterUserId(
    String proofId,
    String? currentUserId,
  ) async {
    try {
      final proofDoc = await _firestore
          .collection('task_proofs')
          .doc(proofId)
          .get();

      if (proofDoc.exists) {
        final proofData = proofDoc.data()!;
        final proofSubmitterUserId =
            proofData['userId']; // UID of proof submitter

        // 🔥 Set After Photo if empty - check multiple variants
        if (afterPhotoUrl.value.isEmpty || afterPhotoUrl.value == 'null') {
          String? foundUrl = proofData['afterPhotoUrl'] ?? 
                             proofData['afterImageUrl'] ?? 
                             proofData['after_photo_url'] ?? 
                             proofData['afterPhoto'];
          
          if (foundUrl != null && foundUrl.trim().isNotEmpty && foundUrl != 'null') {
            afterPhotoUrl.value = foundUrl.trim();
            print('📸 Set After Photo from direct proof fetch: ${afterPhotoUrl.value}');
          } else {
            print('⚠️ No valid after photo found in Proof Doc ${proofDoc.id}. Available keys: ${proofData.keys.toList()}');
          }
        }

        // Check if current user is the proof submitter
        isProofSubmitter.value = (currentUserId == proofSubmitterUserId);

        print('🔍 Proof Submitter: $proofSubmitterUserId');
        print('🔍 Is Proof Submitter: ${isProofSubmitter.value}');

        // 🔥 Fetch Helper Name
        if (proofSubmitterUserId != null) {
          final userDoc = await _firestore
              .collection('users')
              .doc(proofSubmitterUserId)
              .get();
          if (userDoc.exists) {
            final data = userDoc.data();
            helperName.value = data?['displayName'] ?? 'Helper';
            helperPhotoUrl.value = data?['photoURL'] ?? '';
            print('🔍 Helper: ${helperName.value}, Photo: ${helperPhotoUrl.value}');
            _fetchUserRating(proofSubmitterUserId, isHelper: true);
          }
        }
      }
    } catch (e) {
      print('❌ Error fetching proof submitter data: $e');
    }
  }

  /// Fetch voting data from Firestore
  Future<void> _fetchVotingData(String taskId) async {
    try {
      // 🔥 Fetch validation document to get rejectedAt timestamp
      final validationSnapshot = await _firestore
          .collection('validations')
          .where('taskId', isEqualTo: taskId)
          .limit(1)
          .get();

      if (validationSnapshot.docs.isNotEmpty) {
        final validationDoc = validationSnapshot.docs.first;
        validationId.value = validationDoc.id;
        final vData = validationDoc.data();

        // 🔥 Get photos directly from validation doc if not already set
        if (beforePhotoUrl.value.isEmpty || beforePhotoUrl.value == 'null') {
          String? bp = vData['beforePhotoUrl'] ?? vData['beforeImageUrl'];
          if (bp != null && bp.trim().isNotEmpty && bp != 'null') {
             beforePhotoUrl.value = bp.trim();
             print('📸 Found Before Photo in Validation Doc: ${beforePhotoUrl.value}');
          }
        }
        
        if (afterPhotoUrl.value.isEmpty || afterPhotoUrl.value == 'null') {
          String? ap = vData['afterPhotoUrl'] ?? vData['afterImageUrl'];
          if (ap != null && ap.trim().isNotEmpty && ap != 'null') {
             afterPhotoUrl.value = ap.trim();
             print('📸 Found After Photo in Validation Doc: ${afterPhotoUrl.value}');
          }
        }

        // Get rejectedAt timestamp
        final Timestamp? timestamp = vData['rejectedAt'];
        if (timestamp != null) {
          rejectedAt.value = timestamp.toDate();
          _startTimer(); // 🔥 Start 15-minute countdown
        }

        // 🔥 Get completedAt timestamp for "Submitted time ago"
        final Timestamp? completedTimestamp = vData['completedAt'];
        if (completedTimestamp != null) {
          completedAt.value = completedTimestamp.toDate();
        }
      }

      final votingDoc = await _firestore.collection('voting').doc(taskId).get();

      if (votingDoc.exists) {
        final data = votingDoc.data()!;
        votesReceived.value = data['votesReceived'] ?? 0;
        votesNeeded.value = data['votesNeeded'] ?? 9;

        // 🔥 Calculate helper vs requester votes
        final voters = List<Map<String, dynamic>>.from(data['voters'] ?? []);
        helperVotes.value = voters
            .where((v) => v['voteType'] == 'helper')
            .length;
        requesterVotes.value = voters
            .where((v) => v['voteType'] == 'requester')
            .length;

        // Check if current user already voted
        final currentUserId = _auth.currentUser?.uid;
        final myVoteData = voters.firstWhereOrNull(
          (voter) => voter['userId'] == currentUserId,
        );

        hasVoted.value = myVoteData != null;
        if (hasVoted.value) {
          myVote.value = myVoteData!['voteType'] ?? '';
        } else {
          myVote.value = '';
        }

        // 🔥 Check if voting should be completed
        _checkVotingCompletion();
      } else {
        // Initialize voting document if it doesn't exist
        votesReceived.value = 0;
        votesNeeded.value = 9;
        helperVotes.value = 0;
        requesterVotes.value = 0;
        hasVoted.value = false;
        myVote.value = '';
      }
    } catch (e) {
      print('❌ Error fetching voting data: $e');
    }
  }

  /// Start 15-minute countdown timer
  void _startTimer() {
    if (rejectedAt.value == null) return;

    _timer?.cancel(); // Cancel any existing timer

    // Calculate remaining time
    final now = DateTime.now();
    final endTime = rejectedAt.value!.add(Duration(minutes: 15));
    final difference = endTime.difference(now);

    if (difference.isNegative) {
      // Timer expired
      remainingTime.value = '00:00';
      remainingSeconds.value = 0;
      _handleTimerExpiry();
      return;
    }

    remainingSeconds.value = difference.inSeconds;
    _updateTimerDisplay();

    // Update timer every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        _updateTimerDisplay();
      } else {
        timer.cancel();
        _handleTimerExpiry();
      }
    });
  }

  /// Update timer display format (MM:SS)
  void _updateTimerDisplay() {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    remainingTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Handle timer expiry
  void _handleTimerExpiry() {
    print('⏰ Voting timer expired - Setting isVotingCompleted to true');
    _finalizeVoting();
  }

  /// Check if voting reached threshold (but don't set isVotingCompleted yet)
  Future<void> _checkVotingCompletion() async {
    // 🔥 Voting closes when either side gets 5 votes
    if (helperVotes.value >= 5 || requesterVotes.value >= 5) {
      final winner = helperVotes.value >= 5 ? 'helper' : 'requester';
      await _recordWinner(winner: winner);

      // 🔥 Stop accepting new votes but DON'T set isVotingCompleted
      // Timer keeps running until 15 minutes
      // Get.snackbar(
      //   'Voting Closed',
      //   'The $winner has won! Waiting for timer to complete.',
      // );
    }
  }

  /// Record winner but don't set isVotingCompleted
  Future<void> _recordWinner({required String winner}) async {
    try {
      await _firestore.collection('validations').doc(validationId.value).update(
        {
          'winner': winner,
          'helperVotes': helperVotes.value,
          'requesterVotes': requesterVotes.value,
          'votingClosedAt': FieldValue.serverTimestamp(),
          // 🔥 isVotingCompleted stays false until timer expires
        },
      );

      print('✅ Winner recorded: $winner (Timer still running)');
    } catch (e) {
      print('❌ Error recording winner: $e');
    }
  }

  /// Finalize voting when timer expires (ONLY place isVotingCompleted = true)
  Future<void> _finalizeVoting() async {
    try {
      // 0. Check if already distributed in DB (to handle manual resets correctly)
      final vDoc = await _firestore.collection('validations').doc(validationId.value).get();
      if (vDoc.exists && (vDoc.data() as Map<String, dynamic>)['isFundsDistributed'] == true) {
        print('ℹ️ Validation ${validationId.value} already paid. Closing.');
        await _firestore.collection('validations').doc(validationId.value).update({'isVotingCompleted': true});
        return;
      }

      // Determine winner only if consensus reached (5+ votes)
      String? winner;
      if (helperVotes.value >= 5 || requesterVotes.value >= 5) {
        winner = helperVotes.value >= 5 ? 'helper' : 'requester';
      } else {
        // 🔥 No consensus after 15 minutes -> Send to admin
        await _sendToAdmin();
        return;
      }

      // 🔥 1. PRE-FINALIZATION TASKS (Distribute Funds & Notifications)
      final taskData = await _taskService.getTaskById(taskId.value);
      if (taskData != null) {
        final totalAmount = (taskData['budget'] ?? 0.0).toDouble();
        final helperUid = taskData['acceptedOfferUid'];
        final requesterUid = taskData['uid'];
        final taskTitle = taskData['title'] ?? 'Task';

        // Fetch latest voting doc for voters list
        final votingDoc = await _firestore.collection('voting').doc(taskId.value).get();
        if (votingDoc.exists) {
          final votersData = List<Map<String, dynamic>>.from(votingDoc.data()?['voters'] ?? []);
          final winnerVoterUids = votersData
              .where((v) => v['voteType'] == winner)
              .map((v) => (v['userId'] ?? v['uid']) as String)
              .toList();

          // A. Distribute Funds (Updates Wallet, Escrow, and Validation doc)
          final distributionResult = await _walletService.distributeValidationFunds(
            validationId: validationId.value,
            taskId: taskId.value,
            winner: winner!,
            winnerVoterUids: winnerVoterUids,
            totalAmount: totalAmount,
            taskTitle: taskTitle,
            helperUid: helperUid,
            requesterUid: requesterUid,
          );

          if (distributionResult['success'] == true) {
            // B. Mark Task as payment finalized
            await _firestore.collection('tasks').doc(taskId.value).update({
              'isPaymentFinalized': true,
              'status': winner == 'helper' ? 'completed' : 'refunded',
            });

            // C. Send Notifications
            await _notificationService.notifyValidationWinner(
              winnerId: winner == 'helper' ? helperUid! : requesterUid!,
              taskTitle: taskTitle,
              taskId: taskId.value,
              amount: distributionResult['winnerAmount'],
              isRefund: winner == 'requester',
            );

            if (winnerVoterUids.isNotEmpty) {
              final sharePerVoter = (distributionResult['voterShareTotal'] ?? 0.0) / winnerVoterUids.length;
              for (var vUid in winnerVoterUids) {
                await _notificationService.notifyValidationVoterReward(
                  voterId: vUid,
                  taskTitle: taskTitle,
                  taskId: taskId.value,
                  amount: sharePerVoter,
                );
              }
            }

            // D. FINALLY Mark validation as completed so it disappears from hub/screen
            final updateData = {
              'isVotingCompleted': true,
              'winner': winner,
              'helperVotes': helperVotes.value,
              'requesterVotes': requesterVotes.value,
            };

            // Only update completedAt if it doesn't exist yet
            if (vDoc.exists && (vDoc.data() as Map<String, dynamic>?)?['completedAt'] == null) {
              updateData['completedAt'] = FieldValue.serverTimestamp();
            }

            await _firestore.collection('validations').doc(validationId.value).update(updateData);
            
            // Sync local display
            if (completedAt.value == null) {
              completedAt.value = DateTime.now();
            }
            submittedTimeDisplay.value = getSubmittedTimeAgo();

            print('✅ Manual Finalization Successful for $winner');
          } else {
            print('⚠️ Manual distribution failed: ${distributionResult['message']}');
          }
        }
      }

      Get.snackbar(
        'Validation Complete',
        'Timer expired. Final result: $winner wins!',
      );
    } catch (e) {
      print('❌ Error finalizing voting: $e');
    }
  }

  /// Send to admin for manual review
  Future<void> _sendToAdmin() async {
    try {
      await _firestore
          .collection('validations')
          .doc(validationId.value)
          .update({
            'isVotingCompleted': true,
            'sentToAdmin': true,
            'helperVotes': helperVotes.value,
            'requesterVotes': requesterVotes.value,
            'completedAt': FieldValue.serverTimestamp(),
          });

      print('📤 Sent to admin for review');

      // 🔥 Notify Admin
      _notificationService.notifyAdminNewTaskToValidation(
        taskTitle.value,
        taskId.value,
      );

      Get.snackbar(
        'Admin Review',
        'Votes are tied. Sent to admin for manual review.',
      );
    } catch (e) {
      print('❌ Error sending to admin: $e');
    }
  }

  /// Submit vote to Firestore
  Future<void> submitVote(String voteType) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Check if user already voted
      if (hasVoted.value) {
        Get.snackbar('Already Voted', 'You have already voted on this task');
        return;
      }

      // Check if user is task owner
      if (isTaskOwner.value) {
        Get.snackbar('Not Allowed', 'You cannot vote on your own task');
        return;
      }

      // 🔥 Check if user is proof submitter
      if (isProofSubmitter.value) {
        Get.snackbar('Not Allowed', 'You cannot vote on your own proof');
        return;
      }

      final votingRef = _firestore.collection('voting').doc(taskId.value);
      final votingDoc = await votingRef.get();

      if (votingDoc.exists) {
        // Update existing voting document
        await votingRef.update({
          'votesReceived': FieldValue.increment(1),
          'voters': FieldValue.arrayUnion([
            {
              'userId': currentUserId,
              'voteType': voteType, // 'helper' or 'requester'
              'votedAt': DateTime.now()
                  .toIso8601String(), // Use DateTime instead of serverTimestamp
            },
          ]),
        });
      } else {
        // Create new voting document
        await votingRef.set({
          'taskId': taskId.value,
          'votesNeeded': 9,
          'votesReceived': 1,
          'voters': [
            {
              'userId': currentUserId,
              'voteType': voteType,
              'votedAt': DateTime.now()
                  .toIso8601String(), // Use DateTime instead of serverTimestamp
            },
          ],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Update local state
      votesReceived.value++;
      hasVoted.value = true;
      myVote.value = voteType; // 🔥 Update local vote state

      // 🔥 Update helper/requester vote counts
      if (voteType == 'helper') {
        helperVotes.value++;
      } else {
        requesterVotes.value++;
      }

      Get.snackbar('Success', 'Your vote has been recorded');

      print('✅ Vote submitted: $voteType');
      print(
        '📊 Helper votes: ${helperVotes.value}, Requester votes: ${requesterVotes.value}',
      );

      await _checkVotingCompletion();
    } catch (e) {
      print('❌ Error submitting vote: $e');
      Get.snackbar('Error', 'Failed to submit vote');
    }
  }

  Future<void> _fetchUserRating(String uid, {required bool isHelper}) async {
    try {
      print('⭐ ValidationScreenController: Starting Exhaustive Rating Fetch for $uid (isHelper: $isHelper)');
      double sum = 0;
      int count = 0;

      // 1. Fetch as Helper (Requester left feedback)
      final hTasks = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .get();
      
      for (var doc in hTasks.docs) {
        final data = doc.data();
        // Check for any feedback from the requester
        final feedback = data['requesterFeedback'] ?? data['requester_feedback'];
        if (feedback != null) {
          final r = (feedback['rating'] ?? 0).toDouble();
          if (r > 0) {
            sum += r;
            count++;
            print('   - Found Helper Feedback: $r from Task ${doc.id}');
          }
        }
      }

      // 2. Fetch as Requester (Helper left feedback)
      final rTasks = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();

      for (var doc in rTasks.docs) {
        final data = doc.data();
        // Check for any feedback from the helper
        final feedback = data['helperFeedback'] ?? data['helper_feedback'];
        if (feedback != null) {
          final r = (feedback['rating'] ?? 0).toDouble();
          if (r > 0) {
            sum += r;
            count++;
            print('   - Found Requester Feedback: $r from Task ${doc.id}');
          }
        }
      }

      if (count > 0) {
        final finalRating = sum / count;
        if (isHelper) {
          helperRating.value = finalRating;
        } else {
          requesterRating.value = finalRating;
        }
        print('✅ Final Calculated Rating for $uid: $finalRating (count: $count)');
      } else {
        // 3. Fallback: Fetch directly from User document if no task feedback found
        print('ℹ️ No task feedback found for $uid. Checking user doc...');
        final userDoc = await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          final userRating = (userData?['rating'] ?? userData?['averageRating'] ?? 5.0).toDouble();
          if (isHelper) {
            helperRating.value = userRating;
          } else {
            requesterRating.value = userRating;
          }
          print('✅ Fallback Rating from User Doc for $uid: $userRating');
        }
      }
    } catch (e) {
      print("❌ Error fetching exhaustive rating for $uid: $e");
    }
  }
}
