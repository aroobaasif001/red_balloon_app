import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/auth_model.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:audioplayers/audioplayers.dart'; // 🔥 Added
import 'package:red_balloon_app/views/auth/view/onboarding/onboarding_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  StreamSubscription? _suspensionSubscription;
  final AudioPlayer _audioPlayer = AudioPlayer(); // 🔥 Added

  var consentChecked = false.obs;
  var consentError = ''.obs;
  var isLoading = false.obs;
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
    _audioPlayer.dispose(); // 🔥 Added
    super.onClose();
  }

  // Check if user is already logged in
  void _checkCurrentUser() {
    final user = _authService.getCurrentUserModel();
    if (user != null) {
      currentUser.value = user;
      _startSuspensionListener(user.uid);
      fetchUserProfileData(); // Fetch additional profile data
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
    
    // 🔥 Play Emergency Sound (Loud & Looping)
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // Using a siren sound for emergency effect
      await _audioPlayer.play(UrlSource('https://www.soundjay.com/misc/sounds/siren-1.mp3')); 
      await _audioPlayer.setVolume(1.0); // Maximum volume
      print('📢 Emergency sound started!');
    } catch (e) {
      print('❌ Error playing suspension sound: $e');
    }

    // Explicitly sign out
    signOut();
    
    // Show suspension popup
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
              _audioPlayer.stop(); // 🔥 Stop sound when user acknowledges
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
        await fetchUserProfileData(); // Fetch additional profile data
        update(); // Notify GetBuilder listeners
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
          // Parse phone number
          final phoneNumber = userData['phoneNumber'] ?? '';
          if (phoneNumber.isNotEmpty) {
            userPhone.value = phoneNumber;
          } else {
            userPhone.value = '';
          }

          // Get city and country
          userCity.value = userData['city'] ?? '';
          userCountry.value = userData['country'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching user profile data: $e');
    }
  }

  // Sign in with Google
  Future<AuthModel?> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.signInWithGoogle();

      if (user != null) {
        // Check for suspension immediately after sign-in
        final userData = await _authService.getUserData(user.uid);
        if (userData != null && userData['willLogin'] == false) {
          await _authService.signOut();
          _handleSuspension();
          return null;
        }

        currentUser.value = user;
        _startSuspensionListener(user.uid);
        return user;
      }

      return null;
    } catch (e) {
      errorMessage.value = 'Failed to sign in with Google: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Apple
  Future<AuthModel?> signInWithApple() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.signInWithApple();

      if (user != null) {
        // Check for suspension immediately after sign-in
        final userData = await _authService.getUserData(user.uid);
        if (userData != null && userData['willLogin'] == false) {
          await _authService.signOut();
          _handleSuspension();
          return null;
        }

        currentUser.value = user;
        _startSuspensionListener(user.uid);
        return user;
      }

      return null;
    } catch (e) {
      errorMessage.value = 'Failed to sign in with Apple: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      _suspensionSubscription?.cancel();
      await _authService.signOut();
      currentUser.value = null;
      userPhone.value = '';
      userCity.value = '';
      userCountry.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to sign out: ${e.toString()}';
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
      errorMessage.value = 'Failed to delete account: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
