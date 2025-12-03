import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/clean_my_solar_panels.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';

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
                    child: CircularProgressIndicator(),
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
                          : 'Cancelled',
                      buttonColor: const Color(0xFFEF9A9A), // 🔥 Light pink/salmon color
                      isButtonEnabled: false, // 🔥 Disable button for history
                      showType: false,
                      onViewDetails: () {
                        Get.to(() => TaskDetailsScreen(task: task)); // 🔥 Pass real task
                      },
                      onEdit: () {
                        Get.to(() => PostNewTaskScreen());
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
