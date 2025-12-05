import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Reactive index for your custom tabs
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // 3 tabs
    tabController = TabController(length: 3, vsync: this);

    // Sync Flutter TabController → GetX variable (immediate update on swipe)
    tabController.addListener(() {
      // Update on every animation frame for instant feedback
      selectedTab.value = tabController.index;
    });
  }

  // Sync Custom Tabs → Flutter TabController
  void changeTab(int index) {
    selectedTab.value = index;
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
