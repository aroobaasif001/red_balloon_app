import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class MenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool hasArrow;
  final bool hasToggle;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleChanged;

  const MenuItem({
    required this.icon,
    required this.label,
    this.hasArrow = false,
    this.hasToggle = false,
    this.onTap,
    this.onToggleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Image.asset(icon, height: 24, width: 24, color: redColor),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                label,
                fontSize: 14,
                fontWeight: FontVariant.regular,
                color: blackColor,
              ),
            ),
            if (hasArrow)
              Icon(Icons.chevron_right, size: 20, color: arrowColor)
            else if (hasToggle)
              Switch(
                value: true,
                onChanged: onToggleChanged ?? (value) {},
                activeColor: redColor,
              ),
          ],
        ),
      ),
    );
  }
}
