import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';
import '../tabs/upload_proof.dart';

/// BOTTOM BAR: helper text + Upload Proof button or Mark as Complete (disabled)
Widget buildBottomUploadBar(
  BuildContext context,
  InProgressTaskController controller, {
  String? taskId,
  String? taskTitle,
  String? price,
  String? taskOwnerUid, // 🔥 Added owner UID
  String? taskImage, // 🔥 Added task image
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
        Obx(() {
          final bool hasProof = controller.hasProof.value;
          final bool isHelper = controller.role.value == 'Requester';

          String message;
          if (hasProof) {
            message = isHelper
                ? 'Proof uploaded. Waiting for requester to mark as complete.'
                : 'Proof uploaded. Mark task as complete to proceed.';
          } else {
            message = isHelper
                ? 'Complete the task and upload proof.'
                : 'Waiting for helper to complete the task and upload proof.';
          }

          return CustomText(
            message,
            fontSize: 13,
            color: walletGrey600Color,
            fontWeight: FontVariant.regular,
            textAlign: TextAlign.center,
          );
        }),
        const SizedBox(height: 5),
        Obx(() {
          final bool hasProof = controller.hasProof.value;
          final bool isLoading = controller.isCheckingProof.value;
          final bool isHelper = controller.role.value == 'Requester';

          // 🔥 UPDATED: Button is disabled if:
          // 1. We are loading
          // 2. We have proof and the user is the helper (they already did their part)
          // 3. We don't have proof and the user is the requester (helper needs to upload first)
          final bool isDisabled = isLoading ||
              (hasProof && isHelper) ||
              (!hasProof && !isHelper);

          return InkWell(
            onTap: !isDisabled
                ? () {
                    if (hasProof) {
                      controller.markTaskAsCompleted(taskId ?? '');
                    } else {
                      Get.to(
                        () => UploadProof(
                          taskId: taskId ?? '',
                          taskTitle: taskTitle ?? 'Task',
                          price: price ?? '0',
                          taskOwnerUid: taskOwnerUid ?? '',
                          taskImage: taskImage,
                        ),
                      );
                    }
                  }
                : null,
            child: CustomContainer(
              height: 52,
              width: double.infinity,
              conColor: isDisabled ? taskstatus3 : redColor,
              borderRadius: BorderRadius.circular(14),
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: whiteColor,
                        strokeWidth: 2,
                      ),
                    )
                  : CustomText(
                      hasProof ? 'Mark as Complete' : 'Upload Proof',
                      fontSize: 16,
                      fontWeight: FontVariant.semiBold,
                      color: whiteColor,
                    ),
            ),
          );
        }),
        const SizedBox(height: 10),
        Obx(() {
          final bool helperReq = controller.helperHelpRequested.value;

          return InkWell(
            onTap: helperReq
                ? null
                : () {
                    DialogHelpers.showSupportHelpSheet(
                      context,
                      firstOptionText: "Requester is not responding",
                      lastOptionText: "Requester unresponsive",
                      onSubmit: (reason, details) {
                        controller.submitHelpRequest(
                          taskId ?? '',
                          reason,
                          details,
                        );
                      },
                    );
                  },
            child: CustomContainer(
              height: 52,
              width: double.infinity,
              conColor: helperReq ? taskstatus3 : redColor,
              borderRadius: BorderRadius.circular(14),
              alignment: Alignment.center,
              child: CustomText(
                helperReq ? "Help Requested" : "Request Help",
                fontSize: 16,
                fontWeight: FontVariant.semiBold,
                color: whiteColor,
              ),
            ),
          );
        }),
      ],
    ),
  );
}
