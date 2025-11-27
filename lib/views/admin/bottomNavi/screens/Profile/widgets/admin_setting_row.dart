import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminSettingsRow({
  required String label,
  required Widget trailing,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: 16,
          fontWeight: FontVariant.medium,
          color: black4Color,
        ),
        trailing,
      ],
    ),
  );
}
