import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminFilterChip2(String label) {
  return CustomContainer(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    borderRadius: BorderRadius.circular(9999),
    conColor: whiteColor,
    border: Border.all(color: beforecolor, width: 1),
    child: CustomText(
      label,
      fontSize: 14,
      fontWeight: FontVariant.semiBold,
      color: walletGrey600Color,
    ),
  );
}
