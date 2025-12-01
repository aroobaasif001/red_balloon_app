import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/task_service.dart';

class PostNewTaskController extends GetxController {
  final TaskService _taskService = TaskService();

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

    // Title
    if (taskTitle.text.trim().isEmpty) {
      titleError.value = "Task title is required";
      isValid = false;
    }

    // Description
    if (taskDescription.text.trim().isEmpty) {
      descriptionError.value = "Description is required";
      isValid = false;
    }

    // Budget
    if (taskBudget.text.trim().isEmpty) {
      budgetError.value = "Budget is required";
      isValid = false;
    }

    // Location — only for Offline Task
    if (selectedTaskType.value == "Offline Task" && location.text.trim().isEmpty) {
      locationError.value = "Location is required for offline tasks";
      isValid = false;
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

      // Create task
      final taskId = await _taskService.createTask(
        taskType: selectedTaskType.value,
        title: taskTitle.text.trim(),
        description: taskDescription.text.trim(),
        budget: budget,
        location: selectedTaskType.value == "Offline Task" ? location.text.trim() : null,
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

  @override
  void onClose() {
    taskTitle.dispose();
    taskDescription.dispose();
    taskBudget.dispose();
    location.dispose();
    super.onClose();
  }
}
