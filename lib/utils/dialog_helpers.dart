import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';

class DialogHelpers {
  // Show a simple snackbar
  static void showSnackBar({
    required String title,
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: position,
      duration: duration,
    );
  }

  // Show an error snackbar
  static void showErrorSnackBar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      title: title,
      message: message,
      backgroundColor: Colors.red.withOpacity(0.8),
      textColor: Colors.white,
      position: position,
      duration: duration,
    );
  }

  // Show a success snackbar
  static void showSuccessSnackBar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      title: title,
      message: message,
      backgroundColor: Colors.green.withOpacity(0.8),
      textColor: Colors.white,
      position: position,
      duration: duration,
    );
  }

  // Show an info snackbar
  static void showInfoSnackBar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      title: title,
      message: message,
      backgroundColor: Colors.blue.withOpacity(0.8),
      textColor: Colors.white,
      position: position,
      duration: duration,
    );
  }

  // Show consent required snackbar
  static void showConsentRequiredSnackBar() {
    showErrorSnackBar(
      title: 'Agreement Required',
      message: 'You must agree to the Terms of Service and Privacy Policy',
    );
  }

  // Show a confirmation dialog
  static Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText, style: TextStyle(color: greyColor)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText, style: TextStyle(color: redColor)),
          ),
        ],
      ),
    );
  }

  // Show a custom dialog
  static Future<T?> showCustomDialog<T>({
    required Widget content,
    bool barrierDismissible = true,
  }) async {
    return await Get.dialog<T>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Show a loading dialog
  static void showLoadingDialog({String message = 'Please wait...'}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(redColor)),
              SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide any open dialog
  static void hideDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
