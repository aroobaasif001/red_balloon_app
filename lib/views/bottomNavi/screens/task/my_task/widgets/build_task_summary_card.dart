import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';

/// TASK SUMMARY CARD: title, price, location, posted time
Widget buildTaskSummaryCard(InProgressTaskController controller) {
  return Obx(
    () => CustomContainer(
      width: double.infinity,
      conColor: white2Color,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                controller.taskTitle.value,
                fontSize: 15,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
              const SizedBox(height: 8),
              CustomText(
                'SAR ${controller.taskPrice.value} 	 ${controller.taskLocation.value}',
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
                color: rbtxColor,
              ),
              const SizedBox(height: 4),
              CustomText(
                'Posted ${controller.postedAgo.value}',
                fontSize: 12,
                color: walletInfoTextColor,
                fontWeight: FontVariant.regular,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
