import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';

/// Bottom Submit Proof button
Widget buildSubmitButton(BuildContext context) {
  final controller = Get.find<InProgressTaskController>();
  return SizedBox(
    width: double.infinity,
    child: InkWell(
      onTap: () {
        Get.back();
        controller.isSubmitted.value = true;
        DialogHelpers.showPaymentSuccessDialog(
          context: context,
          message: 'Proof has been uploaded\nsuccessfully!',
          showButton: false,
        );
      },
      child: CustomContainer(
        height: 52,
        borderRadius: BorderRadius.circular(14),
        conColor: redColor,
        alignment: Alignment.center,
        child: const CustomText(
          'Submit Proof',
          fontSize: 16,
          fontWeight: FontVariant.semiBold,
          color: whiteColor,
        ),
      ),
    ),
  );
}
