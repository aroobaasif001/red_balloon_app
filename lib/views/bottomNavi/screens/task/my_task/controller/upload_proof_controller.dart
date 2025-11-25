import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ProofTab { before, after }

class UploadProofController extends GetxController {
  // BEFORE / AFTER tab state
  final Rx<ProofTab> selectedTab = ProofTab.before.obs;

  void selectBefore() => selectedTab.value = ProofTab.before;
  void selectAfter() => selectedTab.value = ProofTab.after;

  // Top card dynamic data
  RxString taskTitle = 'Help Move Furniture'.obs;
  RxString taskCode = 'RB - 402'.obs;
  RxString taskPrice = '500'.obs;

  // Instruction text
  RxString infoText =
      'Please upload clear photos showing the completed task.'.obs;

  // Note field controller
  final TextEditingController noteController = TextEditingController();

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
