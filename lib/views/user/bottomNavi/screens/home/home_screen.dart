import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/tabs/controller/tasks_for_you_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/tabs/tasks_for_you_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/widgets/custom_bonus_slider.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/widgets/custom_wallet_card.dart';

import '../../bottom_navi_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/tabs/messages_screen.dart';
import '../profile/tabs/profile_screen.dart';
import '../task/post_new_task/post_new_task_screen.dart';
import 'controller/home_controller.dart';
import 'info/about_app_screen.dart';
import 'info/contact_us_screen.dart';
import 'info/faq_screen.dart';
import 'info/how_it_works_screen.dart';


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
            // width: 100,
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
            child: RefreshIndicator(
              backgroundColor: whiteColor,

              onRefresh: () async {
                final tasksController = Get.put(TasksForYouController());
                await tasksController.refreshTasks();
              },
              color: redColor,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                                      Get.to(() => MessagesScreen());
                                    },
                                    icon: Image(
                                      image: AssetImage(
                                        'assets/icons/homemessage.png',
                                      ),

                                      height: 24,
                                    ),
                                  ),
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
                                    child: GetBuilder<AuthController>(
                                      init: AuthController(),
                                      builder: (authController) {
                                        final photoURL = authController
                                            .currentUser
                                            .value
                                            ?.photoURL;

                                        return CustomContainer(
                                          height: 50,
                                          width: 50,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          child: Center(
                                            child:
                                                photoURL != null &&
                                                    photoURL.isNotEmpty
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                    child: Image.network(
                                                      photoURL,
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Image.asset(
                                                              'assets/icons/profile.png',
                                                              height: 50,
                                                              width: 50,
                                                            );
                                                          },
                                                    ),
                                                  )
                                                : Image.asset(
                                                    'assets/icons/profile.png',
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                          ),
                                        );
                                      },
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
                              Get.offAll(
                                () => BottomNaviScreen(initialIndex: 4),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    // Tasks Section
                    const TasksForYouTab(),
                    const SizedBox(height: 20),
                    // Menu Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomContainer(
                        conColor: rbcolor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.25),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        child: Column(
                          children: [
                            _buildMenuItem(
                              Icons.info_outline,
                              "About the app",
                              () {
                                Get.to(() => const AboutAppScreen());
                              },
                            ),
                            _buildMenuItem(
                              Icons.chat_outlined,
                              "Contact Us",
                              () {
                                Get.to(() => const ContactUsScreen());
                              },
                            ),
                            _buildMenuItem(Icons.help_outline, "FAQ's", () {
                              Get.to(() => const FAQScreen());
                            }),
                            _buildMenuItem(Icons.history, "How it works", () {
                              Get.to(() => const HowItWorksScreen());
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 15),
            Expanded(
              child: CustomText(
                title,
                fontSize: 16,
                fontWeight: FontVariant.medium,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
