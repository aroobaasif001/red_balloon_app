import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/wallet_service.dart';

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

  // IDs for payment processing
  String? _currentValidationId;
  String? _currentTaskId;
  String? _currentHelperUid;
  String? _currentRequesterUid;
  double? _currentTotalAmount;

  /// Fetch all task details
  Future<void> fetchTaskDetails(String validationId) async {
    try {
      isLoading.value = true;
      print('🔍 Fetching task details for validation: $validationId');

      // 1. Fetch validation document
      final validationDoc = await _firestore
          .collection('validations')
          .doc(validationId)
          .get();

      if (!validationDoc.exists) {
        print('❌ Validation not found');
        isLoading.value = false;
        return;
      }

      final validationData = validationDoc.data()!;
      _currentValidationId = validationId;
      final taskId = validationData['taskId'];
      _currentTaskId = taskId;
      final proofId = validationData['proofId'];

      print('📄 Validation Document ID: $validationId');
      print('📄 Validation Data: $validationData');

      rejectionReason.value =
          validationData['rejectionReason'] ?? 'No reason provided';
      beforePhotoUrl.value = validationData['beforePhotoUrl'] ?? '';
      afterPhotoUrl.value = validationData['afterPhotoUrl'] ?? '';

      // 🔥 Fetch votes directly from validation document
      final helperVotesFromDB = validationData['helperVotes'];
      final requesterVotesFromDB = validationData['requesterVotes'];

      print(
        '🔍 RAW helperVotes from DB: $helperVotesFromDB (type: ${helperVotesFromDB.runtimeType})',
      );
      print(
        '🔍 RAW requesterVotes from DB: $requesterVotesFromDB (type: ${requesterVotesFromDB.runtimeType})',
      );

      supportHelperVotes.value = helperVotesFromDB ?? 0;
      supportRequesterVotes.value = requesterVotesFromDB ?? 0;
      totalVotes.value = supportHelperVotes.value + supportRequesterVotes.value;

      print(
        '✅ FINAL Votes - Helper: ${supportHelperVotes.value}, Requester: ${supportRequesterVotes.value}, Total: ${totalVotes.value}',
      );

      // Calculate completed time
      if (validationData['rejectedAt'] != null) {
        DateTime rejectedAt;
        if (validationData['rejectedAt'] is String) {
          rejectedAt = DateTime.parse(validationData['rejectedAt']);
        } else {
          rejectedAt = (validationData['rejectedAt'] as Timestamp).toDate();
        }
        completedTime.value = _getTimeAgo(rejectedAt);
      }

      // 2. Fetch task details and REQUESTER UID
      String? requesterUid = null;
      if (taskId != null) {
        print('📋 Fetching task details for taskId: $taskId');
        final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
        if (taskDoc.exists) {
          final taskData = taskDoc.data()!;
          taskTitle.value = taskData['title'] ?? 'No Title';
          taskDescription.value =
              taskData['description'] ?? 'No description available';
          requesterUid = taskData['uid']; // 🔥 Get requester UID from task.uid
          _currentRequesterUid = requesterUid;
          _currentTotalAmount = (taskData['budget'] ?? 0.0).toDouble();
          print('✅ Task title: ${taskTitle.value}');
          print('✅ Task description: ${taskDescription.value}');
          print('✅ Requester UID from task.uid: $requesterUid');
        } else {
          print('❌ Task document not found');
        }
      }

      // 3. Fetch REQUESTER details using UID from task.uid
      if (requesterUid != null) {
        print('👤 Fetching REQUESTER details for UID: $requesterUid');
        await _fetchUserDetails(requesterUid, isHelper: false);
      } else {
        print('⚠️ Requester UID not found in task');
      }

      // 4. Fetch HELPER details from task_proofs
      if (proofId != null) {
        print('👷 Fetching proof details for proofId: $proofId');
        final proofDoc = await _firestore
            .collection('task_proofs')
            .doc(proofId)
            .get();
        if (proofDoc.exists) {
          final proofData = proofDoc.data()!;
          final helperUid =
              proofData['userId']; // 🔥 Get helper UID from proof.userId
          _currentHelperUid = helperUid;
          print('👷 Helper UID from task_proofs.userId: $helperUid');
          if (helperUid != null) {
            print('👤 Fetching HELPER details for UID: $helperUid');
            await _fetchUserDetails(helperUid, isHelper: true);
          } else {
            print('⚠️ Helper userId is null in proof');
          }
        } else {
          print('❌ Proof document not found');
        }
      } else {
        print('⚠️ proofId is null');
      }

      isLoading.value = false;
      print('✅ Task details loaded successfully');
    } catch (e) {
      print('❌ Error fetching task details: $e');
      isLoading.value = false;
    }
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

          print('📊 Task creator: $name ($userId)');
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
}
