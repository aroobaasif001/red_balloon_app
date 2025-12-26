import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveFeedbackController extends GetxController {
  final String taskId;
  final Map<String, dynamic> taskInfo;
  final Map<String, dynamic> otherUserData;
  final bool isRequester;

  LeaveFeedbackController({
    required this.taskId,
    required this.isRequester,
    required this.taskInfo,
    required this.otherUserData,
  });

  var rating = 0.0.obs;
  final reviewController = TextEditingController();
  var isLoading = false.obs;
  var currentReviewLength = 0.obs; // 🔥 Track character count

  @override
  void onInit() {
    super.onInit();
    reviewController.addListener(() {
      currentReviewLength.value = reviewController.text.length;
    });
  }

  // Getters for widgets
  RxString get initials {
     String name = otherUserData['name'] ?? '?';
     if (name.isNotEmpty) return name[0].toUpperCase().obs;
     return '?'.obs;
  }
  
  RxString get taskTitle => (taskInfo['title'] ?? 'Task').toString().obs;
  
  RxString get requesterName => (otherUserData['name'] ?? 'Unknown').toString().obs;
  
  RxString get requesterId => (otherUserData['userId'] ?? 'RB-0000').toString().obs;
  
  RxString get completedAgo {
      return 'recently'.obs; 
  }

  int get reviewLength => reviewController.text.length;

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  void setRating(double value) {
    rating.value = value;
  }

  Future<void> submitFeedback() async {
    // Validation
    if (rating.value == 0) {
      Get.snackbar('Error', 'Please select a star rating');
      return;
    }
    if (reviewController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please write a short review');
      return;
    }

    isLoading.value = true;

    try {
      final feedbackData = {
        'rating': rating.value,
        'review': reviewController.text.trim(),
        'createdAt': Timestamp.now(),
        'skipped': false,
      };

      await _updateFirestore(feedbackData);
      
       Get.back(); 
       Get.snackbar('Success', 'Feedback submitted successfully');

    } catch (e) {
      print("Error submitting feedback: $e");
      Get.snackbar('Error', 'Failed to submit feedback');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> skipFeedback() async {
    isLoading.value = true;

    try {
      final feedbackData = {
        'rating': 0,
        'review': '',
        'createdAt': Timestamp.now(),
        'skipped': true,
      };

      await _updateFirestore(feedbackData);
      Get.back(); // Go back

    } catch (e) {
      print("Error skipping feedback: $e");
      Get.snackbar('Error', 'Failed to skip feedback');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateFirestore(Map<String, dynamic> data) async {
    final fieldName = isRequester ? 'requesterFeedback' : 'helperFeedback';
    
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({
      fieldName: data,
    });
  }
}
