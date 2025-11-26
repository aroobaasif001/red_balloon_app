import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/controller/home_controller.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/tabs/tasks_for_you_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/widgets/custom_bonus_slider.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/widgets/custom_quick_actions.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/widgets/custom_wallet_card.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/notification/notification_screen.dart';

import '../profile/tabs/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/splash_logo.png',
                              ),
                              height: 84,
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                Get.to(() => NotificationScreen());
                              },
                              icon: Image(
                                image: AssetImage(
                                  'assets/icons/notification.png',
                                ),
                                height: 24,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ProfileScreen());
                              },
                              child: Image(
                                image: AssetImage('assets/icons/profile.png'),
                                height: 50,
                              ),
                              customBorder: CircleBorder(),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.99),
                        // Bonus Slider
                        CustomBonusSlider(),
                        SizedBox(height: 23.99),
                        // Wallet Card
                        CustomWalletCard(
                          availableAmount: '255.00',
                          onAddFunds: () {
                            print("Add funds tapped");
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  // Tab Views
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.77,
                    child: TabBarView(
                      controller: controller.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [TasksForYouTab()],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Quick Actions',
                          fontSize: 18,
                          fontWeight: FontVariant.bold,
                        ),
                        SizedBox(height: 10),
                        CustomQuickActions(),
                      ],
                    ),
                  ),
                  SizedBox(height: 110),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
