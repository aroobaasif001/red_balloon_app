import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/tabs/tasks_for_you_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/widgets/custom_bonus_slider.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/widgets/custom_wallet_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/tabs/in_app_store_screen.dart';

import '../notification/notification_screen.dart';
import '../profile/tabs/profile_screen.dart';
import '../task/post_new_task/post_new_task_screen.dart';
import '../wallet/tabs/add_funds.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          floatingActionButton: CustomContainer(
            height: 300,
            width: 100,
            borderRadius: BorderRadius.circular(50),
            padding: EdgeInsets.only(bottom: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  onPressed: () {
                    Get.to(() => InAppStoreScreen());
                  },
                  heroTag: 'favorites_fab',
                  backgroundColor: redColor,
                  child: Center(
                    child: Image.asset(
                      'assets/icons/inapp.png',
                      height: 30,
                      width: 30,
                      color: whiteColor,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  onPressed: () {
                    Get.to(() => PostNewTaskScreen());
                  },
                  heroTag: 'add_task_fab',
                  backgroundColor: redColor,
                  child: Icon(Icons.add, color: whiteColor),
                ),
              ],
            ),
          ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/splash_logo.png',
                              ),
                              height: 84,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                  child: CustomContainer(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icons/profile.png',
                                        ),
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                            Get.to(() => AddFunds());
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // Tasks Section
                  const TasksForYouTab(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
