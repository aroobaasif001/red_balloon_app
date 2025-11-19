import 'package:get/get.dart';

class TermsPolicyController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final isAccepted = false.obs;
  final scrollOffset = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controller
  }

  @override
  void onReady() {
    super.onReady();
    // Called when widget is rendered
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up resources
  }

  // Accept terms and policy
  void acceptTermsAndPolicy() {
    isAccepted.value = true;
    // Add any additional logic here
  }

  // Decline terms and policy
  void declineTermsAndPolicy() {
    isAccepted.value = false;
    Get.back();
  }

  // Update scroll offset
  void updateScrollOffset(double offset) {
    scrollOffset.value = offset;
  }

  // Check if user has scrolled to bottom
  bool hasScrolledToBottom(double maxScroll) {
    return scrollOffset.value >= maxScroll * 0.9; // 90% of max scroll
  }
}
