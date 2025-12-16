import 'package:get/get.dart';
import 'package:red_balloon_app/model/auth_model.dart';
import 'package:red_balloon_app/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

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

  // Check if user is already logged in
  void _checkCurrentUser() {
    final user = _authService.getCurrentUserModel();
    if (user != null) {
      currentUser.value = user;
      fetchUserProfileData(); // Fetch additional profile data
    }
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
        currentUser.value = user;
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
        currentUser.value = user;
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
