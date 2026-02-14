import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../../widget/completed_task_item_card.dart';
import '../controller/admin_all_tasks_controller.dart';

import 'package:intl/intl.dart';

class CompletedTasksTab extends StatelessWidget {
  const CompletedTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminAllTasksController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: redColor));
      }

      final completedTasks =
          controller.allTasks.where((task) => task.status == 'completed').toList();

      if (completedTasks.isEmpty) {
        return const Center(child: Text('No completed tasks available'));
      }

      return RefreshIndicator(
        color: redColor,
        onRefresh: () => controller.fetchAllTasks(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              ...completedTasks.map((task) {
                String time = DateFormat(
                  'dd MMM \'at\' hh:mm a',
                  'en_US',
                ).format(task.completedAt ?? task.createdAt);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CompletedTaskItemCard(
                    title: task.title,
                    price: "SAR ${task.budget.toStringAsFixed(2)}",
                    location: task.location ?? "",
                    dateTime: time,
                    taskId: task.id,
                  ),
                );
              }).toList(),
              const SizedBox(height: 70), // Extra space for bottom nav
            ],

          ),

        ),
      );
    });
  }
}
