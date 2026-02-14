import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
    // Find the existing controller (put by MyTaskScreen)
    final TasksController controller = Get.put(TasksController());

    return RefreshIndicator(
      backgroundColor: whiteColor,

      color: redColor,
      onRefresh: () =>
          controller.refreshTasks(minDelay: const Duration(seconds: 1)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(right: 15, bottom: 0, left: 15),
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
                return Container(
                  height: 600,
                  child: Center(
                    child: Lottie.asset(
                      'assets/animation/loader.json',
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                );
              }

              // 🔥 Get current user ID
              final authService = AuthService();
              final user = authService.currentUser;

              if (user == null) {
                return const SizedBox.shrink();
              }

              final currentUserId = user.uid;

              // 🔥 Filter tasks:
              // 1. Task owner is NOT current user
              // 2. Status is 'active' OR 'in progress' (where I am the helper)
              final filteredTasks = controller.tasksNearMe.where((task) {
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

                // 🔥 NEW: Filter out 'active' tasks if older than 2 hours
                if (status == 'active') {
                  final now = DateTime.now();
                  final differenceInMinutes =
                      now.difference(task.createdAt).inMinutes;
                  if (differenceInMinutes >= 120) {
                    return false;
                  }
                }

                // 🔥 NEW: Filter out 'active' tasks if owner is suspended
                if (status == 'active' &&
                    controller.isUserSuspended(task.uid)) {
                  return false;
                }

                // 🔥 NEW: Filter offline tasks by distance (max 20km) - ONLY for 'active' tasks
                if (status == 'active' && task.taskType == 'Offline Task') {
                  final rawDistance = controller.getRawDistanceToTask(
                    task.latitude,
                    task.longitude,
                  );
                  // If distance is > 20,000 meters (20km), hide it
                  if (rawDistance != null && rawDistance > 20000) {
                    return false;
                  }
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
                        color: rbnewcolor,
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        'No tasks nearby',
                        fontSize: 16,
                        color: grey6Color!,
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        'Check back later for new tasks',
                        fontSize: 14,
                        color: taskstatus3!,
                      ),
                    ],
                  ),
                );
              }

              // Show list of filtered and sorted tasks
              return Column(
                children: filteredTasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;

                  // 🔥 Check if task is truly "in progress" for current user
                  // Must have status "in progress" AND acceptedOfferUid matches current user
                  final isAccepted =
                      task.status.toLowerCase() == 'in progress' &&
                      task.acceptedOfferUid == currentUserId;

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
                        distance: controller.getDistanceToTask(task.latitude, task.longitude),
                        taskType: task.taskType, // 🔥 Pass taskType
                        onEdit: () {
                          Get.to(() => PostNewTaskScreen());
                        },
                        showButton: true,
                        btnText: isAccepted
                            ? 'In Progress'
                            : 'View Details', // 🔥 Conditional button text
                        onViewDetails: () async {
                          // 🔥 Check if task owner is suspended
                          if (controller.isUserSuspended(task.uid)) {
                            Get.snackbar(
                              'Account Suspended',
                              'The task owner\'s account has been suspended by administration.',
                            );
                            return;
                          }

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

                          // 🔥 FIX: Determine who is the OTHER party
                          final currentUser = FirebaseAuth.instance.currentUser;
                          String otherUserUid;
                          
                          // Check if there's an accepted offer UID in the task
                          final acceptedOfferUid = task.acceptedOfferUid ?? '';
                          
                          if (currentUser != null && acceptedOfferUid.isNotEmpty && acceptedOfferUid == currentUser.uid) {
                            // Current user is the HELPER, so pass REQUESTER (task owner)
                            otherUserUid = task.uid;
                            print('🔍 [ActiveTaskTab] Current user is HELPER, passing REQUESTER UID: $otherUserUid');
                          } else {
                            // Current user is the REQUESTER, so pass HELPER (or task owner if no helper yet)
                            otherUserUid = acceptedOfferUid.isNotEmpty ? acceptedOfferUid : task.uid;
                            print('🔍 [ActiveTaskTab] Current user is REQUESTER, passing HELPER UID: $otherUserUid');
                          }
                          
                          print('🔍 Other user UID from task: $otherUserUid');

                          print(
                            '🔍 Navigating to InProgressViewDetails with otherUserUid: $otherUserUid',
                          );

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
                                    helperUid: otherUserUid,
                                    taskImage: task.imageUrl,
                                    latitude: task.latitude,
                                    longitude: task.longitude,
                                    taskType: task.taskType, // 🔥 Pass taskType
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
                                    taskOwnerAuthId:
                                        task.uid, // Pass Auth UID explicitly
                                    latitude: task.latitude,
                                    longitude: task.longitude,
                                  ),
                                );
                        },
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
