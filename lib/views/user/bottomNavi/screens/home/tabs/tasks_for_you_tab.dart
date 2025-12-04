import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../bottom_navi_screen.dart';
import '../../task/my_task/tabs/clean_my_solar_panels.dart';
import '../widgets/offline_and_online_card.dart';
import 'controller/tasks_for_you_controller.dart';

class TasksForYouTab extends StatelessWidget {
  const TasksForYouTab({super.key});

  static final controller = Get.put(TasksForYouController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.size.height;
    final screenWidth = Get.size.width;

    // Calculate responsive aspect ratio based on device dimensions
    final responsiveAspectRatio = screenWidth / (screenHeight * 0.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'Tasks for you',
                fontSize: 24,
                fontWeight: FontVariant.bold,
              ),
              InkWell(
                onTap: () {
                  Get.offAll(() => BottomNaviScreen(initialIndex: 1));
                },
                child: CustomText(
                  'View All',
                  fontSize: 14,
                  fontWeight: FontVariant.medium,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(color: blackColor.withOpacity(0.35)),
        ),
        SizedBox(height: 17),
        CustomContainer(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: redColor),
                ),
              );
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomText(
                    controller.errorMessage.value,
                    color: redColor,
                    fontSize: 14,
                  ),
                ),
              );
            }

            if (controller.tasksForYou.isEmpty) {
              return RefreshIndicator(
                backgroundColor: whiteColor,
                onRefresh: controller.refreshTasks,
                color: redColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/empty.png',
                          height: 40,
                          width: 40,
                          color: redColor,
                        ),
                        SizedBox(height: 20),
                        CustomText(
                          'No tasks available',
                          fontSize: 14,
                          color: blackColor,
                          fontWeight: FontVariant.semiBold,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Obx(() {
              // Listen to updateTrigger to rebuild when time updates
              controller.updateTrigger.value;

              return RefreshIndicator(
                backgroundColor: whiteColor,

                onRefresh: controller.refreshTasks,
                color: redColor,
                child: GridView.builder(
                  shrinkWrap: true,

                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: responsiveAspectRatio,
                    crossAxisSpacing: 12,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemCount: controller.tasksForYou.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasksForYou[index];
                    final isOfflineTask = task.taskType == 'Offline Task';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OfflineAndOnlineCard(
                        title: task.title,
                        subtitle: task.description,
                        distance: isOfflineTask ? task.location : null,
                        taskType: task.taskType,
                        timeAgo: controller.getTimeAgo(task.createdAt),
                        price: controller.formatBudget(task.budget),
                        image: controller.getImageUrl(task),
                        type: task.taskType,
                        onViewDetails: () async {
                          print("Task details tapped: ${task.id}");

                          // Fetch user profile data
                          final authService = AuthService();
                          final userData = await authService.getUserData(
                            task.uid,
                          );

                          final userName =
                              userData?['displayName'] ?? 'Unknown';
                          final userPhoto = userData?['photoURL'];

                          Get.to(
                            () => Cleanmysolarpanels(
                              taskId: task.id,
                              location: isOfflineTask ? task.location : null,
                              taskTitle: task.title,
                              taskDescription: task.description,
                              taskPrice: controller.formatBudget(task.budget),
                              taskBudget: task.budget,
                              taskTimeAgo: controller.getTimeAgo(
                                task.createdAt,
                              ),
                              taskType: task.taskType,
                              taskImage: controller.getImageUrl(task),
                              userId: task.uid,
                              userName: userName,
                              userPhoto: userPhoto,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            });
          }),
        ),
      ],
    );
  }
}
