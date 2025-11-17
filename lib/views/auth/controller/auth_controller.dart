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
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
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
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
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
    } catch (e) {
      errorMessage.value = 'Failed to sign out: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
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
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
