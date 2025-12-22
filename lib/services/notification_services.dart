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

import 'get_server_key.dart';

/// Notification types used in Firestore + payloads
enum NoticeType { success, danger, info, warning }

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  // 🔔 Use ONE consistent channel id everywhere (Android 8+)
  static const String kDefaultAndroidChannelId = 'vantagem_high_importance';
  static const String kDefaultAndroidChannelName = 'General Notifications';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

  var androidSdkInt;

  // ============================================
  // 🎯 TASK POSTING NOTIFICATION
  // ============================================

  /// Send push notification to user when they post a new task
  /// Also saves notification to Firestore for history
  Future<void> notifyTaskPosted({
    required String userId,
    required String taskTitle,
    required String taskId,
  }) async {
    try {
      debugPrint('📤 Sending task posted notification to user: $userId');

      final title = '🎉 Task Posted Successfully!';
      final body = 'Your task "$taskTitle" has been posted. Helpers will be notified.';

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

      debugPrint('✅ Notification saved to Firestore');

      // 2) Get user's device token from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final deviceToken = userDoc.data()?['deviceToken'] as String?;

      if (deviceToken == null || deviceToken.isEmpty) {
        debugPrint('⚠️ No device token found for user: $userId');
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

      debugPrint('✅ Task posted notification sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending task posted notification: $e');
    }
  }

  // ============================================
  // 🔧 INITIALIZATION & TOKEN MANAGEMENT
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
        debugPrint('❌ Error getting initial message: $e');
      }

      // Setup background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      debugPrint('✅ Notification service initialized for user: $userId');
    } catch (e) {
      debugPrint('❌ Error initializing notification service: $e');
    }
  }

  /// Handle notification tap - Navigate to appropriate screen
  void _handleNotificationTap(RemoteMessage message) {
    try {
      final data = message.data;
      final category = data['category'] as String?;
      final route = data['route'] as String?;
      
      debugPrint('📱 Notification tapped: $category, route: $route');
      
      if (category == 'task_posted' && route == 'all_task_tab') {
        // Navigate to all tasks tab
        // Import the screen at the top of this file when ready
        debugPrint('🔄 Navigating to all tasks tab');
        
        // Delayed navigation to ensure app is ready
        Future.delayed(Duration(milliseconds: 500), () {
          try {
            // Navigate to bottom navigation with tasks tab selected
            Get.offAllNamed('/home', arguments: {'initialTab': 2}); // Adjust tab index as needed
            debugPrint('✅ Navigation completed');
          } catch (e) {
            debugPrint('❌ Navigation error: $e');
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Error handling notification tap: $e');
    }
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
      debugPrint('📱 Android SDK: $androidSdkInt');
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
      debugPrint('❌ Notifications permission denied.');
    } else {
      try {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          final apns = await _messaging.getAPNSToken();
          debugPrint('📱 APNs Token: $apns');
        }
        final fcm = await _messaging.getToken();
        debugPrint('🔗 FCM Token: $fcm');
      } catch (e) {
        debugPrint('❌ Error retrieving FCM/APNs token: $e');
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
        debugPrint('❌ Could not get FCM token.');
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

      debugPrint('✅ Device token saved for user: $userId');
    } catch (e) {
      debugPrint('❌ Error saving user device token: $e');
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
            if (useLegacyIcon) 'icon': 'notification_icon', // 👈 SDK<33
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
      debugPrint('❌ FCM v1 error ${res.statusCode}: ${res.body}');
    } else {
      debugPrint('✅ Push sent');
    }
  }
}

// Top-level background handler (must be a static/global function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📬 BG message: ${message.notification?.title}');
}
