import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = AuthService();

  // Text controllers
  late TextEditingController displayNameController;
  late TextEditingController cityController;
  late TextEditingController countryController;
  late TextEditingController phoneController;
  late TextEditingController workExperienceController;

  // Country code
  RxString selectedCountryCode = '+1'.obs;

  // Error messages
  RxString displayNameError = ''.obs;
  RxString cityError = ''.obs;
  RxString countryError = ''.obs;
  RxString phoneError = ''.obs;
  RxString workExperienceError = ''.obs;

  // List of country codes
  final List<String> countryCodes = [
    // Asia
    '+91',   // India
    '+92',   // Pakistan
    '+94',   // Sri Lanka
    '+971',  // UAE
    '+966',  // Saudi Arabia
    '+86',   // China
    '+81',   // Japan
    '+880',  // Bangladesh
    '+977',  // Nepal
    '+93',   // Afghanistan
    '+975',  // Bhutan
    '+960',  // Maldives
    '+95',   // Myanmar
    '+66',   // Thailand
    '+84',   // Vietnam
    '+63',   // Philippines
    '+62',   // Indonesia
    '+60',   // Malaysia
    '+65',   // Singapore
    '+82',   // South Korea
    '+886',  // Taiwan
    '+852',  // Hong Kong
    '+98',   // Iran
    '+964',  // Iraq
    '+962',  // Jordan
    '+965',  // Kuwait
    '+961',  // Lebanon
    '+968',  // Oman
    '+974',  // Qatar
    '+973',  // Bahrain
    '+967',  // Yemen
    '+90',   // Turkey
    '+972',  // Israel
    // North America
    '+1',    // USA/Canada
    // Europe
    '+44',   // UK
    '+33',   // France
    '+49',   // Germany
    '+39',   // Italy
    '+34',   // Spain
    // Oceania
    '+61',   // Australia
    '+64',   // New Zealand
    // Africa
    '+27',   // South Africa
  ];

  // Image file
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString imagePreviewUrl = ''.obs;

  // Loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadCurrentUserData();
  }

  // Refresh user data after update
  Future<void> refreshUserData() async {
    await _loadCurrentUserData();
  }

  void _initializeControllers() {
    displayNameController = TextEditingController();
    cityController = TextEditingController();
    countryController = TextEditingController();
    phoneController = TextEditingController();
    workExperienceController = TextEditingController();
  }

  Future<void> _loadCurrentUserData() async {
    final currentUser = _authService.getCurrentUserModel();
    if (currentUser != null) {
      displayNameController.text = currentUser.displayName ?? '';
      imagePreviewUrl.value = currentUser.photoURL ?? '';

      // Load additional profile data from Firestore
      final userData = await _authService.getUserData(currentUser.uid);
      if (userData != null) {
        cityController.text = userData['city'] ?? '';
        countryController.text = userData['country'] ?? '';
        workExperienceController.text = userData['workExperience'] ?? '';
        
        // Parse phone number with country code
        final phoneNumber = userData['phoneNumber'] ?? '';
        if (phoneNumber.isNotEmpty) {
          // Extract country code and phone number
          final match = RegExp(r'^(\+\d{1,3})\s*(.*)$').firstMatch(phoneNumber);
          if (match != null) {
            selectedCountryCode.value = match.group(1) ?? '+1';
            phoneController.text = match.group(2) ?? '';
          } else {
            phoneController.text = phoneNumber;
            selectedCountryCode.value = '+1';
          }
        }
      }
    }
  }

  // Pick image from gallery
  Future<void> pickProfileImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Max 5MB
        if (file.size > 5 * 1024 * 1024) {
          Get.snackbar("Error", "File too large! Max size is 5MB");
          return;
        }

        if (file.path != null) {
          selectedImage.value = File(file.path!);
          imagePreviewUrl.value = file.path!;
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  // Remove selected image
  void removeSelectedImage() {
    selectedImage.value = null;
    // Keep the original image URL if no new image is selected
    _loadCurrentUserData();
  }

  // Validation methods
  bool validateDisplayName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      displayNameError.value = "Display name is required";
      return false;
    }
    if (trimmed.length < 2) {
      displayNameError.value = "Display name must be at least 2 characters";
      return false;
    }
    if (trimmed.length > 50) {
      displayNameError.value = "Display name must not exceed 50 characters";
      return false;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
      displayNameError.value =
          "Display name can only contain letters and spaces";
      return false;
    }
    displayNameError.value = "";
    return true;
  }

  bool validateCity(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      cityError.value = "City is required";
      return false;
    }
    if (trimmed.length < 2) {
      cityError.value = "City must be at least 2 characters";
      return false;
    }
    if (trimmed.length > 50) {
      cityError.value = "City must not exceed 50 characters";
      return false;
    }
    cityError.value = "";
    return true;
  }

  bool validateCountry(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      countryError.value = "Country is required";
      return false;
    }
    if (trimmed.length < 2) {
      countryError.value = "Country must be at least 2 characters";
      return false;
    }
    if (trimmed.length > 50) {
      countryError.value = "Country must not exceed 50 characters";
      return false;
    }
    countryError.value = "";
    return true;
  }

  bool validatePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      phoneError.value = "Phone number is required";
      return false;
    }
    // Remove all non-digit characters for validation
    final digitsOnly = trimmed.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 7) {
      phoneError.value = "Phone number must have at least 7 digits";
      return false;
    }
    if (digitsOnly.length > 15) {
      phoneError.value = "Phone number must not exceed 15 digits";
      return false;
    }
    phoneError.value = "";
    return true;
  }

  bool validateWorkExperience(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && trimmed.length > 500) {
      workExperienceError.value =
          "Work experience must not exceed 500 characters";
      return false;
    }
    workExperienceError.value = "";
    return true;
  }

  // Validate all fields
  bool validateAllFields() {
    bool isValid = true;

    if (!validateDisplayName(displayNameController.text)) {
      isValid = false;
    }
    if (!validateCity(cityController.text)) {
      isValid = false;
    }
    if (!validateCountry(countryController.text)) {
      isValid = false;
    }
    if (!validatePhone(phoneController.text)) {
      isValid = false;
    }
    if (!validateWorkExperience(workExperienceController.text)) {
      isValid = false;
    }

    return isValid;
  }

  // Clear all errors
  void clearErrors() {
    displayNameError.value = "";
    cityError.value = "";
    countryError.value = "";
    phoneError.value = "";
    workExperienceError.value = "";
  }

  // Update profile
  Future<bool> updateProfile() async {
    try {
      isLoading.value = true;
      clearErrors();

      // Validate all fields
      if (!validateAllFields()) {
        isLoading.value = false;
        Get.snackbar("Error", "Please fix the errors in the form");
        return false;
      }

      final displayName = displayNameController.text.trim();
      final city = cityController.text.trim();
      final country = countryController.text.trim();
      final phone = phoneController.text.trim();
      final workExperience = workExperienceController.text.trim();
      final countryCode = selectedCountryCode.value;
      
      // Combine country code with phone number
      final fullPhoneNumber = '$countryCode $phone';

      // Update Firebase Auth display name
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(displayName);

        // Upload new image if selected
        String? newPhotoURL;
        if (selectedImage.value != null) {
          newPhotoURL = await _authService.uploadProfileImage(
            selectedImage.value!,
          );
        }

        // Prepare update data for Firestore
        final updateData = {
          'displayName': displayName,
          'phoneNumber': fullPhoneNumber,
          'updatedAt': DateTime.now().toIso8601String(),
        };

        // Add optional fields
        if (newPhotoURL != null) {
          updateData['photoURL'] = newPhotoURL;
        }

        // Add additional profile fields
        updateData['city'] = city;
        updateData['country'] = country;
        updateData['workExperience'] = workExperience;

        // Update user profile in Firestore with all fields
        await _authService.updateUserProfileWithFields(
          uid: currentUser.uid,
          updateData: updateData,
        );

        // Refresh the user data to reflect changes immediately
        await refreshUserData();

        // Refresh AuthController to update all screens
        final authController = Get.find<AuthController>();
        await authController.refreshCurrentUser();

        isLoading.value = false;
        Get.snackbar("Success", "Profile updated successfully");
        return true;
      }

      isLoading.value = false;
      return false;
    } catch (e) {
      isLoading.value = false;
      print('Error updating profile: $e');
      Get.snackbar("Error", "Failed to update profile");
      return false;
    }
  }

  @override
  void onClose() {
    displayNameController.dispose();
    cityController.dispose();
    countryController.dispose();
    phoneController.dispose();
    workExperienceController.dispose();
    super.onClose();
  }
}
