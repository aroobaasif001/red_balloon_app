import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../bottom_navi_screen.dart';
import '../../task/my_task/tabs/clean_my_solar_panels.dart';
import '../../task/my_task/tabs/in_progress_view_details.dart';
import '../widgets/offline_and_online_card.dart';
import 'controller/tasks_for_you_controller.dart';

class TasksForYouTab extends StatelessWidget {
  const TasksForYouTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TasksForYouController());

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
            // Listen to updateTrigger to rebuild when time updates
            controller.updateTrigger.value;

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

            // 🔥 Get current user ID
            final authService = AuthService();
            final currentUserId = authService.currentUser!.uid;

            // 🔥 Filter tasks (Logic matching ActiveTab):
            // 1. Task owner is NOT current user
            // 2. Status is 'active' OR 'in progress' (where I am the helper)
            final filteredTasks = controller.tasksForYou.where((task) {
              final status = task.status.toLowerCase();

              // 🔥 Remove tasks created by current user
              if (task.uid == currentUserId) {
                return false;
              }

              // 🔥 Only allow 'active' or 'in progress'
              if (status != 'active' && status != 'in progress') {
                return false;
              }

              // 🔥 If 'in progress', ensure current user is the helper
              if (status == 'in progress' &&
                  task.acceptedOfferUid != currentUserId) {
                return false;
              }

              return true;
            }).toList();

            // 🔥 Sort tasks: "in progress" first, then "active"
            filteredTasks.sort((a, b) {
              final aIsInProgress = a.status.toLowerCase() == 'in progress';
              final bIsInProgress = b.status.toLowerCase() == 'in progress';

              if (aIsInProgress && !bIsInProgress) return -1;
              if (!aIsInProgress && bIsInProgress) return 1;
              return 0;
            });

            // 🔥 Limit to max 4 tasks for the home screen section
            final limitedTasks = filteredTasks.take(4).toList();

            if (limitedTasks.isEmpty) {
              return Container(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/empty.png',
                          height: 40,
                          width: 40,
                          color: blackColor,
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

            return RefreshIndicator(
              backgroundColor: whiteColor,
              onRefresh: controller.refreshTasks,
              color: redColor,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: limitedTasks.length,
                itemBuilder: (context, index) {
                  final task = limitedTasks[index];
                  final isOfflineTask = task.taskType == 'Offline Task';

                  // 🔥 Check if task is truly "in progress" for current user
                  final isInProgress =
                      task.status.toLowerCase() == 'in progress' &&
                          task.acceptedOfferUid == currentUserId;

                  return FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    delay: Duration(milliseconds: index * 700),
                    child: Padding(
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
                        btnText: isInProgress ? 'In Progress' : 'View Details',
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
                          final userId = userData?['userId'];
                          final phone = userData?['phoneNumber'];

                          if (isInProgress) {
                            Get.to(
                              () => InProgressViewDetails(
                                userId: userId,
                                taskId: task.id,
                                timeAgo: controller.getTimeAgo(
                                  task.createdAt,
                                ),
                                taskTitle: task.title,
                                price: task.budget.toString(),
                                userName: userName,
                                photoUrl: userPhoto,
                                location: task.location,
                                phoneNumber: phone,
                                helperUid: task.uid,
                                taskImage: task.imageUrl,
                              ),
                            );
                          } else {
                            Get.to(
                              () => Cleanmysolarpanels(
                                taskId: task.id,
                                location: isOfflineTask ? task.location : null,
                                taskTitle: task.title,
                                taskDescription: task.description,
                                taskPrice: controller.formatBudget(
                                  task.budget,
                                ),
                                taskBudget: task.budget,
                                taskTimeAgo: controller.getTimeAgo(
                                  task.createdAt,
                                ),
                                taskType: task.taskType,
                                taskImage: controller.getImageUrl(task),
                                userId: userId,
                                userName: userName,
                                userPhoto: userPhoto,
                                taskOwnerAuthId: task.uid,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
