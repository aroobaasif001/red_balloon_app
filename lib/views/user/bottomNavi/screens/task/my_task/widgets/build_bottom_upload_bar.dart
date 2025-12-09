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
        Obx(
          () => CustomText(
            controller.hasProof.value
                ? 'Proof uploaded. Mark task as complete to proceed.'
                : 'Complete the task and upload proof.',
            fontSize: 13,
            color: walletGrey600Color,
            fontWeight: FontVariant.regular,
            textAlign: TextAlign.center,
          ),
        ),
        Obx(() {
          final bool hasProof = controller.hasProof.value;
          final bool isLoading = controller.isCheckingProof.value;
          final bool helperReq = controller.helperHelpRequested.value;
          final bool requesterReq = controller.requesterHelpRequested.value;

          final bool isDispute = helperReq || requesterReq;
          final bool isDisabled = hasProof || isLoading || isDispute;

          return InkWell(
            onTap: !isDisabled
                ? () {
                    Get.to(
                      () => UploadProof(
                        taskId: taskId ?? '',
                        taskTitle: taskTitle ?? 'Task',
                        price: price ?? '0',
                      ),
                    );
                  }
                : null,
            child: CustomContainer(
              height: 52,
              width: double.infinity,
              conColor: isDisabled ? Colors.grey : redColor,
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
                      isDispute
                          ? 'Dispute in Progress'
                          : (hasProof ? 'Mark as Complete' : 'Upload Proof'),
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
                    DialogHelpers().showSupportHelpSheet(
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
              conColor: helperReq ? Colors.grey : redColor,
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
