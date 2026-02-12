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
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    // Only update if not disposed
    selectedTab.value = tabController.index;
  }

  // Sync Custom Tabs → Flutter TabController
  void changeTab(int index) {
    selectedTab.value = index;
    // Safe check: If controller is disposed, animateTo will fail
    try {
      if (!tabController.indexIsChanging) {
        tabController.animateTo(index);
      }
    } catch (e) {
      print('⚠️ TabController already disposed: $e');
    }
  }

  void resetTab({int toIndex = 0}) {
    try {
      if (!tabController.indexIsChanging && tabController.index != toIndex) {
        tabController.animateTo(toIndex);
      }
      selectedTab.value = toIndex;
    } catch (e) {
      // Controller might be disposed, ignore
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
