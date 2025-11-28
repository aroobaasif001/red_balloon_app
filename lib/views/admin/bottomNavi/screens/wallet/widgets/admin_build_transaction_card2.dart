import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminBuildTransactionCard2(
  BuildContext context, {
  required String typeLabel,
  required String amount,
  required bool isPositive,
  required String name,
  required String role,
  required String time,
}) {
  return CustomContainer(
    padding: const EdgeInsets.all(14),
    conColor: whiteColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 2,
        spreadRadius: 0,
        offset: const Offset(0, 1),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                typeLabel,
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
            ),
            CustomContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              borderRadius: BorderRadius.circular(9999),
              conColor: greenbgColor,
              child: const CustomText(
                'Completed',
                fontSize: 12,
                fontWeight: FontVariant.medium,
                color: greenColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        CustomText(
          amount,
          fontSize: 18,
          fontWeight: FontVariant.bold,
          color: isPositive ? greenColor : redColor,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomContainer(
                  height: 32,
                  width: 32,
                  borderRadius: BorderRadius.circular(9999),
                  conColor: redColor,
                  child: const Center(
                    child: CustomText(
                      'AF',
                      fontSize: 12,
                      fontWeight: FontVariant.semiBold,
                      color: whiteColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      name,
                      fontSize: 12,
                      fontWeight: FontVariant.medium,
                      color: textcolord,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      role,
                      fontSize: 12,
                      fontWeight: FontVariant.regular,
                      color: txColor,
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: CustomText(
                time,
                fontSize: 12,
                fontWeight: FontVariant.regular,
                color: txColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
