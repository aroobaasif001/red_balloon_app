import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

class WithdrawFundsController extends GetxController {
  late TextEditingController amountController;
  late TextEditingController paymentMethodController;

  @override
  void onInit() {
    super.onInit();
    amountController = TextEditingController();
    paymentMethodController = TextEditingController();
  }

  @override
  void onClose() {
    amountController.dispose();
    paymentMethodController.dispose();
    super.onClose();
  }

  void submitWithdrawal() {
    DialogHelpers.handleWithdrawalRequest();
  }
}
