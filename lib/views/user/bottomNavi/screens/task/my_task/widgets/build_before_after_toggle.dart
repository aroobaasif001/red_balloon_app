import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/upload_proof_controller.dart';

Widget buildBeforeAfterToggle(UploadProofController controller) {
  return CustomContainer(
    margin: EdgeInsets.symmetric(horizontal: 40),
    padding: EdgeInsets.all(10),
    conColor: white2Color,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Color(0xff000000).withOpacity(0.25),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ],
    child: Obx(() {
      final isBefore = controller.selectedTab.value == ProofTab.before;
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.selectBefore,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isBefore ? redColor : appbard,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  'BEFORE',
                  fontSize: 14,
                  fontWeight: FontVariant.semiBold,
                  color: isBefore ? whiteColor : walletGrey600Color,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: controller.selectAfter,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isBefore ? appbard : redColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  'AFTER',
                  fontSize: 14,
                  fontWeight: FontVariant.semiBold,
                  color: isBefore ? walletGrey600Color : whiteColor,
                ),
              ),
            ),
          ),
        ],
      );
    }),
  );
}
