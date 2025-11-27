import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminInfoRow({
  required icon,
  required String label,
  required String value,
  bool isEmphasized = false,
  bool isImage = false,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      isImage == false
          ? Icon(icon, size: 18, color: redColor)
          : Image.asset(icon, height: 18, width: 18, color: redColor),
      const SizedBox(width: 12),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              label,
              fontSize: 14,
              fontWeight: FontVariant.regular,
              color: walletGrey600Color,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  value,
                  fontSize: 14,
                  fontWeight: isEmphasized
                      ? FontVariant.bold
                      : FontVariant.medium,
                  color: isEmphasized ? redColor : black4Color,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
