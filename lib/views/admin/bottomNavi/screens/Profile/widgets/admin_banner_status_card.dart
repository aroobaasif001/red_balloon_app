import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminBannerStatusCard(
  BuildContext context, {
  required bool isActive,
  required ValueChanged<bool> onToggle,
}) {
  return CustomContainer(
    padding: const EdgeInsets.all(16),
    conColor: whiteColor,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: beforecolor, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 2,
        spreadRadius: 0,
        offset: const Offset(0, 1),
      ),
    ],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CustomText(
              'Banner Status',
              fontSize: 14,
              fontWeight: FontVariant.semiBold,
              color: blackColor,
            ),
            SizedBox(height: 4),
            CustomText(
              'Enable or disable this banner',
              fontSize: 12,
              fontWeight: FontVariant.regular,
              color: walletGrey600Color,
            ),
          ],
        ),
        Switch(
          value: isActive,
          onChanged: onToggle,
          activeTrackColor: redColor,
          activeThumbColor: whiteColor,
          inactiveTrackColor: whiteColor,
          inactiveThumbColor: redColor,
        ),
      ],
    ),
  );
}
