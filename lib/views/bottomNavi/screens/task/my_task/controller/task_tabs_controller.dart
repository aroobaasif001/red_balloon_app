import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskTabsController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Reactive index for your custom tabs
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // 4 tabs
    tabController = TabController(length: 4, vsync: this);

    // Sync Flutter TabController → GetX variable
    tabController.addListener(() {
      if (tabController.indexIsChanging == false) {
        selectedTab.value = tabController.index;
      }
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
