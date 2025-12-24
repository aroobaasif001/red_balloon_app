import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../../widget/completed_task_item_card.dart';
import '../controller/admin_all_tasks_controller.dart';

class CompletedTasksTab extends StatelessWidget {
  const CompletedTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminAllTasksController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: redColor));
      }

      final completedTasks = controller.allTasks.where((task) => task.status == 'completed').toList();

      if (completedTasks.isEmpty) {
        return const Center(child: Text('No completed tasks available'));
      }

      return RefreshIndicator(
        color: redColor,
        onRefresh: () => controller.fetchAllTasks(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: completedTasks.map((task) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CompletedTaskItemCard(
                  title: task.title,
                  price: "SAR ${task.budget.toStringAsFixed(2)}",
                  completedAgo: _getTimeAgo(task.createdAt),
                  image: task.imageUrl ?? "",
                  taskId: task.id,
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  String _getTimeAgo(DateTime? createdAt) {
    if (createdAt == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
