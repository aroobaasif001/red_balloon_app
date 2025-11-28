import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminFilterChip({
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      borderRadius: BorderRadius.circular(9999),
      conColor: selected ? redColor : whiteColor,
      border: selected ? null : Border.all(color: beforecolor, width: 1),
      child: CustomText(
        label,
        fontSize: 14,
        fontWeight: FontVariant.semiBold,
        color: selected ? whiteColor : walletGrey600Color,
      ),
    ),
  );
}
