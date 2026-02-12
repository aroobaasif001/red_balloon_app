import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/auth_model.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/views/auth/view/onboarding/onboarding_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService.instance;
  StreamSubscription? _suspensionSubscription;
  final AudioPlayer _audioPlayer = AudioPlayer();

  var consentChecked = false.obs;
  var consentError = ''.obs;
  var isLoading = false.obs;
  var isEmailLoading = false.obs;
  var isGoogleLoading = false.obs;
  var isAppleLoading = false.obs;
  var errorMessage = ''.obs;
  var currentUser = Rxn<AuthModel>();

  // User profile data
  var userPhone = ''.obs;
  var userCity = ''.obs;
  var userCountry = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  @override
  void onClose() {
    _suspensionSubscription?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  void _checkCurrentUser() {
    final user = _authService.getCurrentUserModel();
    if (user != null) {
      currentUser.value = user;
      _startSuspensionListener(user.uid);
      fetchUserProfileData(); // Fetch additional profile data
      _notificationService.saveUserDeviceToken(user.uid); // 🔥 Save device token on app start
    }
  }

  // Real-time suspension listener
  void _startSuspensionListener(String uid) {
    _suspensionSubscription?.cancel();
    _suspensionSubscription = _authService.streamUserData(uid).listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['willLogin'] == false) {
          _handleSuspension();
        }
      }
    });
  }

  void _handleSuspension() async {
    _suspensionSubscription?.cancel();
    
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(UrlSource('https://www.soundjay.com/misc/sounds/siren-1.mp3')); 
      await _audioPlayer.setVolume(1.0);
      print('📢 Emergency sound started!');
    } catch (e) {
      print('❌ Error playing suspension sound: $e');
    }

    signOut();
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Account Suspended", style: TextStyle(color: redColor, fontWeight: FontWeight.bold)),
        content: const Text(
          "Your account has been suspended by the administration and you are no longer allowed to access the platform. For any complaints or further information, please contact admin.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _audioPlayer.stop();
              Get.back();
              Get.offAll(() => const OnboardingScreen());
            },
            child: const Text("OK", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Refresh current user data from Firebase
  Future<void> refreshCurrentUser() async {
    try {
      final user = _authService.getCurrentUserModel();
      if (user != null) {
        currentUser.value = user;
        await fetchUserProfileData();
        update();
      }
    } catch (e) {
      print('Error refreshing user: $e');
    }
  }

  // Fetch user profile data from Firestore
  Future<void> fetchUserProfileData() async {
    try {
      final user = _authService.getCurrentUserModel();
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null) {
          userPhone.value = userData['phoneNumber'] ?? '';
          userCity.value = userData['city'] ?? '';
          userCountry.value = userData['country'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching user profile data: $e');
    }
  }

  // Sign in with Email and Password
  Future<AuthModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      isEmailLoading.value = true;
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.signInWithEmailAndPassword(email, password);

      if (user != null) {
        currentUser.value = user;
        _notificationService.saveUserDeviceToken(user.uid); // 🔥 Save device token
        return user;
      }
      return null;
    } catch (e) {
      errorMessage.value = _getFriendlyErrorMessage(e);
      Get.snackbar('Error', errorMessage.value);
      return null;
    } finally {
      isEmailLoading.value = false;
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<AuthModel?> signInWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.signInWithGoogle();

      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null && userData['willLogin'] == false) {
          await _authService.signOut();
          _handleSuspension();
          return null;
        }

        currentUser.value = user;
        _startSuspensionListener(user.uid);
        _notificationService.saveUserDeviceToken(user.uid); // 🔥 Save device token
        return user;
      }

      return null;
    } catch (e) {
      errorMessage.value = _getFriendlyErrorMessage(e);
      Get.snackbar('Error', errorMessage.value);
      return null;
    } finally {
      isGoogleLoading.value = false;
      isLoading.value = false;
    }
  }

  // Sign in with Apple
  Future<AuthModel?> signInWithApple() async {
    try {
      isAppleLoading.value = true;
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.signInWithApple();

      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null && userData['willLogin'] == false) {
          await _authService.signOut();
          _handleSuspension();
          return null;
        }

        currentUser.value = user;
        _startSuspensionListener(user.uid);
        _notificationService.saveUserDeviceToken(user.uid); // 🔥 Save device token
        return user;
      }

      return null;
    } catch (e) {
      errorMessage.value = _getFriendlyErrorMessage(e);
      Get.snackbar('Error', errorMessage.value);
      return null;
    } finally {
      isAppleLoading.value = false;
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      _suspensionSubscription?.cancel();
      
      if (currentUser.value != null) {
        await _notificationService.deleteUserDeviceToken(currentUser.value!.uid);
      }
      
      await _authService.signOut();
      currentUser.value = null;
      userPhone.value = '';
      userCity.value = '';
      userCountry.value = '';
    } catch (e) {
      errorMessage.value = _getFriendlyErrorMessage(e);
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await _authService.deleteAccount();
      currentUser.value = null;
    } catch (e) {
      errorMessage.value = _getFriendlyErrorMessage(e);
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  String _getFriendlyErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential': return 'Incorrect email or password.';
        case 'user-not-found': return 'No user found with this email.';
        case 'wrong-password': return 'Incorrect password.';
        case 'invalid-email': return 'Enter a valid email address.';
        case 'user-disabled': return 'Account disabled. Contact support.';
        case 'too-many-requests': return 'Too many attempts. Try later.';
        case 'network-request-failed': return 'Network error.';
        default: return e.message ?? 'An unexpected error occurred.';
      }
    }
    return e.toString().contains('canceled-by-user') ? 'Sign-in canceled.' : 'An unexpected error occurred.';
  }
}
