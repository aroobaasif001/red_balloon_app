import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../controller/upload_proof_controller.dart';

Widget buildTaskCard(UploadProofController controller) {
  return CustomContainer(
    conColor: white2Color,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.all(14),
    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.25),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ],
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/sofa.png',
            height: 60,
            width: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  controller.taskTitle.value,
                  fontSize: 14,
                  fontWeight: FontVariant.semiBold,
                  color: textcolord,
                ),
                const SizedBox(height: 4),
                CustomText(
                  controller.taskCode.value,
                  fontSize: 12,
                  color: walletInfoTextColor,
                  fontWeight: FontVariant.regular,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topRight,
                  child: CustomText(
                    '${controller.taskPrice.value} SAR',
                    fontSize: 14,
                    fontWeight: FontVariant.bold,
                    color: redColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
