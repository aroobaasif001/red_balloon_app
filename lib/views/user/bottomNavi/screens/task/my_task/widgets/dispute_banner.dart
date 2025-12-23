import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_disputed_controller.dart';

import '../controller/tasks_controller.dart';

class DisputeBanner extends StatelessWidget {
  final TaskDisputedController controller;
  final DateTime? startedTime;

  const DisputeBanner({
    super.key,
    required this.controller,
    required this.startedTime,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TasksController());

    String format = controller.getTimeAgo(startedTime ?? DateTime.now());

    return CustomContainer(
      padding: const EdgeInsets.all(16),
      conColor: redColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning, color: whiteColor, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Task in Dispute",
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                  color: whiteColor,
                ),
                CustomText(
                  "This task is currently under review.\nDispute started ${format}",
                  fontSize: 14,
                  color: whiteColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
