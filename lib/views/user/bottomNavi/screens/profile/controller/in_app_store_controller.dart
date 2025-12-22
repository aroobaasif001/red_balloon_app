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
  // Observable list of selected badge titles
  RxList<String> selectedBadges = <String>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _bindOwnedBadges();
    _bindSelectedBadges();
  }

  void _bindOwnedBadges() {
    // Real-time listener for owned badges from Firestore
    ownedBadges.bindStream(_walletService.getOwnedBadgesStream());
  }

  void _bindSelectedBadges() {
    // Real-time listener for selected badges from Firestore
    selectedBadges.bindStream(_walletService.getSelectedBadgesStream());
  }

  /// Toggle selection logic
  Future<void> toggleBadgeSelection(String title) async {
    final currentlySelected = List<String>.from(selectedBadges);
    
    if (currentlySelected.contains(title)) {
      currentlySelected.remove(title);
    } else {
      if (currentlySelected.length >= 2) {
        Get.snackbar('Limit Reached', 'You can only select up to 2 badges.');
        return;
      }
      currentlySelected.add(title);
    }

    final result = await _walletService.toggleBadgeSelection(currentlySelected);
    if (!result['success']) {
      Get.snackbar('Error', result['message']);
    }
  }

  bool isBadgeSelected(String title) {
    return selectedBadges.contains(title);
  }

  /// Returns selected badges data
  List<Map<String, dynamic>> get selectedBadgesData {
    return masterBadgeList
        .where((b) => selectedBadges.contains(b['title']))
        .toList();
  }

  /// Returns 1 most expensive badge owned by the user
  Map<String, dynamic>? get mostExpensiveBadge {
    if (ownedBadges.isEmpty) return null;

    // 1. Get the titles of owned badges
    final ownedTitles = ownedBadges.map((b) => b['title']).toList();

    // 2. Filter master list for owned ones
    final ownedFromMaster =
        masterBadgeList.where((b) => ownedTitles.contains(b['title'])).toList();

    if (ownedFromMaster.isEmpty) return null;

    // 3. Sort by price (descending)
    ownedFromMaster
        .sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));

    // 4. Return top 1
    return ownedFromMaster.first;
  }

  /// Static helper to find most expensive badge from a list of owned badges
  static Map<String, dynamic>? getMostExpensiveFromList(
      List<Map<String, dynamic>> owned) {
    if (owned.isEmpty) return null;

    final ownedTitles = owned.map((b) => b['title']).toList();
    final ownedFromMaster =
        masterBadgeList.where((b) => ownedTitles.contains(b['title'])).toList();

    if (ownedFromMaster.isEmpty) return null;

    ownedFromMaster
        .sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));

    return ownedFromMaster.first;
  }

  /// Returns 2 cheapest badges owned by the user (as fallback or reference)
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
