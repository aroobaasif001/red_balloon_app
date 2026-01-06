import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

class NotificationPermissionController extends GetxController
    with WidgetsBindingObserver {
  final RxBool isNotificationEnabled = false.obs;
  final RxInt denialCount = 0.obs;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  bool _isRequesting = false; // Prevent concurrent requests
  static const int maxDenials = 2; // After 2 denials, show settings dialog

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialPermissionStatus();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app returns from settings, check permission again
    if (state == AppLifecycleState.resumed) {
      _checkInitialPermissionStatus();
    }
  }

  /// Check current notification permission status
  Future<void> _checkInitialPermissionStatus() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      isNotificationEnabled.value =
          settings.authorizationStatus == AuthorizationStatus.authorized;
      debugPrint(
        '🔔 Initial notification status: ${settings.authorizationStatus}',
      );
    } catch (e) {
      debugPrint('Error checking notification permission: $e');
    }
  }

  /// Handle toggle switch action
  Future<void> handleToggle(bool value) async {
    if (value) {
      // User wants to enable notifications
      await _requestNotificationPermission();
    } else {
      // User wants to disable - show dialog to go to settings
      _showDisableDialog();
    }
  }

  /// Request notification permission
  Future<void> _requestNotificationPermission() async {
    // Prevent concurrent requests
    if (_isRequesting) {
      debugPrint('⚠️ Permission request already in progress, ignoring...');
      return;
    }

    _isRequesting = true;

    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        isNotificationEnabled.value = true;
        denialCount.value = 0;
        Get.snackbar('Success', 'Notifications enabled successfully');
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        denialCount.value++;

        if (denialCount.value >= maxDenials) {
          // Show settings dialog after multiple denials
          _showSettingsDialog();
        } else {
          Get.snackbar(
            'Permission Denied',
            'Please allow notifications to stay updated',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
        isNotificationEnabled.value = false;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.notDetermined) {
        // Permission dialog was dismissed
        isNotificationEnabled.value = false;
      }
    } catch (e) {
      if (e.toString().contains('already running')) {
        debugPrint(
          '⚠️ Permission request already in progress (silently ignored)',
        );
        // Silently ignore concurrent requests - do not show snackbar
        return;
      } else {
        debugPrint('Error requesting notification permission: $e');
        // Revert toggle state if request failed
        isNotificationEnabled.value = false;
      }
    } finally {
      _isRequesting = false;
    }
  }

  /// Show dialog when user wants to disable notifications
  void _showDisableDialog() {
    DialogHelpers.showCustomDialog(
      title: 'Disable Notifications',
      message:
          'To disable notifications, please go to your device settings and turn them off for Red Balloon.',
      confirmText: 'Open Settings',
      cancelText: 'Cancel',
      onConfirm: () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      },
      iconData: Icons.notifications_off,
    );
  }

  /// Show dialog after multiple denials directing user to settings
  void _showSettingsDialog() {
    DialogHelpers.showCustomDialog(
      title: 'Notification Permission Required',
      message:
          'You have denied notification permission multiple times. Please enable it from app settings to receive important updates.',
      confirmText: 'Open Settings',
      cancelText: 'Not Now',
      onConfirm: () {
        denialCount.value = 0; // Reset count
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      },
      onCancel: () {
        // Just close dialog
      },
    );
  }
}
