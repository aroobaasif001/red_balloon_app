import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminTaskCard(
  BuildContext context, {
  required String iconPath,
  required String title,
  required String description,
  required String timeAgo,
}) {
  return CustomContainer(
    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 2),
    conColor: whiteColor,
    borderRadius: BorderRadius.circular(16),
    border: Border(
      bottom: BorderSide(color: bordercol, width: 1),
      right: BorderSide(color: bordercol, width: 1),
      left: BorderSide(color: bordercol, width: 1),
    ),     boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 1,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              height: 48,
              width: 48,
              borderRadius: BorderRadius.circular(12),

              conColor: pinkColor,
              child: Center(
                child: Image.asset(
                  iconPath,
                  height: 20,
                  width: 20,
                  color: redColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 16,
                    fontWeight: FontVariant.bold,
                    color: black4Color,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    description,
                    fontSize: 14,
                    fontWeight: FontVariant.regular,
                    color: walletGrey600Color,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: walletTransactionDescColor,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        timeAgo,
                        fontSize: 12,
                        fontWeight: FontVariant.regular,
                        color: walletTransactionDescColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  CustomContainer(
                    height: 40,
                    borderRadius: BorderRadius.circular(12),
                    conColor: redColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomText(
                          'View Details',
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
