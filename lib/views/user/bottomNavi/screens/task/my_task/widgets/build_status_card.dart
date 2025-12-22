import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
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
              (controller.requesterHelpRequested.value || controller.helperHelpRequested.value)
                  ? 'Dispute In Progress'
                  : controller.status.value,
              fontSize: 13,
              fontWeight: FontVariant.semiBold,
              color: redColor,
            ),
          ),
          if (controller.requesterHelpRequested.value || controller.helperHelpRequested.value) ...[
            if (controller.requesterHelpReason.value.isNotEmpty) ...[
              const SizedBox(height: 8),
              CustomText(
                "Requester's Reason:",
                fontWeight: FontVariant.bold,
                fontSize: 13,
                color: redColor,
              ),
              CustomText(
                "${controller.requesterHelpReason.value}: ${controller.requesterHelpDetails.value}",
                fontSize: 13,
                color: walletGrey600Color,
                textAlign: TextAlign.center,
              ),
            ],
          ],
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
