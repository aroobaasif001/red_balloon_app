import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/services/banner_service.dart';
import 'package:red_balloon_app/model/banner_model.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  final WalletService _walletService = WalletService();
  final BannerService _bannerService = BannerService();

  RxInt selectedTabIndex = 0.obs;
  RxDouble walletBalance = 0.0.obs;
  RxList<BannerModel> activeBanners = <BannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 1, vsync: this);
    tabController.addListener(_handleTabChange);
    
    // Check and request notification permissions
    _checkNotificationPermission();

    // Listen to wallet balance
    _walletService.getWalletBalance().listen((balance) {
      walletBalance.value = balance;
    });

    // Listen to active banners
    activeBanners.bindStream(
      _bannerService.streamBanners().map(
            (list) => list.where((banner) => banner.isActive).toList(),
          ),
    );
  }
  
  Future<void> _checkNotificationPermission() async {
    try {
      // Get current user ID from Firebase Auth
      final userId = await _getCurrentUserId();
      
      if (userId != null) {
        // Initialize notification service (handles permissions, token, and listeners)
        await NotificationService.instance.initializeForUser(userId);
      } else {
        print('⚠️ Cannot initialize notifications: userId is null');
      }
    } catch (e) {
      print('⚠️ Error initializing notification service: $e');
    }
  }
  
  Future<String?> _getCurrentUserId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user?.uid;
    } catch (e) {
      print('⚠️ Error getting user ID: $e');
      return null;
    }
  }

  void _handleTabChange() {
    selectedTabIndex.value = tabController.index;
  }

  void switchTab(int index) {
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
