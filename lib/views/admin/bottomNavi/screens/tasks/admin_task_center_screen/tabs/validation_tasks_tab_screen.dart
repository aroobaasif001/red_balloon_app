import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../widget/validation_task_item_card.dart';
import '../controller/admin_validation_tasks_controller.dart';

class ValidationTasksTab extends StatelessWidget {
  const ValidationTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    print('📱 ValidationTasksTab build() called');
    final controller = Get.find<AdminValidationTasksController>();
    print(
      '📊 Controller state - isLoading: ${controller.isLoading.value}, validations count: ${controller.validationTasks.length}',
    );

    return Obx(() {
      print(
        '🔄 Obx rebuilding - isLoading: ${controller.isLoading.value}, validations: ${controller.validationTasks.length}',
      );

      if (controller.isLoading.value) {
        print('⏳ Showing loading indicator');
        return const Center(child: CircularProgressIndicator(color: redColor));
      }

      if (controller.validationTasks.isEmpty) {
        print('📭 Showing empty state');
        return const Center(child: Text('No validation tasks available'));
      }

      print('✅ Showing ${controller.validationTasks.length} validation tasks');

      return RefreshIndicator(
        color: redColor,
        onRefresh: () => controller.fetchValidationTasks(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              ...controller.validationTasks.map((validation) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ValidationTaskItemCard(
                    title: validation['title'] ?? 'No Title',
                    price:
                        "SAR ${(validation['budget'] ?? 0).toStringAsFixed(2)}",
                    startedAgo: controller.getTimeAgo(validation['rejectedAt']),
                    image: validation['imageUrl'] ?? "",
                    validationId: validation['validationId'],
                  ),
                );
              }).toList(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      );
    });
  }
}
