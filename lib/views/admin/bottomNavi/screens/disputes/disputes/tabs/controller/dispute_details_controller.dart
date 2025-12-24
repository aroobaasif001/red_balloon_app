import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/wallet_service.dart';

class DisputeDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService.instance;
  final WalletService _walletService = WalletService();
  
  var isLoading = false.obs;
  
  // Task Info
  var taskTitle = ''.obs;
  var taskId = ''.obs;
  var taskBudget = 0.0.obs;
  var submittedTime = ''.obs;
  
  // Requester Info
  var requesterName = ''.obs;
  var requesterUserId = ''.obs;
  var requesterCity = ''.obs;
  var requesterImage = ''.obs;
  var requesterUid = ''.obs;
  
  // Helper Info
  var helperName = ''.obs;
  var helperUserId = ''.obs;
  var helperRating = 0.0.obs;
  var helperTasksCompleted = 0.obs;
  var helperImage = ''.obs;
  var helperUid = ''.obs;
  
  // Reports
  var requesterReport = ''.obs;
  var helperReport = ''.obs;
  
  /// Fetch all dispute details
  Future<void> fetchDisputeDetails(String taskId) async {
    try {
      isLoading.value = true;
      print('🔍 Fetching dispute details for task: $taskId');
      
      // 1. Fetch task document
      final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
      
      if (!taskDoc.exists) {
        print('❌ Task not found');
        isLoading.value = false;
        return;
      }
      
      final taskData = taskDoc.data()!;
      
      // Task basic info
      this.taskId.value = taskId;
      taskTitle.value = taskData['title'] ?? 'No Title';
      taskBudget.value = (taskData['budget'] ?? 0.0).toDouble();

      // Helper function to get non-empty report correctly
      String getFormattedReport(String detailsKey, String reasonKey) {
        String details = (taskData[detailsKey]?.toString() ?? '').trim();
        String reason = (taskData[reasonKey]?.toString() ?? '').trim();

        if (details.isNotEmpty && reason.isNotEmpty) {
          return '$reason: $details';
        } else if (details.isNotEmpty) {
          return details;
        } else if (reason.isNotEmpty) {
          return reason;
        }
        return '';
      }

      requesterReport.value =
          getFormattedReport('requesterHelpDetails', 'requesterHelpReason');
      helperReport.value =
          getFormattedReport('helperHelpDetails', 'helperHelpReason');

      // Initialize IDs from task data as fallback
      requesterUserId.value = taskData['userId'] ?? '';

      // Calculate submitted time
      if (taskData['disputedStartTime'] != null) {
        try {
          DateTime disputedTime;
          if (taskData['disputedStartTime'] is String) {
            disputedTime = DateTime.parse(taskData['disputedStartTime']);
          } else {
            disputedTime =
                (taskData['disputedStartTime'] as Timestamp).toDate();
          }
          submittedTime.value = _getTimeAgo(disputedTime);
        } catch (e) {
          print('❌ Error parsing disputed time: $e');
          submittedTime.value = 'Recently';
        }
      } else {
        submittedTime.value = 'Recently';
      }

      print('✅ Task info loaded: ${taskTitle.value}');

      // 2. Fetch Requester details (using task.uid)
      final requesterUidValue = taskData['uid'];
      if (requesterUidValue != null) {
        requesterUid.value = requesterUidValue;
        await _fetchRequesterDetails(requesterUidValue);
      }

      // 3. Fetch Helper details (using acceptedOfferUid)
      final helperUidValue = taskData['acceptedOfferUid'];
      if (helperUidValue != null) {
        helperUid.value = helperUidValue;
        await _fetchHelperDetails(helperUidValue);
      }

      isLoading.value = false;
      print('✅ Dispute details loaded successfully');
    } catch (e) {
      print('❌ Error fetching dispute details: $e');
      isLoading.value = false;
    }
  }

  /// Fetch requester user details
  Future<void> _fetchRequesterDetails(String uid) async {
    try {
      print('👤 Fetching requester details for UID: $uid');
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        requesterName.value = userData['username'] ??
            userData['displayName'] ??
            userData['name'] ??
            'Unknown User';

        // Only overwrite if userData has a valid userId
        if (userData['userId'] != null &&
            userData['userId'].toString().isNotEmpty) {
          requesterUserId.value = userData['userId'];
        }

        requesterCity.value =
            userData['city'] ?? userData['location'] ?? 'Unknown';
        requesterImage.value =
            userData['photoURL'] ?? userData['profileImage'] ?? '';

        print('✅ Requester: ${requesterName.value} (${requesterUserId.value})');
      } else {
        print('❌ Requester user not found');
      }
    } catch (e) {
      print('❌ Error fetching requester details: $e');
    }
  }

  /// Fetch helper user details
  Future<void> _fetchHelperDetails(String uid) async {
    try {
      print('👷 Fetching helper details for UID: $uid');
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        helperName.value = userData['username'] ??
            userData['displayName'] ??
            userData['name'] ??
            'Unknown User';

        if (userData['userId'] != null &&
            userData['userId'].toString().isNotEmpty) {
          helperUserId.value = userData['userId'];
        }

        helperRating.value = (userData['rating'] ?? 0.0).toDouble();
        helperTasksCompleted.value = userData['completedTasks'] ?? 0;
        helperImage.value =
            userData['photoURL'] ?? userData['profileImage'] ?? '';

        print('✅ Helper: ${helperName.value} (${helperUserId.value})');
        print(
            '📊 Helper stats - Rating: ${helperRating.value}, Tasks: ${helperTasksCompleted.value}');
      } else {
        print('❌ Helper user not found');
      }
    } catch (e) {
      print('❌ Error fetching helper details: $e');
    }
  }

  /// Warn Helper
  Future<void> warnHelper() async {
    if (helperUid.value.isEmpty) return;
    
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      await _notificationService.notifyDisputeWarning(
        userId: helperUid.value,
        taskTitle: taskTitle.value,
        taskId: taskId.value,
        role: 'Helper',
      );
      
      Get.back();
      Get.snackbar('Success', 'Warning sent to helper: ${helperName.value}',
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to send warning: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Warn Requester
  Future<void> warnRequester() async {
    if (requesterUid.value.isEmpty) return;
    
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      await _notificationService.notifyDisputeWarning(
        userId: requesterUid.value,
        taskTitle: taskTitle.value,
        taskId: taskId.value,
        role: 'Requester',
      );
      
      Get.back();
      Get.snackbar('Success', 'Warning sent to requester: ${requesterName.value}',
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to send warning: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Refund Payment (96% to requester, 1% to helper)
  Future<void> refundPayment() async {
    if (taskId.value.isEmpty || requesterUid.value.isEmpty || helperUid.value.isEmpty) {
      Get.snackbar('Error', 'Missing information to process refund',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final result = await _walletService.refundDisputeToRequester(
        taskId: taskId.value,
        requesterUid: requesterUid.value,
        helperUid: helperUid.value,
        totalAmount: taskBudget.value,
        taskTitle: taskTitle.value,
      );
      
      if (result['success']) {
        // Update task status in Firestore
        await _firestore.collection('tasks').doc(taskId.value).update({
          'status': 'Refunded',
          'disputeResolvedAt': FieldValue.serverTimestamp(),
          'resolution': 'Refunded: 96% to Requester, 1% to Helper',
        });
        
        // Notify both parties
        await _notificationService.notifyDisputeRefund(
          requesterId: requesterUid.value,
          helperId: helperUid.value,
          taskTitle: taskTitle.value,
          taskId: taskId.value,
          refundAmount: result['refundAmount'],
          helperAmount: result['helperAmount'],
        );
        
        Get.back();
        Get.snackbar('Success', 'Refund of 96% processed for requester and 1% payment for helper.',
        );
      } else {
        Get.back();
        Get.snackbar('Error', result['message'] ?? 'Failed to process refund',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Refund error: $e');
      Get.back();
      Get.snackbar('Error', 'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Dismiss Dispute (85% to Helper, 7.5% to Requester)
  Future<void> dismissDispute() async {
    if (taskId.value.isEmpty || requesterUid.value.isEmpty || helperUid.value.isEmpty) {
      Get.snackbar('Error', 'Missing information to resolve dispute',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final result = await _walletService.dismissDisputeWithSplit(
        taskId: taskId.value,
        requesterUid: requesterUid.value,
        helperUid: helperUid.value,
        totalAmount: taskBudget.value,
        taskTitle: taskTitle.value,
      );
      
      if (result['success']) {
        // Update task status in Firestore
        await _firestore.collection('tasks').doc(taskId.value).update({
          'status': 'Dispute Dismissed',
          'disputeResolvedAt': FieldValue.serverTimestamp(),
          'resolution': 'Dispute dismissed by admin. Split: 85% Helper, 7.5% Requester',
        });
        
        // Notify both parties
        await _notificationService.notifyDisputeDismissedSplit(
          helperId: helperUid.value,
          requesterId: requesterUid.value,
          taskTitle: taskTitle.value,
          taskId: taskId.value,
          helperAmount: result['helperAmount'],
          requesterRefund: result['requesterRefund'],
        );
        
        Get.back();
        Get.snackbar('Success', 'Dispute dismissed. Funds distributed: 85% to Helper, 7.5% to Requester.',
        );
      } else {
        Get.back();
        Get.snackbar('Error', result['message'] ?? 'Failed to dismiss dispute',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Dismiss dispute error: $e');
      Get.back();
      Get.snackbar('Error', 'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  /// Calculate time ago
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
