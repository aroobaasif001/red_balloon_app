import 'package:get/get.dart';

class BannerManagementController extends GetxController {
  // Example banner model: you can replace with real API models later
  final banners = <BannerItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialBanners();
  }

  void _loadInitialBanners() {
    banners.assignAll([
      BannerItem(
        id: 1,
        title: 'Summer Festival 2024',
        description: 'Join us for the biggest celebration of the year',
        imagePath: 'assets/banners/banner_1.png',
        isActive: true,
      ),
      BannerItem(
        id: 2,
        title: 'Flash Sale - 50% Off',
        description: 'Limited time offer on selected items',
        imagePath: 'assets/banners/banner_2.png',
        isActive: true,
      ),
      BannerItem(
        id: 3,
        title: 'New Product Launch',
        description: 'Discover our latest collection',
        imagePath: 'assets/banners/banner_3.png',
        isActive: false,
      ),
      BannerItem(
        id: 4,
        title: 'Holiday Season Special',
        description: 'Celebrate with exclusive deals',
        imagePath: 'assets/banners/banner_4.png',
        isActive: false,
      ),
      BannerItem(
        id: 5,
        title: 'VIP Membership',
        description: 'Unlock exclusive rewards and benefits',
        imagePath: 'assets/banners/banner_5.png',
        isActive: true,
      ),
    ]);
  }

  void toggleBannerActive(int id, bool value) {
    final index = banners.indexWhere((b) => b.id == id);
    if (index == -1) return;
    banners[index] = banners[index].copyWith(isActive: value);
  }

  void deleteBanner(int id) {
    banners.removeWhere((b) => b.id == id);
  }
}

class BannerItem {
  final int id;
  final String title;
  final String description;
  final String imagePath;
  final bool isActive;

  BannerItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isActive,
  });

  BannerItem copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
    bool? isActive,
  }) {
    return BannerItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
    );
  }
}
