import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminBuildSummaryRow2(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: CustomContainer(
          padding: const EdgeInsets.all(14),
          conColor: white2Color,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(color: bordercol, width: 1),
            right: BorderSide(color: bordercol, width: 1),
            left: BorderSide(color: bordercol, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.25),
              blurRadius: 1,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: const Icon(
                  Icons.arrow_downward,
                  color: redColor,
                  size: 25,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Money\nReceived',
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      color: txColor,
                    ),
                    SizedBox(height: 4),
                    CustomText(
                      'SAR 24,234',
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      color: txColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: CustomContainer(
          padding: const EdgeInsets.all(14),
          conColor: white2Color,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(color: bordercol, width: 1),
            right: BorderSide(color: bordercol, width: 1),
            left: BorderSide(color: bordercol, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: blackColor.withOpacity(0.25),
              blurRadius: 1,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: const Icon(
                  Icons.arrow_upward,
                  color: redColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Money\nSend',
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      color: txColor,
                    ),
                    SizedBox(height: 4),
                    CustomText(
                      'SAR 24,234',
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      color: txColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
