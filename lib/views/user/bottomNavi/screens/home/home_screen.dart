import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
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
import '../notification/controller/notification_controller.dart';
import '../task/post_new_task/post_new_task_screen.dart';
import '../profile/tabs/controller/messages_controller.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final msgController = Get.find<MessagesController>();
    final notiController = Get.find<NotificationController>();

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
                                  Obx(() {
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.to(() => const MessagesScreen());
                                          },
                                          icon: const Image(
                                            image: AssetImage(
                                              'assets/icons/homemessage.png',
                                            ),
                                            height: 24,
                                          ),
                                        ),
                                        if (msgController.totalUnreadCount.value > 0)
                                          Positioned(
                                            right: 4,
                                            top: 4,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: redColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 16,
                                                minHeight: 16,
                                              ),
                                              child: Text(
                                                '${msgController.totalUnreadCount.value}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                  Obx(() {
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.to(() => const NotificationScreen());
                                          },
                                          icon: const Image(
                                            image: AssetImage(
                                              'assets/icons/notification.png',
                                            ),
                                            height: 24,
                                          ),
                                        ),
                                        if (notiController.unreadCount.value > 0)
                                          Positioned(
                                            right: 4,
                                            top: 4,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: redColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 16,
                                                minHeight: 16,
                                              ),
                                              child: Text(
                                                '${notiController.unreadCount.value}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
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
                          Obx(() {
                            if (controller.activeBanners.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 14.99),
                                // Bonus Slider
                                const CustomBonusSlider(),
                                const SizedBox(height: 23.99),
                              ],
                            );
                          }),
                          // Wallet Card
                          Obx(
                            () => CustomWalletCard(
                              availableAmount:
                                  '${controller.walletBalance.value.toStringAsFixed(2)}',
                              onAddFunds: () {
                                print("Add funds tapped");
                                Get.offAll(
                                  () => BottomNaviScreen(initialIndex: 4),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    // Tasks Section
                    const TasksForYouTab(),

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
}
