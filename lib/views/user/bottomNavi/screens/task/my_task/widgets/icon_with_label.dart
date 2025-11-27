import 'package:flutter/material.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomContainer(
          shape: BoxShape.circle,
          conColor: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: walletInfoTextColor, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        CustomText(
          label,
          fontSize: 13,
          color: walletGrey600Color,
          fontWeight: FontVariant.regular,
        ),
      ],
    );
  }
}
