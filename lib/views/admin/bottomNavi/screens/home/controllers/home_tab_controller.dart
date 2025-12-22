import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/services/notification_services.dart';

class HomeTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Reactive index for your custom tabs
  RxInt selectedTab = 0.obs;

  // Metrics
  RxInt activeTasksCount = 0.obs;
  RxInt disputesCount = 0.obs;

  StreamSubscription? _metricsSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();

    // 4 tabs
    tabController = TabController(length: 3, vsync: this);

    // Sync Flutter TabController → GetX variable
    tabController.addListener(() {
      if (tabController.indexIsChanging == false) {
        selectedTab.value = tabController.index;
      }
    });
    
    _startListeningToMetrics();
    
    // Check and request notification permissions
    _checkNotificationPermission();
  }
  
  Future<void> _checkNotificationPermission() async {
    try {
      // Get current user ID from Firebase Auth
      final userId = FirebaseAuth.instance.currentUser?.uid;
      
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

  void _startListeningToMetrics() {
    _metricsSubscription = _firestore.collection('tasks').snapshots().listen((snapshot) {
      int active = 0;
      int disputed = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String?;
        
        if (status != null) {
          if (status == 'in progress' || status == 'active') {
            active++;
          } else if (status == 'Disputed' || status == 'disputed') {
            disputed++;
          }
        }
      }

      activeTasksCount.value = active;
      disputesCount.value = disputed;
    });
  }

  // Sync Custom Tabs → Flutter TabController
  void changeTab(int index) {
    selectedTab.value = index;
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    _metricsSubscription?.cancel();
    tabController.dispose();
    super.onClose();
  }
}
