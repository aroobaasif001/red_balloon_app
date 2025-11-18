import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/notification/controller/notification_controller.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/notification/tabs/all_notifications_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/notification/tabs/offer_notifications_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/notification/tabs/validation_hub_notifications_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/notification/widgets/custom_notification_tabs.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (NotificationController controller) {
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
              color: Colors.black,
            ),
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
      },
    );
  }
}
