import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';
import '../tabs/leave_feedback.dart';
import '../tabs/upload_proof.dart';

/// BOTTOM BAR: helper text + Upload Proof button
Widget buildBottomUploadBar(
  BuildContext context,
  InProgressTaskController controller, {
  String? taskId,
  String? taskTitle,
  String? price,
}) {
  return CustomContainer(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
    conColor: whiteColor,
    boxShadow: [
      BoxShadow(color: Color(0x14000000), offset: Offset(0, -2), blurRadius: 8),
    ],
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomText(
          'Complete the task and upload proof.',
          fontSize: 13,
          color: walletGrey600Color,
          fontWeight: FontVariant.regular,
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            controller.isSubmitted == false
                ? Get.to(() => UploadProof(
                      taskId: taskId ?? '',
                      taskTitle: taskTitle ?? 'Task',
                      price: price ?? '0',
                    ))
                : Get.to(() => LeaveFeedback());
          },
          child: CustomContainer(
            height: 52,
            width: double.infinity,
            conColor: redColor,
            borderRadius: BorderRadius.circular(14),
            alignment: Alignment.center,
            child: Obx(
              () => CustomText(
                controller.isSubmitted == false
                    ? 'Upload Proof'
                    : 'Mark as Complete',
                fontSize: 16,
                fontWeight: FontVariant.semiBold,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
