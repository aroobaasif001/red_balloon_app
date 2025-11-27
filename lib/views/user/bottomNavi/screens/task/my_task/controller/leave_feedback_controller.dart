import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveFeedbackController extends GetxController {
  // Task / requester info
  RxString taskTitle = 'Help Move Furniture'.obs;
  RxString requesterName = 'Ahmed Al-Harbi'.obs;
  RxString requesterId = 'RB-124'.obs;
  RxString completedAgo = '2h ago'.obs;
  RxString initials = 'AA'.obs;

  // Rating (1-5)
  RxInt rating = 0.obs;

  // Review text
  final TextEditingController reviewController = TextEditingController();

  int get reviewLength => reviewController.text.length;

  void setRating(int value) {
    rating.value = value;
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
