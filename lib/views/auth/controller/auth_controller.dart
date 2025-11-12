import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/views/auth/view/verify/email_verify_screen.dart';

class AuthController extends GetxController {
  // Login Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Signup Controllers
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPhoneController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();

  // Forgot Password Controllers
  final forgotPasswordEmailController = TextEditingController();

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  // Loading state
  var isLoading = false.obs;

  // Error messages
  var loginEmailError = ''.obs;
  var loginPasswordError = ''.obs;
  var signupNameError = ''.obs;
  var signupEmailError = ''.obs;
  var signupPhoneError = ''.obs;
  var signupPasswordError = ''.obs;
  var signupConfirmPasswordError = ''.obs;
  var forgotPasswordEmailError = ''.obs;
  
  // Consent values
  var loginConsentChecked = false.obs;
  var signupConsentChecked = false.obs;
  var loginConsentError = ''.obs;
  var signupConsentError = ''.obs;

  @override
  void onClose() {
    // Don't dispose controllers here to avoid disposal errors
    // They will be automatically disposed by GetX
    super.onClose();
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Check if it's email or phone number
    if (value.contains('@')) {
      // Email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    } else {
      // Phone number validation
      final phoneRegex = RegExp(r'^[0-9]{10,15}$');
      if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
        return 'Please enter a valid phone number';
      }
    }

    return null;
  }

  // Email validation for forgot password (email only)
  String? validateForgotPasswordEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Email validation only
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Name validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    return null;
  }

  // Phone validation (for signup specific)
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Login field validation only (without consent check)
  bool validateLoginFields() {
    clearLoginErrors();

    // Validate email/phone
    final emailError = validateEmail(loginEmailController.text);
    if (emailError != null) {
      loginEmailError.value = emailError;
    }

    // Validate password
    final passwordError = validatePassword(loginPasswordController.text);
    if (passwordError != null) {
      loginPasswordError.value = passwordError;
    }

    return loginEmailError.isEmpty && loginPasswordError.isEmpty;
  }
  
  // Complete login validation including consent
  bool validateLogin() {
    // First validate fields
    final fieldsValid = validateLoginFields();
    if (!fieldsValid) {
      return false;
    }
    
    // Then validate consent
    if (!loginConsentChecked.value) {
      loginConsentError.value = 'You must agree to the Terms of Service and Privacy Policy';
      return false;
    }

    return true;
  }

  // Signup fields validation only (without consent check)
  bool validateSignupFields() {
    clearSignupErrors();

    // Validate name
    final nameError = validateName(signupNameController.text);
    if (nameError != null) {
      signupNameError.value = nameError;
    }

    // Validate email
    final emailError = validateEmail(signupEmailController.text);
    if (emailError != null) {
      signupEmailError.value = emailError;
    }

    // Validate phone
    final phoneError = validatePhone(signupPhoneController.text);
    if (phoneError != null) {
      signupPhoneError.value = phoneError;
    }

    // Validate password
    final passwordError = validatePassword(signupPasswordController.text);
    if (passwordError != null) {
      signupPasswordError.value = passwordError;
    }

    // Validate confirm password
    final confirmPasswordError = validateConfirmPassword(
      signupConfirmPasswordController.text,
      signupPasswordController.text,
    );
    if (confirmPasswordError != null) {
      signupConfirmPasswordError.value = confirmPasswordError;
    }

    return signupNameError.isEmpty &&
        signupEmailError.isEmpty &&
        signupPhoneError.isEmpty &&
        signupPasswordError.isEmpty &&
        signupConfirmPasswordError.isEmpty;
  }
  
  // Complete signup validation including consent
  bool validateSignup() {
    // First validate fields
    final fieldsValid = validateSignupFields();
    if (!fieldsValid) {
      return false;
    }
    
    // Then validate consent
    if (!signupConsentChecked.value) {
      signupConsentError.value = 'You must agree to the Terms of Service and Privacy Policy';
      return false;
    }

    return true;
  }

  // Clear error messages
  void clearLoginErrors() {
    loginEmailError.value = '';
    loginPasswordError.value = '';
    loginConsentError.value = '';
  }

  void clearSignupErrors() {
    signupNameError.value = '';
    signupEmailError.value = '';
    signupPhoneError.value = '';
    signupPasswordError.value = '';
    signupConfirmPasswordError.value = '';
    signupConsentError.value = '';
  }

  void clearForgotPasswordErrors() {
    forgotPasswordEmailError.value = '';
  }

  // Forgot password validation
  bool validateForgotPassword() {
    clearForgotPasswordErrors();

    // Validate email
    final emailError = validateForgotPasswordEmail(forgotPasswordEmailController.text);
    if (emailError != null) {
      forgotPasswordEmailError.value = emailError;
    }

    return forgotPasswordEmailError.isEmpty;
  }

  // Login method
  Future<void> login() async {
    // Validation is done in the button handler
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual login logic
      DialogHelpers.showSuccessSnackBar(title: 'Success', message: 'Login successful');

      // Clear form
      loginEmailController.clear();
      loginPasswordController.clear();
    } catch (e) {
      DialogHelpers.showErrorSnackBar(title: 'Error', message: 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Signup method
  Future<void> signup() async {
    // Validation is done in the button handler
    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual signup logic
      DialogHelpers.showSuccessSnackBar(title: 'Success', message: 'Account created successfully');

      // Clear form
      signupNameController.clear();
      signupEmailController.clear();
      signupPhoneController.clear();
      signupPasswordController.clear();
      signupConfirmPasswordController.clear();
    } catch (e) {
      DialogHelpers.showErrorSnackBar(title: 'Error', message: 'Signup failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot password method
  Future<void> forgotPassword() async {
    if (!validateForgotPassword()) {
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual forgot password logic
      DialogHelpers.showSuccessSnackBar(title: 'Success', message: 'Password reset email sent');

      // Navigate to email verification screen with email
      Get.to(() => EmailVerifyScreen(isShowBackBtn: true, emailController: forgotPasswordEmailController));

    } catch (e) {
      DialogHelpers.showErrorSnackBar(title: 'Error', message: 'Failed to send reset email: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
