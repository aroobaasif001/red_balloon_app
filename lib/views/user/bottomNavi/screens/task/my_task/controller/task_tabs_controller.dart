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
    tabController = TabController(length: 3, vsync: this);
    
    // 🔥 Remove old listener if any and add new one
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (selectedTab.value != tabController.index) {
      selectedTab.value = tabController.index;
      update(); // 🔥 Notify GetBuilder
    }
  }

  // Sync Custom Tabs → Flutter TabController
  void changeTab(int index) {
    selectedTab.value = index;
    try {
      if (!tabController.indexIsChanging && tabController.index != index) {
        tabController.animateTo(index);
      }
      update(); // 🔥 Notify GetBuilder
    } catch (e) {
      print('⚠️ TabController issue: $e');
    }
  }

  void resetTab({int toIndex = 0}) {
    try {
      selectedTab.value = toIndex;
      if (tabController.index != toIndex) {
        tabController.animateTo(toIndex);
      }
      update(); // 🔥 Notify GetBuilder
    } catch (e) {
      // Controller might be disposed
    }
  }

  @override
  void onClose() {
    // 🔥 Remove listener first to avoid async calls after dispose
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.onClose();
  }
}
