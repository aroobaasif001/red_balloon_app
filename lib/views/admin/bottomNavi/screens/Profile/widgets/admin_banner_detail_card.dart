import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminBannerDetailsCard(
  BuildContext context, {
  required ValueChanged<String> onTitleChanged,
  required ValueChanged<String> onSubtitleChanged,
  required ValueChanged<String> onCtaChanged,
}) {
  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: borderColor, width: 1),
  );

  return CustomContainer(
    padding: const EdgeInsets.all(16),
    conColor: whiteColor,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: beforecolor),

    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.25),
        blurRadius: 1,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          'Banner Details',
          fontSize: 14,
          fontWeight: FontVariant.semiBold,
          color: blackColor,
        ),
        const SizedBox(height: 16),
        const CustomText(
          'Banner Title (Optional)',
          fontSize: 12,
          fontWeight: FontVariant.semiBold,
          color: walletGrey600Color,
        ),
        const SizedBox(height: 6),
        TextField(
          onChanged: onTitleChanged,
          decoration: InputDecoration(
            hintText: 'Enter banner title',
            hintStyle: const TextStyle(fontSize: 13, color: hintColor),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: redColor, width: 1.2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const CustomText(
          'Subtitle (Optional)',
          fontSize: 12,
          fontWeight: FontVariant.semiBold,
          color: walletGrey600Color,
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter subtitle',
            hintStyle: const TextStyle(fontSize: 13, color: hintColor),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: redColor, width: 1.2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const CustomText(
          'CTA Text (Optional)',
          fontSize: 12,
          fontWeight: FontVariant.semiBold,
          color: walletGrey600Color,
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: 'e.g., Shop Now, Learn More',
            hintStyle: const TextStyle(fontSize: 13, color: hintColor),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: redColor, width: 1.2),
            ),
          ),
        ),
      ],
    ),
  );
}
