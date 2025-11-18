import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';

class DialogHelpers {
  // Add Funds Dialog Methods
  static void showAddFundsError(String message) {
    Get.snackbar('Error', message);
  }

  static void showAddFundsSuccess(String amount, String paymentMethod) {
    Get.snackbar(
      'Success',
      'Processing payment of SAR $amount via $paymentMethod',
    );
  }

  // Escrow Detail Dialog Methods
  static void showTaskDetailsInfo() {
    Get.snackbar('Task Details', 'Navigating to task details...');
  }

  // Wallet Controller Dialog Methods
  static void showFundReleaseInfo() {
    Get.snackbar('Info', 'Funds are auto-released after successful validation');
  }
}
