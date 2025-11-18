import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  RxInt selectedTabIndex = 0.obs; // 0 = All, 1 = Offers, 2 = Validation Hub

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabChange);
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
