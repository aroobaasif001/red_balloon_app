import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_disputed_controller.dart';

class TaskSummaryCard extends StatelessWidget {
  final TaskDisputedController controller;

  const TaskSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          spreadRadius: 0,
          blurRadius: 2,
          color: blackColor.withOpacity(0.05),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => CustomText(
                controller.taskTitle.value,
                fontSize: 18,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow("Task ID", controller.taskId.value, false),
            _buildDetailRow("Amount", controller.taskAmount.value, true),
            _buildDetailRow("Category", controller.taskCategory.value, false),
            _buildDetailRow("Date Posted", "Jan 15, 2025", false),
            _buildDetailRow("Date of Issue", "Jan 10, 2025", false),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool? isBold) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            label,
            fontSize: 14,
            color: grey2Color,
            fontWeight: FontVariant.regular,
          ),
          Flexible(
            child: CustomText(
              value,
              fontSize: isBold == false ? 14 : 16,
              fontWeight:
                  isBold == false ? FontVariant.medium : FontVariant.bold,
              color: textcolord,
            ),
          ),
        ],
      ),
    );
  }
}
