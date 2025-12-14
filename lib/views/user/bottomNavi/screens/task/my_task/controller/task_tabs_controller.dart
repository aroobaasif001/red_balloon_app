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
    if (!tabController.indexIsChanging) {
      tabController.animateTo(index);
    }
  }

  void resetTab() {
    try {
      if (!tabController.indexIsChanging && tabController.index != 0) {
        tabController.animateTo(0);
      }
      selectedTab.value = 0;
    } catch (e) {
      // Controller might be disposed, ignore
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
