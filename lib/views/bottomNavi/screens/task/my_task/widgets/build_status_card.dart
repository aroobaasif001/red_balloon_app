import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';

/// STATUS CARD: In Progress chip + distance / ETA text
Widget buildStatusCard(InProgressTaskController controller) {
  return Obx(
    () => CustomContainer(
      width: double.infinity,
      conColor: white2Color,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            conColor: appbard,
            borderRadius: BorderRadius.circular(20),
            child: CustomText(
              controller.status.value,
              fontSize: 13,
              fontWeight: FontVariant.semiBold,
              color: redColor,
            ),
          ),
          const SizedBox(height: 10),
          CustomText(
            '${controller.distance.value} 	 ${controller.eta.value}',
            fontSize: 15,
            color: walletGrey600Color,
            fontWeight: FontVariant.regular,
          ),
          const SizedBox(height: 10),
          const LinearProgressIndicator(
            backgroundColor: appbard,
            color: redColor,
            value: 0.6,
          ),
        ],
      ),
    ),
  );
}
