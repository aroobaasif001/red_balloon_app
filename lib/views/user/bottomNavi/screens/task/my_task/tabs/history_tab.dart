import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/clean_my_solar_panels.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';

import '../../../validations_tab/validation_screen/validation_screen.dart';
import '../../post_new_task/post_new_task_screen.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the TasksController
    final TasksController controller = Get.find<TasksController>();
    
    // Fetch history tasks when tab is opened
    controller.fetchHistoryTasks();

    return RefreshIndicator(
      backgroundColor: whiteColor,
      color: redColor,
      onRefresh: () => controller.fetchHistoryTasks(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Column(
          children: [
            Obx(() {
              // Show loading indicator
              if (controller.isLoadingHistoryTasks.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: redColor),
                  ),
                );
              }

              // Show empty state if no history tasks
              if (controller.historyTasks.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        'No history yet',
                        fontSize: 16,
                        color: Colors.grey[600]!,
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        'Completed and cancelled tasks \nwill appear here',
                        fontSize: 14,
                        color: Colors.grey[500]!,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // Show list of history tasks
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.historyTasks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final task = controller.historyTasks[index];
                  
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
                      isNetworkImage: task.imageUrl != null && task.imageUrl!.isNotEmpty,
                      distance: '2.5 km away',
                      taskType: task.taskType,
                      showButton: true,
                      btnText: task.status.toLowerCase() == 'completed' 
                          ? 'Completed' 
                          : task.status.toLowerCase() == 'rejected'
                              ? 'Validation'
                              : 'Cancelled',
                      buttonColor: task.status.toLowerCase() == 'rejected'
                          ? redColor // 🔥 Red for rejected tasks
                          : const Color(0xFFEF9A9A), // Light pink/salmon for others
                      isButtonEnabled: task.status.toLowerCase() == 'rejected', // 🔥 Enable for rejected
                      showType: false,
                      onViewDetails: () async {
                        // 🔥 For rejected tasks, fetch validation data and navigate
                        if (task.status.toLowerCase() == 'rejected') {
                          try {
                            // Fetch validation data from validations collection
                            final validationSnapshot = await FirebaseFirestore.instance
                                .collection('validations')
                                .where('taskId', isEqualTo: task.id)
                                .limit(1)
                                .get();

                            if (validationSnapshot.docs.isNotEmpty) {
                              final validationData = validationSnapshot.docs.first.data();

                              // Fetch userId from users collection using rejectedBy
                              String userId = 'RB-00000';
                              final rejectedBy = validationData['rejectedBy'];
                              if (rejectedBy != null && rejectedBy.isNotEmpty) {
                                final userDoc = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(rejectedBy)
                                    .get();
                                if (userDoc.exists) {
                                  userId = userDoc.data()?['userId'] ?? 'RB-00000';
                                }
                              }

                              // Navigate with validation data
                              Get.to(() => ValidationScreen(
                                taskId: task.id,
                                userId: userId,
                                beforePhotoUrl: validationData['beforePhotoUrl'] ?? '',
                                afterPhotoUrl: validationData['afterPhotoUrl'] ?? '',
                              ));
                            } else {
                              Get.snackbar('Error', 'Validation data not found');
                            }
                          } catch (e) {
                            print('❌ Error fetching validation data: $e');
                            Get.snackbar('Error', 'Failed to load validation details');
                          }
                        } else {
                          Get.to(() => TaskDetailsScreen(task: task));
                        }
                      },
                      onEdit: () {
                        // 🔥 For rejected tasks, show validation details
                        if (task.status.toLowerCase() == 'rejected') {
                          // TODO: Navigate to validation details screen
                          Get.snackbar('Validation', 'View validation details for ${task.title}');
                        } else {
                          Get.to(() => PostNewTaskScreen());
                        }
                      },
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}
