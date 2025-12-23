import 'package:get/get.dart';
import 'package:red_balloon_app/model/banner_model.dart';
import 'package:red_balloon_app/services/banner_service.dart';

class BannerManagementController extends GetxController {
  final BannerService _bannerService = BannerService();
  
  final banners = <BannerModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    banners.bindStream(_bannerService.streamBanners());
  }

  Future<void> reorderBanners(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final BannerModel item = banners.removeAt(oldIndex);
    banners.insert(newIndex, item);
    
    // Save new order to Firestore
    await _bannerService.updateBannersOrder(banners);
  }

  Future<void> toggleBannerActive(String? id, bool value) async {
    if (id == null) return;
    try {
      await _bannerService.toggleBannerStatus(id, value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update banner status');
    }
  }

  Future<void> deleteBanner(String? id) async {
    if (id == null) return;
    try {
      await _bannerService.deleteBanner(id);
      Get.snackbar('Success', 'Banner deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete banner');
    }
  }
}
