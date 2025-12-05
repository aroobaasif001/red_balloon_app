import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/upload_proof_controller.dart';

/// Bottom Submit Proof button
Widget buildSubmitButton(BuildContext context) {
  final controller = Get.find<UploadProofController>();
  
  return SizedBox(
    width: double.infinity,
    child: Obx(() {
      final isSubmitting = controller.isSubmitting.value;
      
      return InkWell(
        onTap: isSubmitting ? null : () => controller.submitProof(),
        child: CustomContainer(
          height: 52,
          borderRadius: BorderRadius.circular(14),
          conColor: isSubmitting ? walletGrey600Color : redColor,
          alignment: Alignment.center,
          child: isSubmitting
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: whiteColor,
                    strokeWidth: 2,
                  ),
                )
              : const CustomText(
                  'Submit Proof',
                  fontSize: 16,
                  fontWeight: FontVariant.semiBold,
                  color: whiteColor,
                ),
        ),
      );
    }),
  );
}
