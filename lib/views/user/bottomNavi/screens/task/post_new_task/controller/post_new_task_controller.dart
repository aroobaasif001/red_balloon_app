import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostNewTaskController extends GetxController {
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

    // Location — only for Online Task
    if (selectedTaskType.value == "Online Task" && location.text.trim().isEmpty) {
      locationError.value = "Location is required for online tasks";
      isValid = false;
    }

    return isValid;
  }
}
