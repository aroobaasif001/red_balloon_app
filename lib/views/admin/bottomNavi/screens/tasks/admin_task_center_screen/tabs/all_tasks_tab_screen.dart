import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/admin_all_tasks_controller.dart';
import '../../widget/task_item_card.dart';

class AllTasksTab extends StatelessWidget {
  const AllTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    print('📱 AllTasksTab build() called');
    final controller = Get.put(AdminAllTasksController());
    print('📊 Controller state - isLoading: ${controller.isLoading.value}, tasks count: ${controller.allTasks.length}');

    return Obx(() {
      print('🔄 Obx rebuilding - isLoading: ${controller.isLoading.value}, tasks: ${controller.allTasks.length}');
      
      if (controller.isLoading.value) {
        print('⏳ Showing loading indicator');
        return const Center(
          child: CircularProgressIndicator(color: Colors.red,),
        );
      }

      if (controller.allTasks.isEmpty) {
        print('📭 Showing empty state');
        return const Center(
          child: Text('No tasks available'),
        );
      }

      print('✅ Showing ${controller.allTasks.length} tasks');

      return RefreshIndicator(
        color: Colors.red,
        onRefresh: () => controller.fetchAllTasks(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: controller.allTasks.map((task) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TaskItemCard(
                  title: task.title,
                  price: "SAR ${task.budget.toStringAsFixed(2)}",
                  distance: task.location ?? "Unknown location",
                  timeAgo: _getTimeAgo(task.createdAt),
                  image: "assets/images/Rectangle 34625307.png", // TaskItemCard only supports assets
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
