import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/services/offer_service.dart';

class TaskDetailController extends GetxController {
  final RxInt updateTrigger = 0.obs;
  final RxBool isSubmitting = false.obs;
  final TextEditingController offerPriceController = TextEditingController();

  final OfferService _offerService = OfferService();
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _startAutoRefreshTimer();
  }

  void _startAutoRefreshTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 30));
      updateTrigger.value++;
      return true;
    });
  }

  /// Submit offer for a task
  Future<void> submitOffer({
    required String taskId,
    required String taskTitle,
    required String taskDescription,
    required String taskTimeAgo,
    required String taskType,
    String? taskImage,
    String? location,
    required String taskOwnerUid,
    required String taskOwnerName,
    String? taskOwnerPhoto,
  }) async {
    try {
      // Validate price input
      final priceText = offerPriceController.text.trim();
      if (priceText.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your offer price',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final offerPrice = double.tryParse(priceText);
      if (offerPrice == null || offerPrice <= 0) {
        Get.snackbar(
          'Error',
          'Please enter a valid price',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isSubmitting.value = true;

      // Get current user data
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'You must be logged in to submit an offer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSubmitting.value = false;
        return;
      }

      final userData = await _authService.getUserData(currentUser.uid);
      final userName = userData?['displayName'] ?? currentUser.displayName ?? 'Unknown';
      final userPhoto = userData?['photoURL'] ?? currentUser.photoURL;

      // Prepare task details
      final taskDetails = {
        'title': taskTitle,
        'description': taskDescription,
        'timeAgo': taskTimeAgo,
        'taskType': taskType,
        if (taskImage != null) 'image': taskImage,
        if (location != null) 'location': location,
      };

      // Submit offer
      final success = await _offerService.submitOffer(
        taskId: taskId,
        offerPrice: offerPrice,
        taskDetails: taskDetails,
        taskOwnerUid: taskOwnerUid,
        taskOwnerName: taskOwnerName,
        taskOwnerPhoto: taskOwnerPhoto,
        offeringUserName: userName,
        offeringUserPhoto: userPhoto,
      );

      isSubmitting.value = false;

      if (success) {
        offerPriceController.clear();
        Get.back(); // Close dialog
        Get.snackbar(
          'Success',
          'Your offer has been submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit offer. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isSubmitting.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    offerPriceController.dispose();
    super.onClose();
  }
}
