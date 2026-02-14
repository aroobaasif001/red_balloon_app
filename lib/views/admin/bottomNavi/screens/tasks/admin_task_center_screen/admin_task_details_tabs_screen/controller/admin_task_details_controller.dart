import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:intl/intl.dart';

import '../../controller/admin_validation_tasks_controller.dart';

class AdminTaskDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WalletService _walletService = WalletService();
  final NotificationService _notificationService = NotificationService.instance;

  // Observables
  var isLoading = true.obs;
  var taskTitle = ''.obs;
  var taskDescription = ''.obs; // 🔥 Added task description
  var rejectionReason = ''.obs;
  var completedTime = ''.obs;
  var taskCreatorUserId = ''.obs;
  var taskCreatorName = ''.obs;
  var taskCreatorImage = ''.obs;
  var requesterLocation = 'N/A'.obs;
  var requesterPostedTasks = 0.obs;
  var requesterMemberSince = 'N/A'.obs;

  var helperUserId = ''.obs;
  var helperName = ''.obs;
  var helperImage = ''.obs;
  var helperTasksCount = 0.obs;
  var helperRating = 0.0.obs;
  var helperResponseTime = ''.obs;

  var beforePhotoUrl = ''.obs;
  var afterPhotoUrl = ''.obs;

  var supportRequesterVotes = 0.obs;
  var supportHelperVotes = 0.obs;
  var totalVotes = 0.obs;

  // 🔥 Task Details specific observables
  var escrowAmount = 'SAR 0.00'.obs;
  var timeTaken = 'Loading...'.obs;
  var taskCategory = 'Loading...'.obs;
  var postedAt = 'Loading...'.obs;
  var taskLocation = 'Loading...'.obs;

  double? _currentTotalAmount;
  String? _currentValidationId;
  String? _currentTaskId;
  String? _currentHelperUid;
  String? _currentRequesterUid;

  // Stream Subscriptions
  StreamSubscription? _validationSubscription;
  StreamSubscription? _taskSubscription;
  StreamSubscription? _proofSubscription;

  @override
  void onClose() {
    _validationSubscription?.cancel();
    _taskSubscription?.cancel();
    _proofSubscription?.cancel();
    super.onClose();
  }

  /// Fetch all task details
  Future<void> fetchTaskDetails(String validationId) async {
    try {
      isLoading.value = true;
      print('🔍 Initializing real-time listeners for validation: $validationId');

      _currentValidationId = validationId;

      // 🔥 1. Setup Validation Listener (Votes, Photos, Rejection Reason)
      _validationSubscription?.cancel();
      _validationSubscription = _firestore
          .collection('validations')
          .doc(validationId)
          .snapshots()
          .listen((validationDoc) async {
        if (!validationDoc.exists) return;

        final validationData = validationDoc.data()!;
        
        // Update basic fields
        rejectionReason.value = validationData['rejectionReason'] ?? 'No reason provided';
        beforePhotoUrl.value = validationData['beforePhotoUrl'] ?? '';
        afterPhotoUrl.value = validationData['afterPhotoUrl'] ?? '';

        // Update Votes
        supportHelperVotes.value = validationData['helperVotes'] ?? 0;
        supportRequesterVotes.value = validationData['requesterVotes'] ?? 0;
        totalVotes.value = supportHelperVotes.value + supportRequesterVotes.value;

        // Handle Rejected At (Completed Time)
        if (validationData['rejectedAt'] != null) {
          DateTime rejectedAt;
          if (validationData['rejectedAt'] is String) {
            rejectedAt = DateTime.parse(validationData['rejectedAt']);
          } else {
            rejectedAt = (validationData['rejectedAt'] as Timestamp).toDate();
          }
          completedTime.value = _getTimeAgo(rejectedAt);
        }

        final taskId = validationData['taskId'];
        final proofId = validationData['proofId'];

        // 🔥 2. Setup Task Listener (Title, Desc, Budget, Category)
        if (taskId != null && taskId != _currentTaskId) {
          _currentTaskId = taskId;
          _setupTaskStream(taskId);
        }

        // 🔥 3. Setup Proof Listener (Helper UID, Time Taken)
        if (proofId != null && proofId != _currentProofId) {
          _currentProofId = proofId;
          _setupProofStream(proofId, taskId);
        }
      });

      isLoading.value = false;
    } catch (e) {
      print('❌ Error setting up task listeners: $e');
      isLoading.value = false;
    }
  }

  String? _currentProofId;

  void _setupTaskStream(String taskId) {
    _taskSubscription?.cancel();
    _taskSubscription = _firestore
        .collection('tasks')
        .doc(taskId)
        .snapshots()
        .listen((taskDoc) async {
      if (!taskDoc.exists) return;

      final taskData = taskDoc.data()!;
      taskTitle.value = taskData['title'] ?? 'No Title';
      taskDescription.value = taskData['description'] ?? 'No description available';
      
      final requesterUid = taskData['uid'];
      if (requesterUid != _currentRequesterUid) {
        _currentRequesterUid = requesterUid;
        if (requesterUid != null) {
          _fetchUserDetails(requesterUid, isHelper: false);
        }
      }

      _currentTotalAmount = (taskData['budget'] ?? 0.0).toDouble();
      escrowAmount.value = 'SAR ${_currentTotalAmount?.toStringAsFixed(0)}';
      taskCategory.value = taskData['taskType'] ?? 'Offline Task';

      final createdAtRaw = taskData['createdAt'];
      if (createdAtRaw != null) {
        postedAt.value = _formatPostedAt(createdAtRaw);
      }

      taskLocation.value = taskData['location'] ?? 'Location not specified';
    });
  }

  void _setupProofStream(String proofId, String? taskId) {
    _proofSubscription?.cancel();
    _proofSubscription = _firestore
        .collection('task_proofs')
        .doc(proofId)
        .snapshots()
        .listen((proofDoc) async {
      if (!proofDoc.exists) return;

      final proofData = proofDoc.data()!;
      final helperUid = proofData['userId'];
      
      if (helperUid != _currentHelperUid) {
        _currentHelperUid = helperUid;
        if (helperUid != null) {
          _fetchUserDetails(helperUid, isHelper: true);
        }
      }

      // Calculate Time Taken (Needs acceptedAt from task)
      if (taskId != null) {
        final taskSnap = await _firestore.collection('tasks').doc(taskId).get();
        final acceptedAt = taskSnap.data()?['acceptedAt'];
        final submittedAt = proofData['submittedAt'];
        timeTaken.value = _calculateTimeTaken(acceptedAt, submittedAt);
      }
    });
  }

  /// Fetch user details from users collection
  Future<void> _fetchUserDetails(String uid, {required bool isHelper}) async {
    try {
      print('🔍 Fetching user details for UID: $uid (isHelper: $isHelper)');
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;

        // 🔥 DEBUG: Print ALL fields to see what's available
        print('📋 Available fields in user document:');
        userData.forEach((key, value) {
          print('   - $key: $value');
        });

        final userId = userData['userId'] ?? 'RB-00000';

        // 🔥 Try multiple possible field names for name
        String name = 'Unknown User';
        if (userData.containsKey('username') &&
            userData['username'] != null &&
            userData['username'].toString().isNotEmpty) {
          name = userData['username'];
        } else if (userData.containsKey('name') &&
            userData['name'] != null &&
            userData['name'].toString().isNotEmpty) {
          name = userData['name'];
        } else if (userData.containsKey('displayName') &&
            userData['displayName'] != null &&
            userData['displayName'].toString().isNotEmpty) {
          name = userData['displayName'];
        }

        // 🔥 Try multiple possible field names for image
        String image = '';
        if (userData.containsKey('photoURL') &&
            userData['photoURL'] != null &&
            userData['photoURL'].toString().isNotEmpty) {
          image = userData['photoURL'];
        } else if (userData.containsKey('profileImage') &&
            userData['profileImage'] != null &&
            userData['profileImage'].toString().isNotEmpty) {
          image = userData['profileImage'];
        } else if (userData.containsKey('profilePicture') &&
            userData['profilePicture'] != null &&
            userData['profilePicture'].toString().isNotEmpty) {
          image = userData['profilePicture'];
        }

        print('✅ User found: $name ($userId)');
        print('📸 User image: ${image.isNotEmpty ? image : "Not available"}');

        if (isHelper) {
          helperUserId.value = userId;
          helperName.value = name;
          helperImage.value = image;

          // Fetch helper stats
          helperTasksCount.value = userData['completedTasks'] ?? 0;
          helperRating.value = (userData['rating'] ?? 0.0).toDouble();
          helperResponseTime.value = _calculateResponseTime(
            userData['averageResponseTime'],
          );

          print(
            '📊 Helper stats - Tasks: ${helperTasksCount.value}, Rating: ${helperRating.value}',
          );
        } else {
          taskCreatorUserId.value = userId;
          taskCreatorName.value = name;
          taskCreatorImage.value = image;

          // 🔥 Real Location from City/Country
          final city = userData['city'] ?? '';
          final country = userData['country'] ?? '';
          if (city.isNotEmpty && country.isNotEmpty) {
            requesterLocation.value = '$city, $country';
          } else if (city.isNotEmpty) {
            requesterLocation.value = city;
          } else if (country.isNotEmpty) {
            requesterLocation.value = country;
          } else {
            requesterLocation.value = 'N/A';
          }

          // 🔥 Fetch Real Posted Tasks Count from tasks collection
          final postedSnap = await _firestore
              .collection('tasks')
              .where('uid', isEqualTo: uid)
              .get();
          requesterPostedTasks.value = postedSnap.docs.length;
          
          final joinedAt = userData['createdAt'];
          if (joinedAt != null) {
            requesterMemberSince.value = _calculateMemberSince(joinedAt);
          }

          print('📊 Task creator: $name ($userId) - Location: ${requesterLocation.value} - Posted: ${requesterPostedTasks.value}');
        }
      } else {
        print('❌ User document not found for UID: $uid');
      }
    } catch (e) {
      print('❌ Error fetching user details for $uid: $e');
    }
  }

  /// Admin explicitly approves payment to helper
  Future<void> approvePayment() async {
    await _distributeFunds(winner: 'helper');
  }

  /// Admin explicitly holds payment (refunds requester)
  Future<void> holdPayment() async {
    await _distributeFunds(winner: 'requester');
  }

  Future<void> _distributeFunds({required String winner}) async {
    if (_currentTaskId == null ||
        _currentValidationId == null ||
        _currentHelperUid == null ||
        _currentRequesterUid == null ||
        _currentTotalAmount == null) {
      Get.snackbar('Error', 'Missing task details for distribution');
      return;
    }

    try {
      isLoading.value = true;

      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.red)),
        barrierDismissible: false,
      );

      // 1. Fetch voters from voting collection
      final votingDoc = await _firestore
          .collection('voting')
          .doc(_currentTaskId)
          .get();
      List<String> winnerVoterUids = [];

      if (votingDoc.exists) {
        final data = votingDoc.data()!;
        final voters = List<Map<String, dynamic>>.from(data['voters'] ?? []);
        winnerVoterUids = voters
            .where((v) => v['voteType'] == winner)
            .map((v) => (v['userId'] ?? v['uid']) as String)
            .toList();
      }

      // 2. Distribute funds via WalletService
      final result = await _walletService.distributeValidationFunds(
        validationId: _currentValidationId!,
        taskId: _currentTaskId!,
        winner: winner,
        winnerVoterUids: winnerVoterUids,
        totalAmount: _currentTotalAmount!,
        taskTitle: taskTitle.value,
        helperUid: _currentHelperUid!,
        requesterUid: _currentRequesterUid!,
      );

      if (result['success'] == true) {
        // 3. Mark Task and Validation as completed
        await _firestore.collection('tasks').doc(_currentTaskId).update({
          'isPaymentFinalized': true,
          'status': winner == 'helper' ? 'completed' : 'refunded',
        });

        await _firestore
            .collection('validations')
            .doc(_currentValidationId)
            .update({
              'isVotingCompleted': true,
              'winner': winner,
              'completedAt': FieldValue.serverTimestamp(),
              'adminSettled': true,
            });

        // 4. Send Notifications
        // Notification to Winner
        await _notificationService.notifyValidationWinner(
          winnerId: winner == 'helper'
              ? _currentHelperUid!
              : _currentRequesterUid!,
          taskTitle: taskTitle.value,
          taskId: _currentTaskId!,
          amount: result['winnerAmount'],
          isRefund: winner == 'requester',
        );

        // Notification to Loser
        await _notificationService.notifyValidationLoser(
          loserId: winner == 'helper'
              ? _currentRequesterUid!
              : _currentHelperUid!,
          taskTitle: taskTitle.value,
          taskId: _currentTaskId!,
          isHelper: winner == 'requester', // true if the one who lost is helper
        );

        // Notification to Voters
        if (winnerVoterUids.isNotEmpty) {
          final sharePerVoter =
              (result['voterShareTotal'] ?? 0.0) / winnerVoterUids.length;
          for (var vUid in winnerVoterUids) {
            await _notificationService.notifyValidationVoterReward(
              voterId: vUid,
              taskTitle: taskTitle.value,
              taskId: _currentTaskId!,
              amount: sharePerVoter,
            );
          }
        }

        // 🔥 Refresh the validation list
        if (Get.isRegistered<AdminValidationTasksController>()) {
          Get.find<AdminValidationTasksController>().fetchValidationTasks();
        }

        Get.back(); // 1. Close the loading dialog
        Get.back(); // 2. Go back to the list screen

        Get.snackbar(
          'Success',
          'Payment distributed successfully to ${winner.capitalizeFirst}',
        );
      } else {
        Get.back(); // Close loading dialog
        Get.snackbar('Error', result['message'] ?? 'Distribution failed');
      }
    } catch (e) {
      if (Get.isOverlaysOpen) Get.back(); // Close loading dialog if open
      print('❌ Error in admin distribution: $e');
      Get.snackbar('Error', 'An error occurred during distribution: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Completed ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return 'Completed ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return 'Completed ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Completed just now';
    }
  }

  String _calculateResponseTime(dynamic avgResponseTime) {
    if (avgResponseTime == null) return '5 min';

    if (avgResponseTime is int) {
      if (avgResponseTime < 60) {
        return '$avgResponseTime min';
      } else {
        final hours = avgResponseTime ~/ 60;
        return '$hours hr${hours > 1 ? 's' : ''}';
      }
    }

    return '5 min';
  }

  String _formatPostedAt(dynamic createdAt) {
    DateTime dt;
    if (createdAt is String) {
      dt = DateTime.parse(createdAt);
    } else if (createdAt is Timestamp) {
      dt = createdAt.toDate();
    } else {
      return 'Unknown';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);

    if (date == today) {
      return "Today, ${DateFormat('h:mm a').format(dt)}";
    } else {
      return DateFormat('MMM d, h:mm a').format(dt);
    }
  }

  String _calculateTimeTaken(dynamic acceptedAt, dynamic submittedAt) {
    if (acceptedAt == null || submittedAt == null) return 'N/A';

    DateTime start;
    if (acceptedAt is String) {
      start = DateTime.parse(acceptedAt);
    } else if (acceptedAt is Timestamp) {
      start = acceptedAt.toDate();
    } else {
      return 'N/A';
    }

    DateTime end;
    if (submittedAt is String) {
      try {
        end = DateTime.parse(submittedAt);
      } catch (e) {
        return 'N/A';
      }
    } else if (submittedAt is Timestamp) {
      end = submittedAt.toDate();
    } else {
      return 'N/A';
    }

    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String _calculateMemberSince(dynamic joinedAt) {
    DateTime dt;
    if (joinedAt is String) {
      dt = DateTime.parse(joinedAt);
    } else if (joinedAt is Timestamp) {
      dt = joinedAt.toDate();
    } else {
      return 'N/A';
    }

    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years yr${years > 1 ? 's' : ''}';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''}';
    } else {
      return '${difference.inDays} days';
    }
  }
}
