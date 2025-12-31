import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';

import '../../post_new_task/controller/post_new_task_controller.dart';
import '../../post_new_task/post_new_task_screen.dart';
import 'task_in_progress_screen.dart'; // 🔥 Import TaskInProgressScreen

class AllTaskTab extends StatelessWidget {
  const AllTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the existing controller (put by MyTaskScreen)
    final TasksController controller = Get.put(TasksController());

    return RefreshIndicator(
      backgroundColor: whiteColor,

      color: redColor,
      onRefresh: () => controller.refreshTasks(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(right: 15, bottom: 0, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // ==================== MY TASKS SECTION ====================
            // CustomText('My Tasks', fontSize: 22, fontWeight: FontVariant.bold),
            // const SizedBox(height: 15),
            Obx(() {
              // 🔥 Get current user ID
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;

              if (currentUserId == null) {
                return const SizedBox.shrink();
              }

              // Filter tasks:
              // 1. Only show tasks for current user
              // 2. Only show "in progress" and "active" status
              final filteredTasks = controller.myTasks.where((task) {
                final status = task.status.toLowerCase();

                // 🔥 Only show tasks for current user
                if (task.uid != currentUserId) {
                  return false;
                }

                // 🔥 Only show "in progress" and "active" tasks
                if (status != 'in progress' && status != 'active') {
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
              // Show loading indicator
              if (controller.isLoadingMyTasks.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: redColor),
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
                          color: rbnewcolor,
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          'No tasks yet',
                          fontSize: 16,
                          color: grey6Color!,
                        ),
                        const SizedBox(height: 5),
                        CustomText(
                          'Create your first task to get started',
                          fontSize: 14,
                          color: taskstatus3!,
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
                        image:
                            task.imageUrl != null && task.imageUrl!.isNotEmpty
                            ? task.imageUrl!
                            : "assets/images/sofa.png",
                        isNetworkImage:
                            task.imageUrl != null && task.imageUrl!.isNotEmpty,
                        distance: null, // 🔥 Hide distance for own tasks
                        taskType: task.taskType, // 🔥 Pass taskType
                        btnText: isInProgress
                            ? 'In Progress'
                            : 'View Details', // 🔥 Dynamic button text
                        onLongPress: () {
                          if (task.status.toLowerCase() == 'active') {
                            _showEditDeleteBottomSheet(
                              context,
                              task,
                              controller,
                            );
                          }
                        },
                        onEdit: () {
                          Get.to(() => PostNewTaskScreen());
                        },
                        onViewDetails: () {
                          // 🔥 Check if other user involved is suspended
                          // Current user is owner, so check helper
                          if (task.acceptedOfferUid != null &&
                              controller.isUserSuspended(
                                task.acceptedOfferUid!,
                              )) {
                            Get.snackbar(
                              'Account Suspended',
                              'The helper\'s account has been suspended by administration.',
                            );
                            return;
                          }

                          // 🔥 Navigate based on task status
                          if (isInProgress) {
                            // 🔥 Pass taskId to load correct task
                            Get.to(() => TaskInProgressScreen(taskId: task.id));
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

  void _showEditDeleteBottomSheet(
    BuildContext context,
    TaskModel task,
    TasksController tasksController,
  ) {
    // We need PostNewTaskController for editing/deleting
    final postController = Get.put(PostNewTaskController());

    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: rbnewcolor),
                title: CustomText(
                  'Edit Task',
                  fontWeight: FontVariant.semiBold,
                ),
                onTap: () {
                  Get.back(); // Close bottom sheet
                  Get.to(() => PostNewTaskScreen(task: task));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: redColor),
                title: CustomText(
                  'Delete Task',
                  color: redColor,
                  fontWeight: FontVariant.semiBold,
                ),
                onTap: () {
                  Get.back(); // Close bottom sheet
                  _showDeleteConfirmation(
                    context,
                    task,
                    postController,
                    tasksController,
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TaskModel task,
    PostNewTaskController postController,
    TasksController tasksController,
  ) {
    DialogHelpers.showDeleteTaskDialog(
      context: context,
      budget: task.budget,
      taskTitle: task.title,
      onConfirm: () async {
        final success = await postController.deleteTask(
          task.id!,
          task.budget,
          task.title,
        );
        if (success) {
          tasksController.refreshTasks();
        }
      },
    );
  }
}
