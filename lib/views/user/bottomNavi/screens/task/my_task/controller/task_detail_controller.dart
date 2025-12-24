import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/services/user_service.dart';

import '../../../../../../../services/offer_service2.dart';

class TaskDetailController extends GetxController {
  final RxInt updateTrigger = 0.obs;
  final RxBool isSubmitting = false.obs;
  final TextEditingController offerPriceController = TextEditingController();

  final OfferService2 _offerService = OfferService2();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString ownerUserId = ''.obs;
  RxString ownerName = ''.obs;
  RxString ownerPhotoUrl = ''.obs;
  RxDouble ownerRating = 4.9.obs;
  RxInt ownerTasksCompleted = 0.obs;
  RxInt ownerTasksRequested = 0.obs;
  RxBool isLoadingOwner = false.obs;

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
    double? taskBudget,
  }) async {
    try {
      // Validate price input
      final priceText = offerPriceController.text.trim();
      if (priceText.isEmpty) {
        Get.snackbar('Error', 'Please enter your offer price');
        return;
      }

      final offerPrice = double.tryParse(priceText);
      if (offerPrice == null || offerPrice <= 0) {
        Get.snackbar('Error', 'Please enter a valid price');
        return;
      }

      isSubmitting.value = true;

      // Get current user data
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'You must be logged in to submit an offer');
        isSubmitting.value = false;
        return;
      }

      final userData = await _authService.getUserData(currentUser.uid);
      final userName =
          userData?['displayName'] ?? currentUser.displayName ?? 'Unknown';
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
        taskBudget: taskBudget ?? 0.0,
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
        Get.snackbar('Success', 'Your offer has been submitted successfully!');
      } else {
        Get.snackbar('Error', 'Failed to submit offer. Please try again.');
      }
    } catch (e) {
      isSubmitting.value = false;
      Get.snackbar('Error', 'An error occurred: ${e.toString()}');
    }
  }

  /// Fetch owner data (name, photo, userId, rating) from Firestore
  Future<void> fetchOwnerData(String uid) async {
    if (uid.isEmpty) return;
    
    try {
      isLoadingOwner.value = true;
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          ownerName.value = data['displayName'] ?? data['name'] ?? 'User';
          ownerPhotoUrl.value = data['photoURL'] ?? data['photoUrl'] ?? '';
          ownerUserId.value = data['userId'] ?? '';
          
          final stats = await _userService.getUserStatistics(uid);
          ownerRating.value = (stats['rating'] ?? 5.0).toDouble();
          ownerTasksCompleted.value = stats['tasksCompleted'] ?? 0;
          ownerTasksRequested.value = stats['tasksRequested'] ?? 0;
        }
      }
    } catch (e) {
      print('Error fetching owner data: $e');
    } finally {
      isLoadingOwner.value = false;
    }
  }

  @override
  void onClose() {
    offerPriceController.dispose();
    super.onClose();
  }
}
