import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

class InAppStoreController extends GetxController {
  final WalletService _walletService = WalletService();

  // Master List of Badges (Source of Truth for Icons/Prices)
  static final List<Map<String, dynamic>> masterBadgeList = [
    {"title": "Elite Tasker", "price": 50, "image": 'assets/icons/image 51.png'},
    {"title": "Pro Performer", "price": 100, "image": 'assets/icons/image 49.png'},
    {"title": "Master Helper", "price": 200, "image": 'assets/icons/image 50.png'},
    {"title": "Task Expert", "price": 250, "image": 'assets/icons/image 48.png'},
    {"title": "Reliable Achiever", "price": 300, "image": 'assets/icons/image 52.png'},
    {"title": "Task Veteran", "price": 350, "image": 'assets/icons/image 53.png'},
    {"title": "Seasoned Helper", "price": 400, "image": 'assets/icons/leaf.png'},
    {"title": "Highly Experienced", "price": 450, "image": 'assets/icons/flag.png'},
    {"title": "Quality Assured", "price": 500, "image": 'assets/icons/micro.png'},
    {"title": "Safety Certified", "price": 550, "image": 'assets/icons/safety.png'},
  ];

  // Observable list of owned badge data
  RxList<Map<String, dynamic>> ownedBadges = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _bindOwnedBadges();
  }

  void _bindOwnedBadges() {
    // Real-time listener for owned badges from Firestore
    ownedBadges.bindStream(_walletService.getOwnedBadgesStream());
  }

  /// Returns 2 cheapest badges owned by the user
  List<Map<String, dynamic>> get cheapestTwoBadges {
    // 1. Get the titles of owned badges
    final ownedTitles = ownedBadges.map((b) => b['title']).toList();
    
    // 2. Filter master list for owned ones
    final ownedFromMaster = masterBadgeList.where((b) => ownedTitles.contains(b['title'])).toList();
    
    // 3. Sort by price (ascending)
    ownedFromMaster.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
    
    // 4. Return top 2
    return ownedFromMaster.take(2).toList();
  }

  bool isBadgeOwned(String title) {
    return ownedBadges.any((b) => b['title'] == title);
  }

  Future<void> purchaseBadge(BuildContext context, String title, double price) async {
    // Show confirmation dialog before purchasing
    DialogHelpers.showBuyBadgeDialog(
      context, 
      title: title, 
      isLoading: isLoading,
      onConfirm: () async {
      try {
        isLoading.value = true;
        
        final result = await _walletService.purchaseBadge(title, price);
        
        if (result['success']) {
          Get.back(); // Close dialog first
          Get.snackbar('Success', result['message']);
        } else {
          Get.back(); // Close dialog first
          Get.snackbar('Error', result['message']);
        }
      } finally {
        isLoading.value = false;
      }
    });
  }
}
