import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/in_progress_view_details.dart';

import '../../post_new_task/post_new_task_screen.dart';
import 'clean_my_solar_panels.dart';

class ActiveTab extends StatelessWidget {
  const ActiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final TasksController controller = Get.put(TasksController());

    return RefreshIndicator(
      backgroundColor: whiteColor,

      color: Colors.red,
      onRefresh: () => controller.refreshTasks(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // ==================== TASKS NEAR ME SECTION ====================
            // CustomText(
            //   'Tasks Near Me',
            //   fontSize: 22,
            //   fontWeight: FontVariant.bold,
            // ),
            // const SizedBox(height: 15),
            Obx(() {
              // Show loading indicator
              if (controller.isLoadingTasksNearMe.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                );
              }

              // 🔥 Get current user ID
              final authService = AuthService();
              final currentUserId = authService.currentUser!.uid;

              // 🔥 Filter tasks:
              // 1. Remove completed tasks
              // 2. Remove "in progress" tasks where acceptedOfferUid != current user
              final filteredTasks = controller.tasksNearMe.where((task) {
                final status = task.status.toLowerCase();

                // Remove completed tasks
                if (status == 'completed' ||
                    status == 'rejected' ||
                    status == 'cancelled')
                  return false;

                // Remove "in progress" tasks that don't belong to current user
                if (status == 'in progress' &&
                    task.acceptedOfferUid != currentUserId) {
                  return false;
                }

                // Keep all other tasks
                return true;
              }).toList();

              // 🔥 Sort tasks: "in progress" (with matching acceptedOfferUid) first, then others
              filteredTasks.sort((a, b) {
                // Check if task is truly in progress for current user
                final aIsInProgress =
                    a.status.toLowerCase() == 'in progress' &&
                    a.acceptedOfferUid == currentUserId;
                final bIsInProgress =
                    b.status.toLowerCase() == 'in progress' &&
                    b.acceptedOfferUid == currentUserId;

                if (aIsInProgress && !bIsInProgress) return -1;
                if (!aIsInProgress && bIsInProgress) return 1;
                return 0;
              });

              // Show empty state if no tasks after filtering
              if (filteredTasks.isEmpty) {
                return Container(
                  width: double.infinity,

                  height: 500,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: whiteColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        'No tasks nearby',
                        fontSize: 16,
                        color: Colors.grey[600]!,
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        'Check back later for new tasks',
                        fontSize: 14,
                        color: Colors.grey[500]!,
                      ),
                    ],
                  ),
                );
              }

              // Show list of filtered and sorted tasks
              return Column(
                children: filteredTasks.map((task) {
                  // 🔥 Check if task is truly "in progress" for current user
                  // Must have status "in progress" AND acceptedOfferUid matches current user
                  final isAccepted =
                      task.status.toLowerCase() == 'in progress' &&
                      task.acceptedOfferUid == currentUserId;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CustomMyTaskCard(
                      title: task.title,
                      amount: controller.formatBudget(task.budget),
                      status: controller.getStatusText(task.status),
                      postedTime: controller.getTimeAgo(task.createdAt),
                      image: task.imageUrl != null && task.imageUrl!.isNotEmpty
                          ? task.imageUrl!
                          : "assets/images/sofa.png",
                      isNetworkImage:
                          task.imageUrl != null && task.imageUrl!.isNotEmpty,
                      distance: '2.5 km away',
                      taskType: task.taskType, // 🔥 Pass taskType
                      onEdit: () {
                        Get.to(() => PostNewTaskScreen());
                      },
                      showButton: true,
                      btnText: isAccepted
                          ? 'In Progress'
                          : 'View Details', // 🔥 Conditional button text
                      onViewDetails: () async {
                        // Fetch user profile data
                        final authService = AuthService();
                        final userData = await authService.getUserData(
                          task.uid,
                        );

                        final userName = userData?['displayName'] ?? 'Unknown';

                        final userPhoto = userData?['photoURL'];
                        final userId = userData?['userId'];
                        final phone = userData?['phoneNumber'];

                        isAccepted
                            ? Get.to(
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
                                ),
                              )
                            : Get.to(
                                () => Cleanmysolarpanels(
                                  taskId: task.id,

                                  location: task.taskType == 'Offline Task'
                                      ? task.location
                                      : '',
                                  taskType: task.taskType,
                                  taskDescription: task.description,
                                  taskTitle: task.title,
                                  taskPrice: controller.formatBudget(
                                    task.budget,
                                  ),
                                  taskBudget: task.budget,
                                  taskTimeAgo: controller.getTimeAgo(
                                    task.createdAt,
                                  ),
                                  taskImage:
                                      task.imageUrl != null &&
                                          task.imageUrl!.isNotEmpty
                                      ? task.imageUrl!
                                      : "assets/images/sofa.png",
                                  userId: userId,
                                  userName: userName,
                                  userPhoto: userPhoto,
                                ),
                              );
                      },
                    ),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}
