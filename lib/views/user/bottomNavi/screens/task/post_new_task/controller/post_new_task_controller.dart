import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/services/task_service.dart';

class PostNewTaskController extends GetxController {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();

  // Dropdown
  var selectedTaskType = "".obs;

  // Text controllers
  final taskTitle = TextEditingController();
  final taskDescription = TextEditingController();
  final taskBudget = TextEditingController();
  final location = TextEditingController();

  // Error fields
  RxString taskTypeError = "".obs;
  RxString titleError = "".obs;
  RxString descriptionError = "".obs;
  RxString budgetError = "".obs;
  RxString locationError = "".obs;

  // Character counts
  RxInt titleLength = 0.obs;
  RxInt descriptionLength = 0.obs;
  RxInt budgetLength = 0.obs;
  RxInt locationLength = 0.obs;

  // Loading state
  RxBool isLoading = false.obs;

  // File
  Rx<PlatformFile?> pickedFile = Rx<PlatformFile?>(null);

  final List<String> taskTypes = ["Offline Task", "Online Task"];

  // File

  Future<void> pickMedia() async {
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
    }
  }

  void removeFile() {
    pickedFile.value = null;
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
      } else if (loc.length > 50) {
        locationError.value = "Location must not exceed 50 characters";
        isValid = false;
      }
    }

    return isValid;
  }

  // Submit task to Firebase
  Future<bool> submitTask() async {
    try {
      isLoading.value = true;

      // Get image file if available
      File? imageFile;
      if (pickedFile.value != null && pickedFile.value!.path != null) {
        imageFile = File(pickedFile.value!.path!);
      }

      // Parse budget
      final budget = double.tryParse(taskBudget.text.trim()) ?? 0.0;

      // Ensure userId is available
      if (storedUserId == null) {
        await fetchUserData();
      }
      
      print('🚀 Submitting Task...');
      print('   Type: ${selectedTaskType.value}');
      print('   UserID (Custom): $storedUserId');

      // Create task
      final taskId = await _taskService.createTask(
        taskType: selectedTaskType.value,
        title: taskTitle.text.trim(),
        description: taskDescription.text.trim(),
        budget: budget,
        location: selectedTaskType.value == "Offline Task" ? location.text.trim() : null,
        userId: storedUserId,
        imageFile: imageFile,
      );

      isLoading.value = false;

      if (taskId != null) {
        // Clear form
        clearForm();
        return true;
      }

      return false;
    } catch (e) {
      isLoading.value = false;
      print('Error submitting task: $e');
      return false;
    }
  }

  // Clear form
  void clearForm() {
    selectedTaskType.value = "";
    taskTitle.clear();
    taskDescription.clear();
    taskBudget.clear();
    location.clear();
    pickedFile.value = null;

    // Clear errors
    taskTypeError.value = "";
    titleError.value = "";
    descriptionError.value = "";
    budgetError.value = "";
    locationError.value = "";
  }
  
  String? storedUserId;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
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
