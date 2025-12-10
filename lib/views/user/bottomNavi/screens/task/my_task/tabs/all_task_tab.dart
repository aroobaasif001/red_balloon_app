import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';

import '../../post_new_task/post_new_task_screen.dart';
import 'task_in_progress_screen.dart'; // 🔥 Import TaskInProgressScreen

class AllTaskTab extends StatelessWidget {
  const AllTaskTab({super.key});

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
            // // ==================== MY TASKS SECTION ====================
            // CustomText('My Tasks', fontSize: 22, fontWeight: FontVariant.bold),
            // const SizedBox(height: 15),
            Obx(() {
              // Get current user ID
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;

              // Filter tasks:
              // 1. Remove completed, cancelled, rejected tasks
              // 2. For "active" tasks: ensure userId == current user
              // 3. For "in progress" tasks: ensure acceptedOfferUid == current user
              final filteredTasks = controller.myTasks.where((task) {
                final status = task.status.toLowerCase();

                // Remove completed, cancelled, rejected tasks
                if (status == 'completed' ||
                    status == 'rejected' ||
                    status == 'cancelled' ||
                    status == 'disputed') {
                  return false;
                }

                // For active tasks: check if user is the task owner
                if (status == 'active' && task.userId == currentUserId) {
                  return false;
                }

                // For in progress tasks: check if user is the accepted helper
                if (status == 'in progress' &&
                    task.acceptedOfferUid == currentUserId) {
                  return false;
                }

                // Keep all other valid tasks
                return true;
              }).toList();
              // Show loading indicator
              if (controller.isLoadingMyTasks.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                );
              }

              // Show empty state if no tasks
              if (filteredTasks.isEmpty) {
                return Center(
                  child: Container(
                    width: double.infinity,
                    height: 500,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: whiteColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt_outlined,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          'No tasks yet',
                          fontSize: 16,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          'Create your first task to get started',
                          fontSize: 14,
                          color: Colors.grey[500]!,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show list of tasks
              return Column(
                children: filteredTasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;

                  // 🔥 Check if task is in progress
                  final isInProgress =
                      task.status.toLowerCase() == 'in progress';

                  return FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    delay: Duration(milliseconds: index * 700),
                    child: Padding(
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
                        btnText: isInProgress
                            ? 'In Progress'
                            : 'View Details', // 🔥 Dynamic button text
                        onEdit: () {
                          Get.to(() => PostNewTaskScreen());
                        },
                        onViewDetails: () {
                          // 🔥 Navigate based on task status
                          if (isInProgress) {
                            Get.to(() => TaskInProgressScreen());
                          } else {
                            Get.to(() => TaskDetailsScreen(task: task));
                          }
                        },
                        showButton: true,
                      ),
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
