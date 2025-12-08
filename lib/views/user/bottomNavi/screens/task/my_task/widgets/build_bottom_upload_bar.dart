import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';
import '../tabs/leave_feedback.dart';
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
        const SizedBox(height: 10),
        Obx(
          () {
            final bool hasProof = controller.hasProof.value;
            final bool isLoading = controller.isCheckingProof.value;

            return InkWell(
              // Disable tap when proof exists or when loading
              onTap: (!hasProof && !isLoading)
                  ? () {
                      Get.to(() => UploadProof(
                            taskId: taskId ?? '',
                            taskTitle: taskTitle ?? 'Task',
                            price: price ?? '0',
                          ));
                    }
                  : null,
              child: CustomContainer(
                height: 52,
                width: double.infinity,
                conColor: hasProof ? Colors.grey : redColor,
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
          },
        ),
      ],
    ),
  );
}
