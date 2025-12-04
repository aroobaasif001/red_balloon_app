import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_completed_controller.dart';

class CompletedTaskSummaryCard extends StatelessWidget {
  final TaskCompletedController controller;

  const CompletedTaskSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          spreadRadius: 0,
          blurRadius: 4,
          color: blackColor.withOpacity(0.25),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Task Summary",
              fontSize: 16,
              fontWeight: FontVariant.bold,
              color: textcolord,
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomText(
                controller.taskTitle.value,
                fontSize: 18,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow("Amount:", controller.taskAmount.value),
            _buildDetailRow("Category:", controller.taskCategory.value),
            _buildDetailRow("Completed Time:", controller.completedTime.value),
            _buildDetailRow("Task ID", controller.taskId.value),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, fontSize: 14, color: grey2Color),
          Flexible(
            child: CustomText(
              value,
              fontSize: 14,
              fontWeight: FontVariant.semiBold,
              color: textcolord,
            ),
          ),
        ],
      ),
    );
  }
}
