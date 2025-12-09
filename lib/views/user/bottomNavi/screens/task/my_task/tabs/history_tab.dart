import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/widgets/history_task_card.dart';

import '../../../validations_tab/validation_screen/validation_screen.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the TasksController
    final TasksController controller = Get.find<TasksController>();

    // Real-time updates are already active from controller's onInit
    // No need to fetch again here

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
                return Container(
                  width: double.infinity,
                  height: 500,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 50, color: Colors.grey[400]),
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
                  String statusText;
                  if (task.status.toLowerCase() == 'rejected') {
                    statusText = 'Validation';
                  } else if (task.status.toLowerCase() == 'completed') {
                    statusText = 'Completed';
                  } else {
                    statusText = 'Disputed';
                  }
                  // if (task.status)
                  print(task.createdAt.toString());
                  String time = DateFormat(
                    'dd MMM \'at\' hh:mm a',
                    'en_US',
                  ).format(task.createdAt);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: HistoryTaskCard(
                      title: task.title,
                      amount: controller.formatBudget(task.budget),
                      statusText: statusText,
                      statusTextColor: task.status.toLowerCase() == 'completed'
                          ? greenColor // 🔥 Red for rejected tasks
                          : redColor,
                      statusBgColor: task.status.toLowerCase() == 'completed'
                          ? greenColor.withOpacity(
                              0.25,
                            ) // 🔥 Red for rejected tasks
                          : redColor.withOpacity(0.25),

                      onViewDetails: () async {
                        // 🔥 For rejected tasks, fetch validation data and navigate
                        if (task.status.toLowerCase() == 'rejected') {
                          try {
                            // Fetch validation data from validations collection
                            final validationSnapshot = await FirebaseFirestore
                                .instance
                                .collection('validations')
                                .where('taskId', isEqualTo: task.id)
                                .limit(1)
                                .get();

                            if (validationSnapshot.docs.isNotEmpty) {
                              final validationData = validationSnapshot
                                  .docs
                                  .first
                                  .data();

                              // Fetch userId from users collection using rejectedBy
                              String userId = 'RB-00000';
                              final rejectedBy = validationData['rejectedBy'];
                              if (rejectedBy != null && rejectedBy.isNotEmpty) {
                                final userDoc = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(rejectedBy)
                                    .get();
                                if (userDoc.exists) {
                                  userId =
                                      userDoc.data()?['userId'] ?? 'RB-00000';
                                }
                              }

                              // Navigate with validation data
                              Get.to(
                                () => ValidationScreen(
                                  taskId: task.id,
                                  userId: userId,
                                  beforePhotoUrl:
                                      validationData['beforePhotoUrl'] ?? '',
                                  afterPhotoUrl:
                                      validationData['afterPhotoUrl'] ?? '',
                                ),
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Validation data not found',
                              );
                            }
                          } catch (e) {
                            print('❌ Error fetching validation data: $e');
                            Get.snackbar(
                              'Error',
                              'Failed to load validation details',
                            );
                          }
                        } else {
                          Get.to(() => TaskDetailsScreen(task: task));
                        }
                      },
                      location: '2.5 km away',
                      dateTime: time,
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
