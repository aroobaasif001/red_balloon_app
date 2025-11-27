import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/leave_feedback_controller.dart';

class LeaveFeedbackTaskCard extends StatelessWidget {
  final LeaveFeedbackController controller;

  const LeaveFeedbackTaskCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomContainer(
        width: double.infinity,
        conColor: walletCardBgColor,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(16),
        boxShadow: [
          BoxShadow(
            color: blackColor,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(20),
              conColor: redColor.withOpacity(0.06),
              alignment: Alignment.center,
              child: CustomText(
                controller.initials.value,
                fontSize: 16,
                fontWeight: FontVariant.semiBold,
                color: redColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    controller.taskTitle.value,
                    fontSize: 15,
                    fontWeight: FontVariant.semiBold,
                    color: textcolord,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    'Requester: ${controller.requesterName.value}',
                    fontSize: 12,
                    color: walletGrey700Color,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    'Requester ID: ${controller.requesterId.value}',
                    fontSize: 12,
                    color: walletGrey700Color,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    'Completed ${controller.completedAgo.value}',
                    fontSize: 12,
                    color: walletGrey700Color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
