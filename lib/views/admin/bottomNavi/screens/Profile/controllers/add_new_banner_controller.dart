import 'package:get/get.dart';

class AddNewBannerController extends GetxController {
  // Form fields
  final bannerTitle = ''.obs;
  final subtitle = ''.obs;
  final ctaText = ''.obs;

  // Banner active/inactive status
  final isActive = true.obs;

  // Placeholder for selected image path or file reference
  final bannerImagePath = ''.obs;

  void setBannerTitle(String value) => bannerTitle.value = value;

  void setSubtitle(String value) => subtitle.value = value;

  void setCtaText(String value) => ctaText.value = value;

  void toggleActive(bool value) => isActive.value = value;

  void setBannerImagePath(String path) => bannerImagePath.value = path;

  /// Call this when user taps "Save Banner". You can later connect this
  /// to an API or to BannerManagementController to actually add the banner.
  Future<void> saveBanner() async {
    // TODO: implement integration with backend or banner list
  }
}
