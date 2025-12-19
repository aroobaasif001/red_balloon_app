import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = AuthService();

  // Text controllers
  late TextEditingController displayNameController;
  late TextEditingController userIdController;
  late TextEditingController cityController;
  late TextEditingController countryController;
  late TextEditingController phoneController;
  late TextEditingController workExperienceController;

  // User ID from database
  RxString userId = ''.obs;

  // Country code
  RxString selectedCountryCode = '+966'.obs;

  // Error messages
  RxString displayNameError = ''.obs;
  RxString cityError = ''.obs;
  RxString countryError = ''.obs;
  RxString phoneError = ''.obs;
  RxString workExperienceError = ''.obs;

  // Character counts (observable for real-time UI updates)
  RxInt displayNameLength = 0.obs;
  RxInt cityLength = 0.obs;
  RxInt countryLength = 0.obs;
  RxInt phoneLength = 0.obs;
  RxInt workExperienceLength = 0.obs;

  // List of country codes
  final List<String> countryCodes = [
    // Asia
    '+91', // India
    '+92', // Pakistan
    '+94', // Sri Lanka
    '+971', // UAE
    '+966', // Saudi Arabia
    '+86', // China
    '+81', // Japan
    '+880', // Bangladesh
    '+977', // Nepal
    '+93', // Afghanistan
    '+975', // Bhutan
    '+960', // Maldives
    '+95', // Myanmar
    '+66', // Thailand
    '+84', // Vietnam
    '+63', // Philippines
    '+62', // Indonesia
    '+60', // Malaysia
    '+65', // Singapore
    '+82', // South Korea
    '+886', // Taiwan
    '+852', // Hong Kong
    '+98', // Iran
    '+964', // Iraq
    '+962', // Jordan
    '+965', // Kuwait
    '+961', // Lebanon
    '+968', // Oman
    '+974', // Qatar
    '+973', // Bahrain
    '+967', // Yemen
    '+90', // Turkey
    // North America
    '+1', // USA/Canada
    // Europe
    '+44', // UK
    '+33', // France
    '+49', // Germany
    '+39', // Italy
    '+34', // Spain
    // Oceania
    '+61', // Australia
    '+64', // New Zealand
    // Africa
    '+27', // South Africa
  ];

  // Image file
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString imagePreviewUrl = ''.obs;

  // Loading state
  RxBool isLoading = false.obs;
  RxBool isCompressingImage = false.obs; // For image compression loading
  RxBool isUploadingImage = false.obs; // For direct upload from profile screen

  // Track if any changes have been made
  RxBool hasChanges = false.obs;

  // Flag to track if initial data load is complete
  bool _isInitialLoadComplete = false;

  // Store original values to compare
  late String originalDisplayName;
  late String originalCity;
  late String originalCountry;
  late String originalPhone;
  late String originalCountryCode;
  late String originalWorkExperience;
  late String originalImageUrl;

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
    userIdController = TextEditingController();
    cityController = TextEditingController();
    countryController = TextEditingController();
    phoneController = TextEditingController();
    workExperienceController = TextEditingController();
  }

  Future<void> _loadCurrentUserData() async {
    final currentUser = _authService.getCurrentUserModel();
    if (currentUser != null) {
      displayNameController.text = currentUser.displayName ?? '';
      displayNameLength.value = displayNameController.text.length;
      imagePreviewUrl.value = currentUser.photoURL ?? '';

      // Load additional profile data from Firestore
      final userData = await _authService.getUserData(currentUser.uid);
      if (userData != null) {
        // Get userId from database
        userId.value = userData['userId'] ?? 'RB-00000';
        userIdController.text = userId.value;

        cityController.text = userData['city'] ?? '';
        cityLength.value = cityController.text.length;

        countryController.text = userData['country'] ?? '';
        countryLength.value = countryController.text.length;

        workExperienceController.text = userData['workExperience'] ?? '';
        workExperienceLength.value = workExperienceController.text.length;

        // Parse phone number with country code
        final phoneNumber = userData['phoneNumber'] ?? '';
        if (phoneNumber.isNotEmpty) {
          // Extract country code and phone number
          final match = RegExp(r'^(\+\d{1,3})\s*(.*)$').firstMatch(phoneNumber);
          if (match != null) {
            selectedCountryCode.value = match.group(1) ?? '+1';
            phoneController.text = match.group(2) ?? '';
            phoneLength.value = phoneController.text
                .replaceAll(RegExp(r'[^\d]'), '')
                .length;
          } else {
            phoneController.text = phoneNumber;
            phoneLength.value = phoneController.text
                .replaceAll(RegExp(r'[^\d]'), '')
                .length;
            selectedCountryCode.value = '+966';
          }
        }
      }

      // Store original values for comparison
      originalDisplayName = displayNameController.text;
      originalCity = cityController.text;
      originalCountry = countryController.text;
      originalPhone = phoneController.text;
      originalCountryCode = selectedCountryCode.value;
      originalWorkExperience = workExperienceController.text;
      originalImageUrl = imagePreviewUrl.value;

      // Reset hasChanges flag
      hasChanges.value = false;

      // Mark initial load as complete - now enable change detection
      _isInitialLoadComplete = true;
    }
  }

  // Compress image to max 30KB
  Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Start with quality 85 and reduce until file size is under 30KB
      int quality = 85;
      File? compressedFile;

      while (quality > 10) {
        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: quality,
          format: CompressFormat.jpeg,
        );

        if (result != null) {
          compressedFile = File(result.path);
          final fileSize = await compressedFile.length();

          // Check if file size is under 30KB (30 * 1024 bytes)
          if (fileSize <= 30 * 1024) {
            print('Image compressed successfully to ${fileSize / 1024} KB');
            return compressedFile;
          }
        }

        // Reduce quality for next iteration
        quality -= 10;
      }

      // If still too large, try with minimum quality
      final finalResult = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 10,
        format: CompressFormat.jpeg,
      );

      if (finalResult != null) {
        compressedFile = File(finalResult.path);
        final fileSize = await compressedFile.length();
        print('Image compressed to minimum quality: ${fileSize / 1024} KB');
        return compressedFile;
      }

      return null;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // Pick image from gallery
  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Pick image from gallery
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100, // Get original quality, we'll compress it ourselves
      );

      if (pickedFile == null) {
        // User cancelled the picker
        return;
      }

      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: redColor,
            toolbarWidgetColor: whiteColor,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) {
        return;
      }

      final File originalFile = File(croppedFile.path);
      final fileSize = await originalFile.length();

      // Max 5MB for original file
      if (fileSize > 5 * 1024 * 1024) {
        Get.snackbar("Error", "File too large! Max size is 5MB");
        return;
      }

      // Set loading state instead of showing dialog
      isCompressingImage.value = true;

      // Compress the image
      final compressedFile = await compressImage(originalFile);

      // Stop loading
      isCompressingImage.value = false;

      if (compressedFile != null) {
        selectedImage.value = compressedFile;
        imagePreviewUrl.value = compressedFile.path;
        _checkForChanges();

        Get.snackbar("Success", "Image uploaded successfully");
      } else {
        Get.snackbar(
          "Error",
          "Failed to compress image. Please try another image.",
        );
      }
    } catch (e) {
      print('Error picking image: $e');

      // Stop loading if error occurs
      isCompressingImage.value = false;

      Get.snackbar("Error", "Failed to pick image: ${e.toString()}");
    }
  }

  // Remove selected image
  void removeSelectedImage() {
    selectedImage.value = null;
    // Keep the original image URL if no new image is selected
    _loadCurrentUserData();
  }

  // Pick and upload profile image directly (for profile screen camera icon)
  Future<void> pickAndUploadProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Pick image from gallery
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile == null) {
        return;
      }

      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: redColor,
            toolbarWidgetColor: whiteColor,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) {
        return;
      }

      final File originalFile = File(croppedFile.path);
      final fileSize = await originalFile.length();

      // Max 5MB for original file
      if (fileSize > 5 * 1024 * 1024) {
        Get.snackbar("Error", "File too large! Max size is 5MB");
        return;
      }

      // Set loading state instead of showing dialog
      isUploadingImage.value = true;

      // Compress the image
      final compressedFile = await compressImage(originalFile);

      if (compressedFile == null) {
        isUploadingImage.value = false;
        Get.snackbar("Error", "Failed to compress image");
        return;
      }

      // Upload to Firebase
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        final newPhotoURL = await _authService.uploadProfileImage(
          compressedFile,
        );

        if (newPhotoURL != null) {
          // Update Firebase Auth photoURL
          await currentUser.updatePhotoURL(newPhotoURL);
          await currentUser.reload();

          // Update Firestore
          await _authService.updateUserProfileWithFields(
            uid: currentUser.uid,
            updateData: {
              'photoURL': newPhotoURL,
              'updatedAt': DateTime.now().toIso8601String(),
            },
          );

          // Refresh user data
          await refreshUserData();

          // Refresh AuthController
          final authController = Get.find<AuthController>();
          await authController.refreshCurrentUser();
          authController.update();

          // Stop loading
          isUploadingImage.value = false;

          Get.snackbar("Success", "Profile picture updated successfully");
        } else {
          isUploadingImage.value = false;
          Get.snackbar("Error", "Failed to upload image");
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
      isUploadingImage.value = false;

      Get.snackbar("Error", "Failed to upload image: ${e.toString()}");
    }
  }

  // Validation methods
  bool validateDisplayName(String value) {
    final trimmed = value.trim();
    displayNameLength.value = value.length; // Update character count
    _checkForChanges();

    if (trimmed.isEmpty) {
      displayNameError.value = "Full name is required";
      return false;
    }
    if (trimmed.length < 2) {
      displayNameError.value = "Full name must be at least 2 characters";
      return false;
    }
    if (trimmed.length > 25) {
      displayNameError.value = "Full name must not exceed 25 characters";
      return false;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
      displayNameError.value = "Only letters (a-z, A-Z) and spaces allowed";
      return false;
    }
    displayNameError.value = "";
    return true;
  }

  bool validateCity(String value) {
    final trimmed = value.trim();
    cityLength.value = value.length; // Update character count
    _checkForChanges();

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
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
      cityError.value = "Only letters (a-z, A-Z) and spaces allowed";
      return false;
    }
    cityError.value = "";
    return true;
  }

  bool validateCountry(String value) {
    final trimmed = value.trim();
    countryLength.value = value.length; // Update character count
    _checkForChanges();

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
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
      countryError.value = "Only letters (a-z, A-Z) and spaces allowed";
      return false;
    }
    countryError.value = "";
    return true;
  }

  bool validatePhone(String value) {
    final trimmed = value.trim();
    // Update character count (only digits)
    phoneLength.value = trimmed.replaceAll(RegExp(r'[^\d]'), '').length;
    _checkForChanges();

    if (trimmed.isEmpty) {
      phoneError.value = "Phone number is required";
      return false;
    }
    // Remove all non-digit characters for validation
    final digitsOnly = trimmed.replaceAll(RegExp(r'[^\d]'), '');

    // Dynamic validation based on country code
    final expectedLength = getExpectedPhoneLength(selectedCountryCode.value);

    if (digitsOnly.length < expectedLength.min) {
      phoneError.value =
          "Phone number must have at least ${expectedLength.min} digits";
      return false;
    }
    if (digitsOnly.length > expectedLength.max) {
      phoneError.value =
          "Phone number must not exceed ${expectedLength.max} digits";
      return false;
    }
    phoneError.value = "";
    return true;
  }

  // Helper to get expected phone length for country code
  ({int min, int max}) getExpectedPhoneLength(String code) {
    switch (code) {
      // Asia
      case '+91':
        return (min: 10, max: 10); // India
      case '+92':
        return (min: 10, max: 10); // Pakistan
      case '+94':
        return (min: 9, max: 9); // Sri Lanka
      case '+971':
        return (min: 9, max: 9); // UAE
      case '+966':
        return (min: 9, max: 9); // Saudi Arabia
      case '+86':
        return (min: 11, max: 11); // China
      case '+81':
        return (min: 10, max: 10); // Japan
      case '+880':
        return (min: 10, max: 10); // Bangladesh
      case '+977':
        return (min: 10, max: 10); // Nepal
      case '+93':
        return (min: 9, max: 9); // Afghanistan
      case '+975':
        return (min: 8, max: 8); // Bhutan
      case '+960':
        return (min: 7, max: 7); // Maldives
      case '+95':
        return (min: 9, max: 9); // Myanmar
      case '+66':
        return (min: 9, max: 9); // Thailand
      case '+84':
        return (min: 10, max: 10); // Vietnam
      case '+63':
        return (min: 10, max: 10); // Philippines
      case '+62':
        return (min: 11, max: 11); // Indonesia
      case '+60':
        return (min: 10, max: 10); // Malaysia
      case '+65':
        return (min: 8, max: 8); // Singapore
      case '+82':
        return (min: 10, max: 10); // South Korea
      case '+886':
        return (min: 9, max: 9); // Taiwan
      case '+852':
        return (min: 8, max: 8); // Hong Kong
      case '+98':
        return (min: 10, max: 10); // Iran
      case '+964':
        return (min: 10, max: 10); // Iraq
      case '+962':
        return (min: 9, max: 9); // Jordan
      case '+965':
        return (min: 8, max: 8); // Kuwait
      case '+961':
        return (min: 8, max: 8); // Lebanon
      case '+968':
        return (min: 8, max: 8); // Oman
      case '+974':
        return (min: 8, max: 8); // Qatar
      case '+973':
        return (min: 8, max: 8); // Bahrain
      case '+967':
        return (min: 9, max: 9); // Yemen
      case '+90':
        return (min: 10, max: 10); // Turkey
      // North America
      case '+1':
        return (min: 10, max: 10); // USA/Canada
      // Europe
      case '+44':
        return (min: 10, max: 10); // UK
      case '+33':
        return (min: 9, max: 9); // France
      case '+49':
        return (min: 11, max: 11); // Germany
      case '+39':
        return (min: 10, max: 10); // Italy
      case '+34':
        return (min: 9, max: 9); // Spain
      // Oceania
      case '+61':
        return (min: 9, max: 9); // Australia
      case '+64':
        return (min: 9, max: 9); // New Zealand
      // Africa
      case '+27':
        return (min: 9, max: 9); // South Africa
      default:
        return (min: 7, max: 15); // Default
    }
  }

  bool validateWorkExperience(String value) {
    final trimmed = value.trim();
    workExperienceLength.value = value.length; // Update character count
    _checkForChanges();

    // Optional field - only validate if not empty
    if (trimmed.isEmpty) {
      workExperienceError.value = "";
      return true; // Valid if empty
    }

    if (trimmed.length < 10) {
      workExperienceError.value =
          "Work experience must be at least 10 characters";
      return false;
    }
    if (trimmed.length > 50) {
      workExperienceError.value =
          "Work experience must not exceed 50 characters";
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

  // Check if any changes have been made
  void _checkForChanges() {
    // Only check for changes after initial data load is complete
    if (!_isInitialLoadComplete) {
      return;
    }

    final hasDisplayNameChanged =
        displayNameController.text != originalDisplayName;
    final hasCityChanged = cityController.text != originalCity;
    final hasCountryChanged = countryController.text != originalCountry;
    final hasPhoneChanged = phoneController.text != originalPhone;
    final hasCountryCodeChanged =
        selectedCountryCode.value != originalCountryCode;
    final hasWorkExperienceChanged =
        workExperienceController.text != originalWorkExperience;
    final hasImageChanged = imagePreviewUrl.value != originalImageUrl;

    hasChanges.value =
        hasDisplayNameChanged ||
        hasCityChanged ||
        hasCountryChanged ||
        hasPhoneChanged ||
        hasCountryCodeChanged ||
        hasWorkExperienceChanged ||
        hasImageChanged;
  }

  // Update profile
  Future<bool> updateProfile() async {
    try {
      isLoading.value = true;
      clearErrors();

      // Validate all fields
      if (!validateAllFields()) {
        isLoading.value = false;
        Get.snackbar("Error", "Please fill all the required fields");
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

          // Update Firebase Auth photoURL
          if (newPhotoURL != null) {
            await currentUser.updatePhotoURL(newPhotoURL);
            await currentUser.reload();
          }
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
        authController.update(); // Force rebuild GetBuilder widgets

        isLoading.value = false;
        Get.back();

        Get.snackbar("Success", "Profile updated successfully");

        // Navigate back after successful update
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
    userIdController.dispose();
    cityController.dispose();
    countryController.dispose();
    phoneController.dispose();
    workExperienceController.dispose();
    super.onClose();
  }
}
