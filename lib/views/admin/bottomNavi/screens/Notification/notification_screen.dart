import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/Notification/controller/admin_notification_controller.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/Notification/tabs/admin_all_notifications_tab.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/Notification/tabs/admin_offer_notifications_tab.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/Notification/tabs/admin_validation_hub_notifications_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/widgets/custom_notification_tabs.dart';

class AdminNotificationScreen extends StatelessWidget {
  const AdminNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminNotificationController controller = Get.put(AdminNotificationController());

    // Mark all as read when user enters this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markAllAsRead();
    });

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        titleText: 'Notifications',
        action: [
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
          const SizedBox(height: 10),
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
          const SizedBox(height: 15),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const [
                AdminAllNotificationsTab(),
                AdminOfferNotificationsTab(),
                AdminValidationHubNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
