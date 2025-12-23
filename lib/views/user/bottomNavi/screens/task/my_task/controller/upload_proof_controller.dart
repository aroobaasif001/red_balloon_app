import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../services/auth_service.dart';
import '../../../../../../../services/task_service.dart';
import '../../../../../../../services/notification_services.dart';

enum ProofTab { before, after }

class UploadProofController extends GetxController {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  // Task data (received from constructor)
  String? taskId;
  String? taskOwnerUid; // 🔥 Added owner UID
  RxString taskTitle = 'Help Move Furniture'.obs;
  RxString taskCode = 'RB - 402'.obs;
  RxString taskPrice = '500'.obs;

  // BEFORE / AFTER tab state
  final Rx<ProofTab> selectedTab = ProofTab.before.obs;

  void selectBefore() => selectedTab.value = ProofTab.before;
  void selectAfter() => selectedTab.value = ProofTab.after;

  // Instruction text
  RxString infoText =
      'Please upload clear photos showing the completed task.'.obs;

  // Note field controller
  final TextEditingController noteController = TextEditingController();

  // Image files
  Rx<File?> beforePhoto = Rx<File?>(null);
  Rx<File?> afterPhoto = Rx<File?>(null);

  // Loading state
  RxBool isSubmitting = false.obs;

  // Initialize with task data
  void initializeTaskData({
    required String id,
    required String title,
    required String price,
    required String ownerUid,
  }) {
    taskId = id;
    taskTitle.value = title;
    taskPrice.value = price;
    taskOwnerUid = ownerUid;
  }

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        if (selectedTab.value == ProofTab.before) {
          beforePhoto.value = file;
        } else {
          afterPhoto.value = file;
        }
      }
    } catch (e) {
      print('Error picking image from camera: $e');
      Get.snackbar('Error', 'Failed to capture image');
    }
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        if (selectedTab.value == ProofTab.before) {
          beforePhoto.value = file;
        } else {
          afterPhoto.value = file;
        }
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      Get.snackbar('Error', 'Failed to select image');
    }
  }

  /// Remove before photo
  void removeBeforePhoto() {
    beforePhoto.value = null;
  }

  /// Remove after photo
  void removeAfterPhoto() {
    afterPhoto.value = null;
  }

  /// Submit proof
  Future<void> submitProof() async {
    try {
      if (taskId == null) {
        Get.snackbar('Error', 'Task ID is missing');
        return;
      }

      isSubmitting.value = true;
      
      // 🔥 Verification: Check if both photos are provided
      if (beforePhoto.value == null) {
        Get.snackbar('Error', 'Please upload a Before photo');
        isSubmitting.value = false;
        return;
      }
      if (afterPhoto.value == null) {
        Get.snackbar('Error', 'Please upload an After photo');
        isSubmitting.value = false;
        return;
      }

      // Get current user info
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'User not authenticated');
        isSubmitting.value = false;
        return;
      }

      // Get user data from Firestore to get username
      final userData = await _authService.getUserData(currentUser.uid);
      final username =
          userData?['displayName'] ?? currentUser.displayName ?? 'Unknown User';
      final userPhotoUrl = userData?['photoURL'] ?? currentUser.photoURL;

      // Upload images to Firebase Storage (optional)
      String? beforePhotoUrl;
      String? afterPhotoUrl;

      if (beforePhoto.value != null) {
        beforePhotoUrl = await _taskService.uploadProofImage(
          beforePhoto.value!,
          taskId!,
          'before',
        );
      }

      if (afterPhoto.value != null) {
        afterPhotoUrl = await _taskService.uploadProofImage(
          afterPhoto.value!,
          taskId!,
          'after',
        );
      }

      // Submit proof to Firestore
      final proofId = await _taskService.submitTaskProof(
        taskId: taskId!,
        userId: currentUser.uid,
        username: username,
        userPhotoUrl: userPhotoUrl,
        beforePhotoUrl: beforePhotoUrl,
        afterPhotoUrl: afterPhotoUrl,
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
        taskTitle: taskTitle.value,
        taskPrice: taskPrice.value,
      );

      // 🔥 Send Notification to Task Owner
      if (taskOwnerUid != null && proofId != null) {
        NotificationService.instance.notifyProofUploaded(
          taskOwnerId: taskOwnerUid!,
          helperName: username,
          taskTitle: taskTitle.value,
          taskId: taskId!,
          proofId: proofId,
        );
      }

      isSubmitting.value = false;

      // // Update InProgressTaskController to change button text
      // try {
      //   final inProgressController = Get.find<InProgressTaskController>();
      //   inProgressController.isSubmitted.value = true;
      // } catch (e) {
      //   print('InProgressTaskController not found: $e');
      // }

      // Success - return to previous screen
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Proof has been uploaded successfully!',
      );
    } catch (e) {
      isSubmitting.value = false;
      print('Error submitting proof: $e');
      Get.snackbar(
        'Error',
        'Failed to submit proof. Please try again.',
      );
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
