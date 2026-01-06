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

import 'package:shared_preferences/shared_preferences.dart';
import '../views/user/bottomNavi/bottom_navi_screen.dart';
import '../views/user/bottomNavi/screens/profile/tabs/chat_screen.dart';
import '../views/user/bottomNavi/screens/profile/tabs/controller/chat_controller.dart';
import '../views/user/bottomNavi/screens/task/my_task/tabs/task_review_screen.dart';
import '../model/task_model.dart';
import '../views/user/bottomNavi/screens/task/my_task/tabs/task_details2_screen.dart';
import '../views/user/bottomNavi/screens/task/my_task/tabs/in_progress_view_details.dart';
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
  bool _initialized = false;
  bool _initialMessageHandled = false;

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

  /// Notify requester/helper about a validation loss
  Future<void> notifyValidationLoser({
    required String loserId,
    required String taskTitle,
    required String taskId,
    required bool isHelper, // true if helper, false if requester
  }) async {
    try {
      final title = 'Validation Settled';
      final body = isHelper
          ? 'The validation for "$taskTitle" has been settled in favor of the requester.'
          : 'The validation for "$taskTitle" has been settled in favor of the helper.';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(loserId)
          .collection('items')
          .add({
            'title': title,
            'body': body,
            'type': NoticeType.danger.name,
            'category': 'validation_lost',
            'taskId': taskId,
            'taskTitle': taskTitle,
            'read': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      await _sendFcmToUser(loserId, title, body, {
        'route': 'history_tab',
        'taskId': taskId,
        'category': 'validation_result',
      });

    } catch (e) {
      debugPrint('Error sending validation loser notification: $e');
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
      // Get Admin UID (cached if possible)
      final adminQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: 'admin@gmail.com')
          .limit(1)
          .get();
      String? adminUid;
      if (adminQuery.docs.isNotEmpty) {
        adminUid = adminQuery.docs.first.id;
      }

      final isReceiverAdmin = receiverId == adminUid;

      debugPrint('Sending chat notification to user: $receiverId');

      final title = senderName; // Name as title like most chat apps
      final body = message;

      // 1) Save notification to Firestore ONLY IF receiver is NOT admin
      // Admin wants push notifications but doesn't want them in their notification screen history.
      if (!isReceiverAdmin) {
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
      }

      // 2) Get receiver's device token
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;

      final payloadData = {
        'category': 'chat_message',
        'senderId': senderId,
        'senderName': senderName,
        'senderPhoto': senderPhoto ?? '',
        'conversationId': conversationId,
        'taskId': taskId,
        'taskTitle': taskTitle,
        'taskImage': taskImage ?? '',
        'route': 'chat_screen',
      };

      if (deviceToken != null && deviceToken.isNotEmpty) {
        final androidSdk = userDoc.data()?['androidSdk'] as int?;
        // 3) Send FCM push notification to receiver
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: payloadData,
          recipientSdk: androidSdk,
        );
      }

      // 4) 🔥 Notify Admin too if the admin is not the already notified receiver
      // This fulfills "admin ko her chat ka push notification bhi jae" (monitoring)
      if (!isReceiverAdmin && adminUid != null && adminUid != senderId) {
        final adminDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(adminUid)
            .get();
        final adminToken = adminDoc.data()?['deviceToken'] as String?;
        if (adminToken != null && adminToken.isNotEmpty) {
          await _sendFcmDirect(
            token: adminToken,
            title: '[Monitor] $senderName -> $receiverId',
            body: body,
            data: payloadData,
            recipientSdk: adminDoc.data()?['androidSdk'] as int?,
          );
        }
      }

      debugPrint('Chat notification processed. Admin suppressed from Firestore: $isReceiverAdmin');
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

      // 🔥 Guard: Prevent attaching multiple listeners
      if (!_initialized) {
        _initialized = true;

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
        if (!_initialMessageHandled) {
          try {
            final initial = await _messaging.getInitialMessage();
            if (initial != null) {
              final messageId = initial.messageId ?? 'initial_${initial.sentTime?.millisecondsSinceEpoch}';
              final isHandled = await _isMessageHandled(messageId);
              if (!isHandled) {
                _initialMessageHandled = true;
                await _markMessageAsHandled(messageId);
                debugPrint('🚀 Handling initial notification message: $messageId');
                _handleNotificationTapLogic(initial.data);
              } else {
                debugPrint('⏭️ Initial message already handled: $messageId');
                _initialMessageHandled = true;
              }
            }
          } catch (e) {
            debugPrint('Error getting initial message: $e');
          }
        }

        // Setup background message handler (only once)
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
        debugPrint('Notification listeners attached successfully');
      } else {
        debugPrint('Notification listeners already attached, skipping setup');
      }

      debugPrint('Notification service state for $userId: Initialized=$_initialized, MessageHandled=$_initialMessageHandled');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  /// Handle notification tap - Navigate to appropriate screen
  /// Handle notification tap - Navigate to appropriate screen
  // ============================================
  // PERSISTENCE FOR HOT RESTART (using SharedPreferences)
  // ============================================

  Future<bool> _isMessageHandled(String? messageId) async {
    if (messageId == null) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final handledIds = prefs.getStringList('handled_notification_ids') ?? [];
      final isHandled = handledIds.contains(messageId);
      debugPrint('🔍 Checked SharedPreferences for $messageId: ${isHandled ? "FOUND" : "NOT FOUND"}');
      return isHandled;
    } catch (e) {
      debugPrint('Error checking SharedPreferences: $e');
    }
    return false;
  }

  Future<void> _markMessageAsHandled(String? messageId) async {
    if (messageId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final handledIds = prefs.getStringList('handled_notification_ids') ?? [];
      if (!handledIds.contains(messageId)) {
        handledIds.add(messageId);
        // Keep only last 50 IDs to avoid bloat
        if (handledIds.length > 50) handledIds.removeAt(0);
        await prefs.setStringList('handled_notification_ids', handledIds);
        debugPrint('✅ Saved message ID to SharedPreferences: $messageId');
      }
    } catch (e) {
      debugPrint('Error saving to SharedPreferences: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) async {
    final messageId = message.messageId ?? 'tap_${message.sentTime?.millisecondsSinceEpoch}';
    debugPrint('👆 Notification Tapped. ID: $messageId');
    await _markMessageAsHandled(messageId);
    _handleNotificationTapLogic(message.data);
  }

  /// Unified logic for handling notification taps (FCM and Local)
  void _handleNotificationTapLogic(Map<String, dynamic> data) {
    try {
      final category = data['category'] as String?;
      final route = data['route'] as String?;

      debugPrint('Notification Logic Triggered: $category, route: $route');

      if (category == 'task_posted' && route == 'all_task_tab') {
        _navigateToAllTasks();
      } else if (category == 'chat_message' && route == 'chat_screen') {
        _navigateToChat(data);
      } else if (category == 'proof_uploaded' && route == 'task_review') {
        _navigateToTaskReview(data);
      } else if (category == 'validation_hub_alert' &&
          route == 'validation_hub') {
        _navigateToValidationHub();
      } else if (category == 'offer_received') {
        _navigateToTaskDetails2(data);
      } else if (category == 'offer_accepted') {
        _navigateToInProgressView(data);
      } else if (category == 'funds_added' || route == 'wallet_tab') {
        _navigateToWallet();
      }
    } catch (e) {
      debugPrint('Error handling notification tap logic: $e');
    }
  }

  void _navigateToInProgressView(Map<String, dynamic> data) async {
    try {
      final taskId = data['taskId'] as String?;
      if (taskId == null) {
        debugPrint('Cannot navigate: taskId is null');
        _navigateToMyTasks();
        return;
      }

      debugPrint('Fetching task and owner data for InProgressViewDetails: $taskId');
      
      // 1) Fetch Task
      final taskDoc = await FirebaseFirestore.instance.collection('tasks').doc(taskId).get();
      if (!taskDoc.exists) {
        debugPrint('Task not found: $taskId');
        _navigateToMyTasks();
        return;
      }
      final task = TaskModel.fromFirestore(taskDoc);

      // 2) Fetch Owner (Requester) details
      final ownerDoc = await FirebaseFirestore.instance.collection('users').doc(task.uid).get();
      final ownerData = ownerDoc.data();
      
      final userName = ownerData?['displayName'] ?? ownerData?['name'] ?? 'Unknown';
      final userPhoto = ownerData?['photoURL'] ?? ownerData?['photoUrl'];
      final userCustomId = ownerData?['userId'];
      final phone = ownerData?['phoneNumber'];

      // Reset stack to My Tasks (index 1) and subIndex 1 (MY TASKS tab)
      Get.offAll(() => const BottomNaviScreen(initialIndex: 1, subIndex: 1));

      // Small delay to let the stack reset before pushing details
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.to(() => InProgressViewDetails(
              userId: userCustomId,
              taskId: taskId,
              timeAgo: _getTimeAgo(task.createdAt),
              taskTitle: task.title,
              price: task.budget.toString(),
              userName: userName,
              photoUrl: userPhoto,
              location: task.location,
              phoneNumber: phone,
              helperUid: task.uid, // Task owner Auth UID
              taskImage: task.imageUrl,
              latitude: task.latitude,
              longitude: task.longitude,
              taskType: task.taskType,
            ));
      });
    } catch (e) {
      debugPrint('Error navigating to in progress view: $e');
      _navigateToMyTasks();
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) return '${duration.inDays} days ago';
    if (duration.inHours > 0) return '${duration.inHours} hours ago';
    if (duration.inMinutes > 0) return '${duration.inMinutes} mins ago';
    return 'Just now';
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

  void _navigateToTaskDetails2(Map<String, dynamic> data) async {
    final taskId = data['taskId'] as String?;
    if (taskId == null) return;

    debugPrint('Navigating to task details 2: $taskId');

    try {
      final doc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();
      if (!doc.exists) return;

      final task = TaskModel.fromFirestore(doc);

      // Reset stack to My Tasks (index 1) and subIndex 1 (MY TASKS tab)
      Get.offAll(() => const BottomNaviScreen(initialIndex: 1, subIndex: 1));

      // Small delay to let the stack reset before pushing details
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.to(() => TaskDetails2Screen(task: task));
      });
    } catch (e) {
      debugPrint('Task Details Navigation error: $e');
    }
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
    final conversationId = data['conversationId'] as String?;

    if (taskId == null || senderId == null) return;

    debugPrint('Navigating to chat screen with $senderName (Conv: $conversationId)');

    Future.delayed(const Duration(milliseconds: 600), () {
      try {
        Get.to(
          () => const ChatScreen(),
          arguments: {
            'taskId': taskId,
            'taskTitle': taskTitle ?? 'Chat',
            'taskOwnerId': senderId,
            'taskOwnerName': senderName ?? 'User',
            'taskOwnerPhoto': senderPhoto,
            'taskImage': taskImage,
            'conversationId': conversationId,
          },
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
    await _fln.initialize(
      init,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            _handleNotificationTapLogic(data);
          } catch (e) {
            debugPrint('Error decoding notification payload: $e');
          }
        }
      },
    );
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

    // 🔥 SUPPRESSION LOGIC: If user is already in THIS chat, don't show popup
    final data = message.data;
    if (data['category'] == 'chat_message') {
      final incomingConvId = data['conversationId'] as String?;
      final activeConvId = ChatController.activeConversationId.value;

      if (incomingConvId != null && activeConvId != null && incomingConvId == activeConvId) {
        debugPrint('🚫 Notification Suppressed: User is already in chat $activeConvId');
        return;
      }
    }

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
      payload: jsonEncode(message.data), // 🔥 Pass data to payload for tap handling
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

  /// Delete device token from Firestore (call on logout)
  Future<void> deleteUserDeviceToken(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'deviceToken': '', // Clear token from database
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
      debugPrint('Device token cleared from database for user $userId');
    } catch (e) {
      debugPrint('Error clearing device token: $e');
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

  /// Notify user about a formal warning from administration
  Future<void> notifyAdminWarning({
    required String userUid,
  }) async {
    try {
      final title = 'Official Administrative Warning';
      final body = 'Please be advised that your account has received a formal warning from the Red Balloon Administration. We kindly request you to review our community guidelines and ensure full compliance in your future activities. Continued violations may result in account suspension.';

      // 1) Save to Firestore for the user's notification list
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userUid)
          .collection('items')
          .add({
        'title': title,
        'body': body,
        'type': NoticeType.danger.name,
        'category': 'admin_warning',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2) Send FCM to the user's device
      await _sendFcmToUser(
        userUid, 
        title, 
        body, 
        {'route': 'history_tab', 'category': 'admin_warning'}
      );

      debugPrint('Admin warning sent to UID: $userUid');
    } catch (e) {
      debugPrint('Error sending admin warning to $userUid: $e');
    }
  }

  /// Notify user about account suspension or restoration
  Future<void> notifyAccountSuspension({
    required String userUid,
    required bool isSuspended,
  }) async {
    try {
      final title = isSuspended ? 'Account Suspended' : 'Account Restored';
      final body = isSuspended
          ? 'Your account has been suspended by the Red Balloon Administration due to a violation of our community guidelines. For any complaints or appeals, please contact admin.'
          : 'Your account has been successfully restored. You can now access all features of Red Balloon.';

      // 1) Save to Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userUid)
          .collection('items')
          .add({
        'title': title,
        'body': body,
        'type': isSuspended ? NoticeType.danger.name : NoticeType.success.name,
        'category': 'account_status_change',
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2) Send FCM
      await _sendFcmToUser(
        userUid, 
        title, 
        body, 
        {'route': 'history_tab', 'category': 'account_status', 'isSuspended': isSuspended.toString()}
      );

      debugPrint('Account status notification sent to UID: $userUid (Suspended: $isSuspended)');
    } catch (e) {
      debugPrint('Error sending account status notification: $e');
    }
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

  /// Notify user about withdrawal request status update (Processed or Rejected)
  Future<void> notifyWithdrawalStatusUpdate({
    required String userUid,
    required double amount,
    required String status, // 'Completed' or 'Rejected'
  }) async {
    try {
      final isApproved = status == 'Completed';
      final title = isApproved ? 'Withdrawal Approved!' : 'Withdrawal Rejected';
      final body = isApproved
          ? 'Your withdrawal of SAR ${amount.toStringAsFixed(2)} has been processed. The funds are on their way to your account.'
          : 'Your withdrawal request for SAR ${amount.toStringAsFixed(2)} was rejected. The funds have been returned to your balance.';
      final type = isApproved ? NoticeType.success : NoticeType.danger;

      // 1. Save to Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userUid)
          .collection('items')
          .add({
        'title': title,
        'body': body,
        'type': type.name,
        'category': 'withdrawal_update',
        'status': status,
        'amount': amount,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Send FCM Push
      await _sendFcmToUser(
        userUid,
        title,
        body,
        {
          'route': 'wallet_tab',
          'category': 'withdrawal_update',
          'status': status,
        },
      );

      debugPrint('Withdrawal status notification sent to UID: $userUid');
    } catch (e) {
      debugPrint('Error sending withdrawal status notification: $e');
    }
  }

  // ============================================
  // ADMIN NOTIFICATIONS
  // ============================================

  /// Notify ADMIN about a specific event
  Future<void> notifyAdmin({
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    try {
      final adminQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: 'admin@gmail.com')
          .limit(1)
          .get();

      if (adminQuery.docs.isNotEmpty) {
        final adminUid = adminQuery.docs.first.id;

        // 1. Save to Firestore
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(adminUid)
            .collection('items')
            .add({
          'title': title,
          'body': body,
          'type': NoticeType.warning.name,
          'category': 'admin_alert',
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
          ...data,
        });

        // 2. Send FCM
        await _sendFcmToUser(adminUid, title, body, data);
        debugPrint('✅ Admin notified: $title');
      } else {
        debugPrint('⚠️ Admin user not found (admin@gmail.com)');
      }
    } catch (e) {
      debugPrint('Error notifying admin: $e');
    }
  }

  /// Notify both users and admin when a task enters dispute
  Future<void> notifyDisputeStarted({
    required String requesterId,
    required String helperId,
    required String taskTitle,
    required String taskId,
  }) async {
    final title = 'Task in Dispute';
    final body = 'The task "$taskTitle" has entered a formal dispute. Administration will review.';

    // Notify users
    await _sendFcmToUser(requesterId, title, body, {'route': 'history_tab', 'taskId': taskId, 'category': 'task_disputed'});
    await _sendFcmToUser(helperId, title, body, {'route': 'history_tab', 'taskId': taskId, 'category': 'task_disputed'});

    // Save for users
    final userNotifData = {
      'title': title,
      'body': body,
      'type': NoticeType.danger.name,
      'category': 'task_disputed',
      'taskId': taskId,
      'taskTitle': taskTitle,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance.collection('notifications').doc(requesterId).collection('items').add(userNotifData);
    await FirebaseFirestore.instance.collection('notifications').doc(helperId).collection('items').add(userNotifData);

    // Notify Admin
    await notifyAdminDispute(taskTitle, taskId);
  }

  /// Specialized admin notification for disputes
  Future<void> notifyAdminDispute(String taskTitle, String taskId) async {
    await notifyAdmin(
      title: 'Task Disputed',
      body: 'Task "$taskTitle" (ID: $taskId) is now in dispute and needs review.',
      data: {
        'category': 'admin_dispute',
        'taskId': taskId,
        'taskTitle': taskTitle,
      },
    );
  }

  Future<void> notifyAdminWithdrawRequest(String userId, double amount) async {
    String displayName = userId;
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        displayName = userDoc.data()?['username'] ?? 
                      userDoc.data()?['displayName'] ?? 
                      userDoc.data()?['name'] ?? 
                      userId;
      }
    } catch (e) {
      print('Error fetching user name for admin notification: $e');
    }

    await notifyAdmin(
      title: 'New Withdrawal Request',
      body: 'User $displayName has requested a withdrawal of SAR ${amount.toStringAsFixed(2)}.',
      data: {
        'category': 'admin_withdrawal_request',
        'userId': userId,
        'amount': amount.toString(),
      },
    );
  }

  /// Specialized admin notification for tasks moving to validation
  Future<void> notifyAdminNewTaskToValidation(String taskTitle, String taskId) async {
    await notifyAdmin(
      title: 'Manual Validation Required',
      body: 'Task "$taskTitle" validation timer expired. It is now awaiting admin review.',
      data: {
        'category': 'admin_validation_manual',
        'taskId': taskId,
        'taskTitle': taskTitle,
      },
    );
  }
  /// Notify admin that platform fee has been credited
  Future<void> notifyAdminPlatformFeeReceived({
    required String adminId,
    required double amount,
    required String source, // e.g., "Task Completion", "Validation", "Dispute"
    required String taskId,
  }) async {
    try {
      final title = 'Platform Fee Received';
      final body = 'Received SAR ${amount.toStringAsFixed(2)} from $source.';

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(adminId)
          .collection('items')
          .add({
        'title': title,
        'body': body,
        'type': NoticeType.success.name,
        'category': 'admin_fee',
        'amount': amount,
        'source': source,
        'taskId': taskId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(adminId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        await _sendFcmDirect(
          token: deviceToken,
          title: title,
          body: body,
          data: {
            'category': 'admin_fee',
            'amount': amount.toString(),
            'route': 'wallet_tab', // Admin likely has a wallet view too
          },
          recipientSdk: userDoc.data()?['androidSdk'] as int?,
        );
      }
    } catch (e) {
      debugPrint('Error sending admin fee notification: $e');
    }
  }
}

// Top-level background handler (must be a static/global function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('BG message: ${message.notification?.title}');
}
