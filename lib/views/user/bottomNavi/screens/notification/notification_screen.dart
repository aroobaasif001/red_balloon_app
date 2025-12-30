import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/tabs/all_notifications_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/tabs/offer_notifications_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/tabs/validation_hub_notifications_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/widgets/custom_notification_tabs.dart';

import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    // Mark all as read when user enters this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markAllAsRead();
    });

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: CustomText(
          "Notifications",
          fontSize: 24,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
        actions: [
          TextButton(
            onPressed: () {
              DialogHelpers.showClearNotificationsDialog(
                context: context,
                onConfirm: () => controller.clearAll(),
              );
            },
            child: const CustomText(
              'Clear All',
              color: redColor,
              fontWeight: FontVariant.bold,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ------------------- CUSTOM TABS -------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(
              () => CustomNotificationTabs(
                selectedIndex: controller.selectedTabIndex.value,
                onAllTap: () => controller.switchTab(0),
                onOffersTap: () => controller.switchTab(1),
                onValidationTap: () => controller.switchTab(2),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const [
                AllNotificationsTab(),
                OfferNotificationsTab(),
                ValidationHubNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
