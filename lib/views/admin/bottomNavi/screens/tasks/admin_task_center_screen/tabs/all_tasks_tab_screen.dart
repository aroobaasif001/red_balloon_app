import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../widget/task_item_card.dart';
import '../controller/admin_all_tasks_controller.dart';

class AllTasksTab extends StatelessWidget {
  const AllTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    print('📱 AllTasksTab build() called');
    final controller = Get.find<AdminAllTasksController>();
    print(
      '📊 Controller state - isLoading: ${controller.isLoading.value}, tasks count: ${controller.allTasks.length}',
    );

    return Obx(() {
      final displayedTasks = controller.allTasks
          .where((task) => task.status.toLowerCase() != 'completed')
          .toList();

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: redColor));
      }

      if (displayedTasks.isEmpty) {
        return const Center(child: Text('No tasks available'));
      }

      return RefreshIndicator(
        color: redColor,
        onRefresh: () => controller.fetchAllTasks(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: displayedTasks.map((task) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TaskItemCard(
                  title: task.title,
                  price: "SAR ${task.budget.toStringAsFixed(2)}",
                  distance: task.location ?? "Unknown location",
                  timeAgo: _getTimeAgo(task.createdAt),
                  image: task.imageUrl ?? "",
                  taskId: task.id, // Pass real task ID
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
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
