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
    border: Border.all(color: bordercol),
    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.09),
        blurRadius: 1,
        spreadRadius: 0,
        offset: const Offset(0, 1),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Title and Status
        Row(
          children: [
            Expanded(
              child: CustomText(
                typeLabel,
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
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
        // Amount
        CustomText(
          amount,
          fontSize: 18,
          fontWeight: FontVariant.bold,
          color: isPositive ? greenColor : redColor,
        ),
        const SizedBox(height: 12),
        // Bottom Row: User Info and Time
        Row(
          children: [
            // Left side: Avatar + User details (Takes most space)
            Expanded(
              flex: 5, 
              child: Row(
                children: [
                  CustomContainer(
                    height: 32,
                    width: 32,
                    borderRadius: BorderRadius.circular(9999),
                    conColor: redColor,
                    child: const Center(
                      child: CustomText(
                        'AF',
                        fontSize: 10,
                        fontWeight: FontVariant.semiBold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          name,
                          fontSize: 12,
                          fontWeight: FontVariant.medium,
                          color: textcolord,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        CustomText(
                          role,
                          fontSize: 11,
                          fontWeight: FontVariant.regular,
                          color: txColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            // Right side: Time (Takes minimal needed space)
            Flexible(
              flex: 3,
              child: CustomText(
                time,
                fontSize: 11,
                fontWeight: FontVariant.regular,
                color: txColor,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
