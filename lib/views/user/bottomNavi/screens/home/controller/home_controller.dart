import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/services/notification_services.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 1, vsync: this);
    tabController.addListener(_handleTabChange);
    
    // Check and request notification permissions
    _checkNotificationPermission();
  }
  
  Future<void> _checkNotificationPermission() async {
    try {
      // Get current user ID from Firebase Auth
      final userId = await _getCurrentUserId();
      
      if (userId != null) {
        // Initialize notification service (handles permissions, token, and listeners)
        await NotificationService.instance.initializeForUser(userId);
        print('✅ Notification service initialized for user: $userId');
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
