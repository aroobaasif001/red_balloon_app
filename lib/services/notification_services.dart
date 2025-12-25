// lib/services/notification_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/user/bottomNavi/bottom_navi_screen.dart';
import '../views/user/bottomNavi/screens/profile/tabs/chat_screen.dart';
import '../views/user/bottomNavi/screens/profile/tabs/controller/chat_controller.dart';
import '../views/user/bottomNavi/screens/task/my_task/tabs/task_review_screen.dart';
import 'get_server_key.dart';

/// Notification types used in Firestore + payloads
enum NoticeType { success, danger, info, warning }

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  //Use ONE consistent channel id everywhere (Android 8+)
  static const String kDefaultAndroidChannelId = 'vantagem_high_importance';
  static const String kDefaultAndroidChannelName = 'General Notifications';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

  var androidSdkInt;

  // ============================================
  //TASK POSTING NOTIFICATION
  // ============================================

  /// Send push notification to user when they post a new task
  /// Also saves notification to Firestore for history
  Future<void> notifyTaskPosted({
    required String userId,
    required String taskTitle,
    required String taskId,
  }) async {
    try {
      debugPrint('Sending task posted notification to user: $userId');

      final title = 'Task Posted Successfully!';
      final body =
          'Your task "$taskTitle" has been posted. Helpers will be notified.';

      // 1) Save notification to Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.success.name,
            'category': 'task_posted',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      debugPrint('Notification saved to Firestore');

      // 2) Get user's device token from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;

      if (deviceToken == null || deviceToken.isEmpty) {
        debugPrint('No device token found for user: $userId');
        return;
      }

      // Get user's Android SDK version (for icon compatibility)
      final androidSdk = userDoc.data()?['androidSdk'] as int?;

      // 3) Send FCM push notification
      await _sendFcmDirect(
        token: deviceToken,
        title: title,
        body: body,
        data: {
          'category': 'task_posted',
          'taskId': taskId,
          'userId': userId,
          'route': 'all_task_tab', // For navigation when tapped
        },
        recipientSdk: androidSdk,
      );

      debugPrint('Task posted notification sent successfully');
    } catch (e) {
      debugPrint('Error sending task posted notification: $e');
    }
  }

  /// Send push notification to task owner when helper uploads proof
  /// Also saves notification to Firestore for history
  Future<void> notifyProofUploaded({
    required String taskOwnerId,
    required String helperName,
    required String taskTitle,
    required String taskId,
    required String proofId, // Added proofId
  }) async {
    try {
      debugPrint('Sending proof uploaded notification to owner: $taskOwnerId');

      final title = 'Task Proof Uploaded!';
      final body =
          '$helperName has uploaded proof for your task "$taskTitle". Please review it.';

      // 1) Save notification to Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(taskOwnerId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.info.name,
            'category': 'proof_uploaded',
            'taskId': taskId,
            'proofId': proofId, // Store proofId
            'taskTitle': taskTitle,
            'helperName': helperName,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      debugPrint('Proof Notification saved to Firestore');

      // 2) Get task owner's device token
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(taskOwnerId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;

      if (deviceToken == null || deviceToken.isEmpty) {
        debugPrint('No device token found for task owner: $taskOwnerId');
        return;
      }

      final androidSdk = userDoc.data()?['androidSdk'] as int?;

      // 3) Send FCM push notification
      await _sendFcmDirect(
        token: deviceToken,
        title: title,
        body: body,
        data: {
          'category': 'proof_uploaded',
          'taskId': taskId,
          'proofId': proofId, // Pass proofId for navigation
          'route': 'task_review', // Updated route name
        },
        recipientSdk: androidSdk,
      );

      debugPrint('Proof uploaded notification sent successfully');
    } catch (e) {
      debugPrint('Error sending proof uploaded notification: $e');
    }
  }

  /// Notify helper that their proof has been ACCEPTED
  Future<void> notifyProofAccepted({
    required String helperId,
    required String taskTitle,
    required String taskId,
  }) async {
    try {
      final title = 'Proof Accepted!';
      final body = 'Your proof for "$taskTitle" has been accepted. Great job!';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(helperId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.success.name,
            'category': 'proof_accepted',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(helperId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'proof_accepted',
            'taskId': taskId,
            'route': 'history_tab',
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending proof accepted notification: $e');
    }
  }

  /// Notify helper that their proof has been REJECTED
  Future<void> notifyProofRejected({
    required String helperId,
    required String taskTitle,
    required String taskId,
    required String rejectedByName, // Added sender name
  }) async {
    try {
      final title = 'Proof Rejected';
      final body =
          '$rejectedByName has rejected your proof for "$taskTitle". It is now in the validation hub.';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(helperId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.danger.name,
            'category': 'proof_rejected',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'rejectedBy': rejectedByName,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(helperId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'proof_rejected',
            'taskId': taskId,
            'route': 'history_tab',
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending proof rejected notification: $e');
    }
  }

  /// Notify helper that their proof moved to validation due to requester timeout
  Future<void> notifyProofReviewTimeout({
    required String helperId,
    required String taskTitle,
    required String taskId,
  }) async {
    try {
      final title = 'Task Moved to Validation';
      final body =
          'The requester did not review your proof for "$taskTitle" in time. It has been moved to community validation.';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(helperId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.warning.name,
            'category': 'proof_review_timeout',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(helperId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'proof_review_timeout',
            'taskId': taskId,
            'route': 'history_tab',
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending proof review timeout notification: $e');
    }
  }

  /// Notify ALL users about a new task in validation hub
  /// [excludeUserIds] is used to skip helper and requester/owner
  Future<void> broadcastValidationTask({
    required String taskTitle,
    required String taskId,
    List<String>? excludeUserIds, // Added exclusion list
  }) async {
    try {
      final title = 'New Validation Required';
      final body =
          'A new task "$taskTitle" is in validation hub. Help us decide!';

      // Fetch all users with device tokens
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('deviceToken', isNotEqualTo: '')
          .get();

      debugPrint('Broadcasting to ${usersSnapshot.docs.length} users');
      debugPrint('Excluding IDs: $excludeUserIds');

      int sentCount = 0;
      int skipCount = 0;

      for (var doc in usersSnapshot.docs) {
        final userId = doc.id.trim();

        // Skip excluded users (Helper and Owner)
        bool shouldSkip = false;
        if (excludeUserIds != null) {
          for (var excludeId in excludeUserIds) {
            if (excludeId.trim() == userId) {
              shouldSkip = true;
              break;
            }
          }
        }

        if (shouldSkip) {
          debugPrint('Skipping excluded user: $userId');
          skipCount++;
          continue;
        }

        final deviceToken = doc.data()['deviceToken'] as String?;
        if (deviceToken == null || deviceToken.isEmpty) continue;

        sentCount++;
        _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'validation_hub_alert',
            'taskId': taskId,
            'route': 'validation_hub',
          },
          recipientSdk: doc.data()['androidSdk'] as int?,
        );
      }
      debugPrint(
        'Broadcast complete. Sent to $sentCount users, skipped $skipCount.',
      );
    } catch (e) {
      debugPrint('Error broadcasting validation alert: $e');
    }
  }

  /// Notify participant that help was requested
  Future<void> notifyHelpRequested({
    required String receiverId,
    required String senderName,
    required String taskTitle,
    required String taskId,
  }) async {
    try {
      final title = 'Help Requested';
      final body = '$senderName requested help regarding task "$taskTitle".';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(receiverId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.warning.name,
            'category': 'help_requested',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'help_requested',
            'taskId': taskId,
            'route': 'task_in_progress',
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending help request notification: $e');
    }
  }

  // ============================================
  // CHAT NOTIFICATIONS
  // ============================================

  /// Send push notification to task owner when someone sends an offer
  /// Also saves notification to Firestore for history
  Future<void> notifyOfferReceived({
    required String taskOwnerId,
    required String helperName,
    required String taskTitle,
    required String taskId,
    required double offerAmount,
  }) async {
    try {
      debugPrint('Sending offer received notification to user: $taskOwnerId');

      final title = 'New Offer Received!';
      final body =
          '$helperName sent an offer of SAR ${offerAmount.toStringAsFixed(0)} for your task "$taskTitle".';

      // 1) Save notification to Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(taskOwnerId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.info.name,
            'category': 'offer_received',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'helperName': helperName,
            'offerAmount': offerAmount,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      debugPrint('Offer Notification saved to Firestore');

      // 2) Get task owner's device token from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(taskOwnerId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;

      if (deviceToken == null || deviceToken.isEmpty) {
        debugPrint('No device token found for task owner: $taskOwnerId');
        return;
      }

      // Get user's Android SDK version (for icon compatibility)
      final androidSdk = userDoc.data()?['androidSdk'] as int?;

      // 3) Send FCM push notification
      await _sendFcmDirect(
        token: deviceToken,
        title: title,
        body: body,
        data: {
          'category': 'offer_received',
          'taskId': taskId,
          'route': 'task_details', // For navigation
        },
        recipientSdk: androidSdk,
      );

      debugPrint('Offer received notification sent successfully');
    } catch (e) {
      debugPrint('Error sending offer notification: $e');
    }
  }

  /// Send push notification to helper when their offer is accepted
  /// Also saves notification to Firestore for history
  Future<void> notifyOfferAccepted({
    required String helperId,
    required String taskTitle,
    required String taskId,
  }) async {
    try {
      debugPrint('Sending offer accepted notification to helper: $helperId');

      final title = 'Offer Accepted!';
      final body =
          'Your offer for the task "$taskTitle" has been accepted. You can now start the task.';

      // 1) Save notification to Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(helperId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.success.name,
            'category': 'offer_accepted',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      debugPrint('Acceptance Notification saved to Firestore');

      // 2) Get helper's device token from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(helperId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;

      if (deviceToken == null || deviceToken.isEmpty) {
        debugPrint('No device token found for helper: $helperId');
        return;
      }

      // Get user's Android SDK version (for icon compatibility)
      final androidSdk = userDoc.data()?['androidSdk'] as int?;

      // 3) Send FCM push notification
      await _sendFcmDirect(
        token: deviceToken,
        title: title,
        body: body,
        data: {
          'category': 'offer_accepted',
          'taskId': taskId,
          'route': 'task_in_progress', // For navigation
        },
        recipientSdk: androidSdk,
      );

      debugPrint('Offer accepted notification sent successfully');
    } catch (e) {
      debugPrint('Error sending offer accepted notification: $e');
    }
  }

  /// Notify helper that they have received payment for a task
  Future<void> notifyPaymentReceived({
    required String helperId,
    required String taskTitle,
    required String taskId,
    required double amount,
  }) async {
    try {
      final title = 'Payment Received!';
      final body =
          'You have received SAR ${amount.toStringAsFixed(2)} for completing "$taskTitle". Check your wallet!';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(helperId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.success.name,
            'category': 'payment_received',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'amount': amount,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(helperId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'payment_received',
            'taskId': taskId,
            'amount': amount.toString(),
            'route': 'wallet_tab', // Navigate to wallet
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending payment received notification: $e');
    }
  }

  /// Notify current user that funds have been added to their wallet
  Future<void> notifyFundsAdded({
    required String userId,
    required double amount,
  }) async {
    try {
      final title = 'Funds Added Successfully!';
      final body =
          'SAR ${amount.toStringAsFixed(2)} has been added to your wallet.';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .add({
        'title': title,
        'body': body,
        'type': NoticeType.success.name,
        'category': 'funds_added',
        'amount': amount,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'funds_added',
            'amount': amount.toString(),
            'route': 'wallet_tab',
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending funds added notification: $e');
    }
  }

  /// Notify user about a warning in a dispute
  Future<void> notifyDisputeWarning({
    required String userId,
    required String taskTitle,
    required String taskId,
    required String role, // 'Helper' or 'Requester'
  }) async {
    try {
      final title = 'Dispute Warning';
      final body = 'You have received a warning regarding the task "$taskTitle". Please adhere to platform rules.';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.warning.name,
            'category': 'dispute_warning',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'role': role,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'dispute_warning',
            'taskId': taskId,
            'route': 'history_tab',
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending dispute warning notification: $e');
    }
  }

  /// Notify requester about a refund and helper about a small payment
  Future<void> notifyDisputeRefund({
    required String requesterId,
    required String helperId,
    required String taskTitle,
    required String taskId,
    required double refundAmount,
    required double helperAmount,
  }) async {
    try {
      final reqTitle = 'Refund Processed';
      final reqBody = 'A refund of SAR ${refundAmount.toStringAsFixed(2)} (96%) has been credited to your wallet for task "$taskTitle".';

      final helpTitle = 'Partial Payment Received';
      final helpBody = 'You have received SAR ${helperAmount.toStringAsFixed(2)} (1%) for your efforts on task "$taskTitle".';

      // 1. Requester Notification
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(requesterId)
          .collection('items')
          .add({
            'title': reqTitle,
            'body': reqBody,
            'type': NoticeType.success.name,
            'category': 'dispute_refund',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'amount': refundAmount,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // 2. Helper Notification
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(helperId)
          .collection('items')
          .add({
            'title': helpTitle,
            'body': helpBody,
            'type': NoticeType.info.name,
            'category': 'dispute_helper_payment',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'amount': helperAmount,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // Send FCM to both
      await _sendFcmToUser(requesterId, reqTitle, reqBody, {'route': 'wallet_tab', 'taskId': taskId});
      await _sendFcmToUser(helperId, helpTitle, helpBody, {'route': 'wallet_tab', 'taskId': taskId});

    } catch (e) {
      debugPrint('Error sending dispute refund notifications: $e');
    }
  }


  /// Notify requester/helper about a validation win
  Future<void> notifyValidationWinner({
    required String winnerId,
    required String taskTitle,
    required String taskId,
    required double amount,
    required bool isRefund, // true if requester, false if helper
  }) async {
    try {
      final title = isRefund ? 'Validation Won - Refund' : 'Validation Won - Payment';
      final body = isRefund 
          ? 'You won the validation for "$taskTitle". A refund of SAR ${amount.toStringAsFixed(2)} has been credited.'
          : 'You won the validation for "$taskTitle". A payment of SAR ${amount.toStringAsFixed(2)} has been credited.';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(winnerId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.success.name,
            'category': isRefund ? 'validation_win_refund' : 'validation_win_payment',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'amount': amount,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      await _sendFcmToUser(winnerId, title, body, {
        'route': 'wallet_tab',
        'taskId': taskId,
        'category': 'validation_result',
      });

    } catch (e) {
      debugPrint('Error sending validation winner notification: $e');
    }
  }

  /// Notify voter that they received a reward for a correct vote
  Future<void> notifyValidationVoterReward({
    required String voterId,
    required String taskTitle,
    required String taskId,
    required double amount,
  }) async {
    try {
      final title = 'Validation Reward Received!';
      final body = 'You received SAR ${amount.toStringAsFixed(2)} for your correct vote on task "$taskTitle".';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(voterId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.success.name,
            'category': 'validation_voter_reward',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'amount': amount,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      await _sendFcmToUser(voterId, title, body, {
        'route': 'wallet_tab',
        'taskId': taskId,
        'category': 'validation_voter_reward',
      });

    } catch (e) {
      debugPrint('Error sending validation voter notification: $e');
    }
  }

  /// Notify participant that help was requested
  Future<void> notifyDisputeDismissedSplit({
    required String helperId,
    required String requesterId,
    required String taskTitle,
    required String taskId,
    required double helperAmount,
    required double requesterRefund,
  }) async {
    try {
      final helperTitle = 'Dispute Resolved';
      final helperBody = 'The dispute for "$taskTitle" has been resolved. You have received SAR ${helperAmount.toStringAsFixed(2)} (85%).';

      final requesterTitle = 'Dispute Resolved';
      final requesterBody = 'The dispute for "$taskTitle" has been resolved. You have received SAR ${requesterRefund.toStringAsFixed(2)} (7.5% refund).';

      // 1. Helper Notification
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(helperId)
          .collection('items')
          .add({
            'title': helperTitle,
            'body': helperBody,
            'type': NoticeType.success.name,
            'category': 'dispute_resolved_helper',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'amount': helperAmount,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // 2. Requester Notification
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(requesterId)
          .collection('items')
          .add({
            'title': requesterTitle,
            'body': requesterBody,
            'type': NoticeType.info.name,
            'category': 'dispute_resolved_requester',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'amount': requesterRefund,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // Send FCM to both (utility)
      await _sendFcmToUser(helperId, helperTitle, helperBody, {'route': 'wallet_tab', 'taskId': taskId});
      await _sendFcmToUser(requesterId, requesterTitle, requesterBody, {'route': 'wallet_tab', 'taskId': taskId});

    } catch (e) {
      debugPrint('Error sending dispute dismissal split notifications: $e');
    }
  }

  /// Helper to send FCM to a user by ID
  Future<void> _sendFcmToUser(String userId, String title, String body, Map<String, String> data) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: data,
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending FCM to $userId: $e');
    }
  }

  /// Send push notification for chat messages
  Future<void> notifyChatMessage({
    required String receiverId,
    required String senderId,
    required String senderName,
    required String message,
    required String conversationId,
    required String taskId,
    required String taskTitle,
    String? senderPhoto,
    String? taskImage,
  }) async {
    try {
      debugPrint('Sending chat notification to user: $receiverId');

      final title = senderName; // Name as title like most chat apps
      final body = message;

      // 1) Save notification to Firestore - Optional for chat as they are in the chat list,
      // but let's save it for consistency in notification history if desired.
      // Many apps don't save chat messages in "Notification history", only system alerts.
      // But user asked "db ma bhi store ho" in previous task, let's keep it consistent.
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(receiverId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.info.name,
            'category': 'chat_message',
            'senderId': senderId,
            'conversationId': conversationId,
            'taskId': taskId,
            'taskTitle': taskTitle,
            'senderPhoto': senderPhoto,
            'taskImage': taskImage,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // 2) Get receiver's device token
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;

      if (deviceToken == null || deviceToken.isEmpty) {
        debugPrint('No device token found for receiver: $receiverId');
        return;
      }

      final androidSdk = userDoc.data()?['androidSdk'] as int?;

      // 3) Send FCM push notification
      await _sendFcmDirect(
        token: deviceToken,
        title: title,
        body: body,
        data: {
          'category': 'chat_message',
          'senderId': senderId,
          'senderName': senderName,
          'senderPhoto': senderPhoto ?? '',
          'conversationId': conversationId,
          'taskId': taskId,
          'taskTitle': taskTitle,
          'taskImage': taskImage ?? '',
          'route': 'chat_screen',
        },
        recipientSdk: androidSdk,
      );

      debugPrint('Chat notification sent successfully');
    } catch (e) {
      debugPrint('Error sending chat notification: $e');
    }
  }

  // ============================================
  // INITIALIZATION & TOKEN MANAGEMENT
  // ============================================

  /// Initialize notification service for logged-in user
  /// Call this on app start or after login
  Future<void> initializeForUser(String userId) async {
    try {
      await _ensureLocalInit();
      await _requestPermissions();
      await saveUserDeviceToken(userId);

      // Setup foreground message handler
      FirebaseMessaging.onMessage.listen((message) async {
        if (Platform.isIOS) {
          await _setIOSForegroundPresentation();
        }
        await _showLocal(message);
      });

      // Setup notification tap handler
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check for initial message (app opened from notification)
      try {
        final initial = await _messaging.getInitialMessage();
        if (initial != null) _handleNotificationTap(initial);
      } catch (e) {
        debugPrint('Error getting initial message: $e');
      }

      // Setup background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      debugPrint('Notification service initialized for user: $userId');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  /// Handle notification tap - Navigate to appropriate screen
  void _handleNotificationTap(RemoteMessage message) {
    try {
      final data = message.data;
      final category = data['category'] as String?;
      final route = data['route'] as String?;

      debugPrint('Notification tapped: $category, route: $route');

      if (category == 'task_posted' && route == 'all_task_tab') {
        // ... (existing task_posted logic)
        _navigateToAllTasks();
      } else if (category == 'chat_message' && route == 'chat_screen') {
        _navigateToChat(data);
      } else if (category == 'proof_uploaded' && route == 'task_review') {
        _navigateToTaskReview(data);
      } else if (category == 'validation_hub_alert' &&
          route == 'validation_hub') {
        _navigateToValidationHub();
      } else if (category == 'offer_received' || category == 'offer_accepted') {
        _navigateToMyTasks();
      } else if (category == 'funds_added' || route == 'wallet_tab') {
        _navigateToWallet();
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }

  void _navigateToWallet() {
    debugPrint('Navigating to wallet tab');
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        Get.offAll(() => const BottomNaviScreen(initialIndex: 4));
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    });
  }

  void _navigateToAllTasks() {
    debugPrint('Navigating to all tasks tab');
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        Get.offAll(() => const BottomNaviScreen(initialIndex: 1)); // My Tasks list
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    });
  }

  void _navigateToMyTasks() {
    debugPrint('Navigating to my tasks');
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        Get.offAll(() => const BottomNaviScreen(initialIndex: 1));
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    });
  }

  void _navigateToValidationHub() {
    debugPrint('Navigating to validation hub');
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        Get.offAll(() => const BottomNaviScreen(initialIndex: 3));
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    });
  }

  void _navigateToTaskReview(Map<String, dynamic> data) {
    final taskId = data['taskId'] as String?;
    final proofId = data['proofId'] as String?;

    if (taskId == null || proofId == null) return;

    debugPrint('Navigating to task review screen: $taskId');

    Future.delayed(Duration(milliseconds: 600), () {
      try {
        Get.to(() => TaskReviewScreen(taskId: taskId, proofId: proofId));
      } catch (e) {
        debugPrint('Review Navigation error: $e');
      }
    });
  }

  void _navigateToChat(Map<String, dynamic> data) {
    final taskId = data['taskId'] as String?;
    final taskTitle = data['taskTitle'] as String?;
    final senderId = data['senderId'] as String?;
    final senderName = data['senderName'] as String?;
    final senderPhoto = data['senderPhoto'] as String?;
    final taskImage = data['taskImage'] as String?;

    if (taskId == null || senderId == null) return;

    debugPrint('Navigating to chat screen with $senderName');

    Future.delayed(Duration(milliseconds: 600), () {
      try {
        Get.to(
          () => const ChatScreen(),
          binding: BindingsBuilder(() {
            Get.put(
              ChatController(
                taskId: taskId,
                taskTitle: taskTitle ?? 'Chat',
                taskOwnerId: senderId,
                taskOwnerName: senderName ?? 'User',
                taskOwnerPhoto: senderPhoto,
                taskImage: taskImage,
              ),
            );
          }),
        );
      } catch (e) {
        debugPrint('Chat Navigation error: $e');
      }
    });
  }

  Future<void> _setIOSForegroundPresentation() {
    return _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // 2) Init with app launcher as default (no custom small icon needed)
  Future<void> _ensureLocalInit() async {
    // detect SDK
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      androidSdkInt = androidInfo.version.sdkInt;
      debugPrint('Android SDK: $androidSdkInt');
    }

    // default init icon = launcher (ye 13+ pe use hoga)
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    final init = const InitializationSettings(android: android, iOS: ios);
    await _fln.initialize(init, onDidReceiveNotificationResponse: (_) {});
    await _ensureAndroidChannel();
  }

  // 3) Android 13+ permission — null-safe (won’t crash on iOS)
  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
    );

    final androidPlugin = _fln
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission(); // <- null-safe

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Notifications permission denied.');
    } else {
      try {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          final apns = await _messaging.getAPNSToken();
          debugPrint('APNs Token: $apns');
        }
        final fcm = await _messaging.getToken();
        debugPrint('FCM Token: $fcm');
      } catch (e) {
        debugPrint('Error retrieving FCM/APNs token: $e');
      }
    }
  }

  // 4) Foreground local notify — icon optional (uses app icon if null)
  Future<void> _showLocal(
    RemoteMessage message, {
    String? androidSmallIcon,
  }) async {
    final notif = message.notification;
    if (notif == null) return;

    // SDK<33 => forced small icon from drawable, else null (launcher)
    final bool useLegacyIcon = Platform.isAndroid && (androidSdkInt ?? 33) < 33;

    final androidDetails = AndroidNotificationDetails(
      kDefaultAndroidChannelId,
      kDefaultAndroidChannelName,
      channelDescription: 'High importance notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: useLegacyIcon ? 'notification_icon' : null,
      // optionally: largeIcon only legacy
      largeIcon: useLegacyIcon
          ? const DrawableResourceAndroidBitmap('notification_icon')
          : null,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _fln.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notif.title,
      notif.body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Save device token for regular users (not employer/employee/parent/child)
  /// Call this when user logs in or when requesting permissions
  Future<void> saveUserDeviceToken(String userId) async {
    try {
      final fcm = await _messaging.getToken();
      if (fcm == null) {
        debugPrint('Could not get FCM token.');
        return;
      }

      int? sdk;
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        sdk = info.version.sdkInt;
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'deviceToken': fcm,
        if (sdk != null) 'androidSdk': sdk,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('Device token saved for user: $userId');
    } catch (e) {
      debugPrint('Error saving user device token: $e');
    }
  }

  /// Public method to request notification permissions
  /// Can be called from any screen to check/request permissions
  Future<void> requestNotificationPermissions() async {
    await _requestPermissions();
  }

  // ---------- Permissions & init ----------
  Future<void> _ensureAndroidChannel() async {
    final android = _fln
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        kDefaultAndroidChannelId,
        kDefaultAndroidChannelName,
        description: 'High importance notifications',
        importance: Importance.high,
      ),
    );
  }

  /// HTTP v1 send via service-account access token (keep only for DEV).
  Future<void> _sendFcmDirect({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
    int? recipientSdk,
  }) async {
    final auth = await GetServerKey().getAccess();
    final accessToken = auth.accessToken;
    final projectId = auth.projectId;

    final useLegacyIcon = (recipientSdk ?? 33) < 33;

    final payload = {
      'message': {
        'token': token,
        'notification': {'title': title, 'body': body},
        'android': {
          'priority': 'high',
          'notification': {
            'channel_id': kDefaultAndroidChannelId,
            'sound': 'default',
            'default_sound': true,
            'default_vibrate_timings': true,
            if (useLegacyIcon) 'icon': 'notification_icon', // SDK<33
            // SDK>=33 -> omit => launcher ic used
          },
        },
        'apns': {
          'payload': {
            'aps': {'sound': 'default'},
          },
        },
        if (data != null) 'data': data,
      },
    };

    final res = await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
      ),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      debugPrint('FCM v1 error ${res.statusCode}: ${res.body}');
    } else {
      debugPrint('Push sent');
    }
  }
}

// Top-level background handler (must be a static/global function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('BG message: ${message.notification?.title}');
}
