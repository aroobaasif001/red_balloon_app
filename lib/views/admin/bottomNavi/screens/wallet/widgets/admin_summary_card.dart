import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminSummaryCard(
  BuildContext context, {
  VoidCallback? onTap,
  required icon,
  required Color iconBg,
  required String title,
  required String amount,
  bool isIcon = true,
}) {
  return InkWell(
    onTap: onTap,
    child: CustomContainer(
      padding: const EdgeInsets.all(14),
      conColor: white2Color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.25),
          blurRadius: 2.8,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            height: 40,
            width: 40,
            borderRadius: BorderRadius.circular(12),
            conColor: iconBg,
            child: isIcon
                ? Icon(icon, color: redColor, size: 22)
                : Center(
                    child: Image.asset(
                      icon,
                      color: redColor,
                      height: 18,
                      width: 18,
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: 16,
                  fontWeight: FontVariant.medium,
                  color: txColor,
                ),
                const SizedBox(height: 4),
                CustomText(
                  amount,
                  fontSize: 16,
                  fontWeight: FontVariant.semiBold,
                  color: txColor,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
