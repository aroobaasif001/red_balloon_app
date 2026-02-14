import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/task_service.dart';
import 'package:red_balloon_app/services/wallet_service.dart';

import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';

class PostNewTaskController extends GetxController {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();
  final WalletService _walletService = WalletService();
  final ImagePicker _imagePicker = ImagePicker(); // 🔥 Added ImagePicker

  // Dropdown
  var selectedTaskType = "".obs;

  // Text controllers
  final taskTitle = TextEditingController();
  final taskDescription = TextEditingController();
  final taskBudget = TextEditingController();
  final location = TextEditingController();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  // Error fields
  RxString taskTypeError = "".obs;
  RxString titleError = "".obs;
  RxString descriptionError = "".obs;
  RxString budgetError = "".obs;
  RxString locationError = "".obs;
  RxString imageError = "".obs;

  // Character counts
  RxInt titleLength = 0.obs;
  RxInt descriptionLength = 0.obs;
  RxInt budgetLength = 0.obs;
  RxInt locationLength = 0.obs;

  // Loading state
  RxBool isLoading = false.obs;

  // File
  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);
  RxString uploadedImageUrl = "".obs;
  RxBool isUploadingImage = false.obs;

  // Wallet
  RxDouble walletBalance = 0.0.obs;

  final List<String> taskTypes = ["Offline Task", "Online Task"];
  
  // Editing state
  RxBool isEditing = false.obs;
  TaskModel? editingTask;

  void initializeForEditing(TaskModel task) {
    isEditing.value = true;
    editingTask = task;

    selectedTaskType.value = task.taskType;
    taskTitle.text = task.title;
    taskDescription.text = task.description;
    taskBudget.text = task.budget.toInt().toString();
    location.text = task.location ?? "";
    latitude.value = task.latitude ?? 0.0;
    longitude.value = task.longitude ?? 0.0;
    uploadedImageUrl.value = task.imageUrl ?? "";

    // Set lengths
    titleLength.value = task.title.length;
    descriptionLength.value = task.description.length;
    budgetLength.value = task.budget.toInt().toString().length;
    locationLength.value = (task.location ?? "").length;
  }

  // File

  // File picker selection logic
  Future<void> pickMedia() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              "Select Media Source",
              fontSize: 18,
              fontWeight: FontVariant.bold,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo_library, color: redColor),
              title: CustomText("Photo Gallery", fontSize: 16),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: redColor),
              title: CustomText("Camera", fontSize: 16),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file, color: redColor),
              title: CustomText("Files / Documents (PDF)", fontSize: 16),
              onTap: () {
                Get.back();
                _pickFromFileManager();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 🔥 Helper: Pick via ImagePicker (Best for iOS Gallery)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        final file = File(image.path);
        final size = await file.length();

        // Max 5MB
        if (size > 5 * 1024 * 1024) {
          Get.snackbar("Error", "File too large! Max size is 5MB");
          return;
        }

        // Convert XFile to PlatformFile-like structure for existing logic
        pickedFile.value = PlatformFile(
          name: image.name,
          size: size,
          path: image.path,
        );
        imageError.value = "";

        // Auto-upload
        await uploadImageToFirebase(pickedFile.value!);
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  // 🔥 Helper: Pick via FilePicker (For PDFs)
  Future<void> _pickFromFileManager() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      // Max 5MB
      if (file.size > 5 * 1024 * 1024) {
        Get.snackbar("Error", "File too large! Max size is 5MB");
        return;
      }
      pickedFile.value = file;
      imageError.value = "";

      // Auto-upload
      await uploadImageToFirebase(file);
    }
  }

  Future<void> uploadImageToFirebase(PlatformFile file) async {
    try {
      isUploadingImage.value = true;
      imageError.value = "";

      if (file.path == null) {
        imageError.value = "Unable to access file";
        isUploadingImage.value = false;
        return;
      }

      final imageFile = File(file.path!);
      final fileName =
          'task_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final uploadUrl = await _taskService.uploadTaskImage(imageFile, fileName);

      if (uploadUrl != null) {
        uploadedImageUrl.value = uploadUrl;
        Get.snackbar("Success", "Image uploaded successfully");
      } else {
        imageError.value = "Failed to upload image. Please try again.";
        pickedFile.value = null;
      }
    } catch (e) {
      imageError.value = "Error uploading image: ${e.toString()}";
      pickedFile.value = null;
    } finally {
      isUploadingImage.value = false;
    }
  }

  void removeFile() {
    pickedFile.value = null;
    uploadedImageUrl.value = "";
    imageError.value = "";
  }

  // ---------------- VALIDATION ----------------
  bool validateForm() {
    bool isValid = true;

    // Reset errors
    taskTypeError.value = "";
    titleError.value = "";
    descriptionError.value = "";
    budgetError.value = "";
    locationError.value = "";

    // Task Type
    if (selectedTaskType.value.isEmpty) {
      taskTypeError.value = "Please select task type";
      isValid = false;
    }

    // Title validation
    final title = taskTitle.text.trim();
    if (title.isEmpty) {
      titleError.value = "Task title is required";
      isValid = false;
    } else if (title.length < 5) {
      titleError.value = "Title must be at least 5 characters";
      isValid = false;
    } else if (title.length > 25) {
      titleError.value = "Title must not exceed 25 characters";
      isValid = false;
    }

    // Description validation
    final description = taskDescription.text.trim();
    if (description.isEmpty) {
      descriptionError.value = "Description is required";
      isValid = false;
    } else if (description.length < 10) {
      descriptionError.value = "Description must be at least 10 characters";
      isValid = false;
    } else if (description.length > 100) {
      descriptionError.value = "Description must not exceed 100 characters";
      isValid = false;
    }

    // Budget validation
    final budgetText = taskBudget.text.trim();
    if (budgetText.isEmpty) {
      budgetError.value = "Budget is required";
      isValid = false;
    } else {
      final budget = double.tryParse(budgetText);
      if (budget == null) {
        budgetError.value = "Please enter a valid number";
        isValid = false;
      } else if (budget < 15) {
        budgetError.value = "Minimum budget is SAR 15";
        isValid = false;
      } else if (budget > 10000) {
        budgetError.value = "Maximum budget is SAR 10,000";
        isValid = false;
      }
    }

    // Location validation — only for Offline Task
    if (selectedTaskType.value == "Offline Task") {
      final loc = location.text.trim();
      if (loc.isEmpty) {
        locationError.value = "Location is required for offline tasks";
        isValid = false;
      } else if (loc.length > 250) {
        locationError.value = "Location must not exceed 250 characters";
        isValid = false;
      }
    }

    // Image validation — now required
    if (uploadedImageUrl.value.isEmpty) {
      imageError.value = "Image is required. Please upload an image.";
      isValid = false;
    }

    return isValid;
  }

  // Submit task to Firebase
  Future<bool> submitTask() async {
    try {
      isLoading.value = true;

      // Parse budget
      final budget = double.tryParse(taskBudget.text.trim()) ?? 0.0;

      if (isEditing.value && editingTask != null) {
        return await updateTask(budget);
      }

      // 1. Check Wallet Balance
      final currentBal = await _walletService.getCurrentBalance();
      if (currentBal < budget) {
        isLoading.value = false;
        Get.snackbar(
          "Insufficient Balance",
          "You need SAR $budget to post this task. Your current balance is SAR $currentBal.",
        );
        return false;
      }

      // Ensure userId is available
      if (storedUserId == null) {
        await fetchUserData();
      }

      print('🚀 Submitting Task...');
      print('   Type: ${selectedTaskType.value}');
      print('   UserID (Custom): $storedUserId');
      print('   Image URL: ${uploadedImageUrl.value}');

      // 2. Create task with uploaded image URL
      // (Escrow field will be added inside TaskService.createTaskWithImageUrl)
      final taskId = await _taskService.createTaskWithImageUrl(
        taskType: selectedTaskType.value,
        title: taskTitle.text.trim(),
        description: taskDescription.text.trim(),
        budget: budget,
        location: selectedTaskType.value == "Offline Task"
            ? location.text.trim()
            : null,
        latitude: selectedTaskType.value == "Offline Task" ? latitude.value : null,
        longitude: selectedTaskType.value == "Offline Task" ? longitude.value : null,
        userId: storedUserId,
        imageUrl: uploadedImageUrl.value,
      );

      if (taskId != null) {
        // 3. Deduct Funds and Create Transaction Record
        final deductResult = await _walletService.deductForEscrow(
          amount: budget,
          taskId: taskId,
          taskTitle: taskTitle.text.trim(),
        );

        if (!deductResult['success']) {
          // This should ideally not happen if balance check above succeeded, 
          // but good for atomic safety (though not fully atomic here as task is already created)
          // You might want to delete the task if deduction fails, but we'll keep it simple for now.
          print('⚠️ Deduction failed after task creation: ${deductResult['message']}');
          Get.snackbar("Error", deductResult['message']);
          isLoading.value = false;
          return false;
        }

        // Send actual push notification to user using current UID
        try {
          final currentUid = FirebaseAuth.instance.currentUser?.uid;
          if (currentUid != null) {
            await NotificationService.instance.notifyTaskPosted(
              userId: currentUid,
              taskTitle: taskTitle.text.trim(),
              taskId: taskId,
            );
            print('✅ Push notification sent for task: $taskId to user: $currentUid');
          } else {
            print('⚠️ Cannot send notification: current user is null');
          }
        } catch (e) {
          print('⚠️ Error sending push notification: $e');
          // Don't fail the task creation if notification fails
        }
        
        // Clear form
        clearForm();
        isLoading.value = false;
        return true;
      }

      isLoading.value = false;
      return false;
    } catch (e) {
      isLoading.value = false;
      print('Error submitting task: $e');
      return false;
    }
  }

  Future<bool> updateTask(double newBudget) async {
    try {
      if (editingTask == null) return false;

      final oldBudget = editingTask!.budget;
      
      // 1. Adjust Escrow/Wallet if budget changed
      if (newBudget != oldBudget) {
        final adjustmentResult = await _walletService.adjustEscrowAfterOfferAcceptance(
          taskId: editingTask!.id!,
          taskBudget: oldBudget,
          offerPrice: newBudget, // Reusing this logic for edit as it's the same
          taskTitle: taskTitle.text.trim(),
        );

        if (!adjustmentResult['success']) {
          Get.snackbar("Error", adjustmentResult['message']);
          isLoading.value = false;
          return false;
        }
      }

      // 2. Update Task Data
      final Map<String, dynamic> updates = {
        'taskType': selectedTaskType.value,
        'title': taskTitle.text.trim(),
        'description': taskDescription.text.trim(),
        'budget': newBudget,
        'location': selectedTaskType.value == "Offline Task" ? location.text.trim() : null,
        'latitude': selectedTaskType.value == "Offline Task" ? latitude.value : null,
        'longitude': selectedTaskType.value == "Offline Task" ? longitude.value : null,
        'imageUrl': uploadedImageUrl.value,
        'escrow.amount': newBudget, // Update embedded escrow amount too
      };

      await _taskService.updateTask(editingTask!.id!, updates);
      
      Get.snackbar("Success", "Task updated successfully");
      
      // Clear form and reset state
      clearForm();
      isLoading.value = false;
      return true;
    } catch (e) {
      print('Error updating task: $e');
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> deleteTask(String taskId, double budget, String title) async {
    try {
      isLoading.value = true;

      // 1. Return funds from escrow to wallet (96% refund, 4% tax)
      final refundResult = await _walletService.refundEscrowWithTax(
        taskId: taskId,
        budget: budget,
        taskTitle: title,
      );

      if (!refundResult['success']) {
        Get.snackbar("Error", "Failed to refund funds: ${refundResult['message']}");
        isLoading.value = false;
        return false;
      }

      // 2. Delete task from Firestore
      await _taskService.deleteTask(taskId);
      
      Get.snackbar("Success", "Task deleted. 96% of the budget (SAR ${budget * 0.96}) returned to wallet.");
      isLoading.value = false;
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      isLoading.value = false;
      return false;
    }
  }

  // Clear form
  void clearForm() {
    isEditing.value = false;
    editingTask = null;
    selectedTaskType.value = "";
    taskTitle.clear();
    taskDescription.clear();
    taskBudget.clear();
    location.clear();
    latitude.value = 0.0;
    longitude.value = 0.0;
    pickedFile.value = null;

    // Clear errors
    taskTypeError.value = "";
    titleError.value = "";
    descriptionError.value = "";
    budgetError.value = "";
    locationError.value = "";
    imageError.value = "";
    uploadedImageUrl.value = "";
  }

  String? storedUserId;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchWalletBalance();
  }

  Future<void> fetchWalletBalance() async {
    _walletService.getWalletBalance().listen((balance) {
      walletBalance.value = balance;
    });
  }

  Future<void> fetchUserData() async {
    try {
      final currentUser = _authService.getCurrentUserModel();
      if (currentUser != null) {
        final userData = await _authService.getUserData(currentUser.uid);
        if (userData != null) {
          storedUserId = userData['userId'];
          print("✅ PostNewTaskController: Fetched userId: $storedUserId");
        }
      }
    } catch (e) {
      print("❌ Error fetching user data in PostNewTaskController: $e");
    }
  }

  @override
  void onClose() {
    taskTitle.dispose();
    taskDescription.dispose();
    taskBudget.dispose();
    location.dispose();
    super.onClose();
  }
}
