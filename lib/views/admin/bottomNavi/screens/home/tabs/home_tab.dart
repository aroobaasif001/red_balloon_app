import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/Profile/tabs/profile_screen.dart';

import '../../../../../../utils/colors.dart';
import '../../Notification/notification_screen.dart';
import '../controllers/home_tab_controller.dart';
import '../widgets/admin_custom_tab_bar_task.dart';
import '../widgets/admin_home_morning_widget.dart';
import '../widgets/admin_home_platform_metrics_widget.dart';
import 'home_task_screen.dart';

class AdminHomeTab extends StatelessWidget {
  const AdminHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeTabsController controller = Get.put(HomeTabsController());

    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        Image(image: AssetImage('assets/images/splash_logo.png'), height: 84),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.to(() => AdminNotificationScreen());
                          },
                          icon: Image(image: AssetImage('assets/icons/notification.png'), height: 24),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => AdminProfileScreen());
                          },
                          child: Image(image: AssetImage('assets/icons/profile.png'), height: 50),
                          customBorder: CircleBorder(),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.99),
                    admin_home_morning_widget(iconPath: 'assets/icons/sun.png', greeting: 'Good Morning'),
                  ],
                ),
                SizedBox(height: 22),
                CustomText(
                  'Platform Metrics',
                  fontSize: 20,
                  fontWeight: FontVariant.semiBold,
                  color: blackLightColor,
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    admin_home_platform_metrics_widget(),
                    SizedBox(width: 10),
                    admin_home_platform_metrics_widget(
                      iconPath: 'assets/icons/dispute.png',
                      value: '8',
                      title: 'Disputes',
                    ),
                  ],
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    admin_home_platform_metrics_widget(
                      iconPath: 'assets/icons/lock_2.png',
                      value: '\$12.4k',
                      title: 'Wallet Locked',
                    ),
                    SizedBox(width: 10),
                    admin_home_platform_metrics_widget(
                      iconPath: 'assets/icons/clock_2.png',
                      value: '15',
                      title: 'Pending Withdrawals',
                    ),
                  ],
                ),
                SizedBox(height: 22),
                CustomText('Alerts', fontSize: 20, fontWeight: FontVariant.semiBold, color: blackLightColor),
                SizedBox(height: 22),
                Obx(
                  () => AdminCustomTabBarTask(
                    selectedIndex: controller.selectedTab.value,
                    onTaskTap: () => controller.changeTab(0),
                    onValidationTap: () => controller.changeTab(1),
                    onWalletTap: () => controller.changeTab(2),
                  ),
                ),
                SizedBox(height: 35),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TabBarView(
                    controller: controller.tabController,
                    children: const [
                      HomeTaskScreen(type: 'task'),
                      HomeTaskScreen(type: 'validation'),
                      HomeTaskScreen(type: 'wallet'),
                    ],
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
