import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../../utils/colors.dart';

class KeyValueRow extends StatelessWidget {
  final String title;
  final String value;

  const KeyValueRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            title,
            fontSize: 12,
            fontWeight: FontVariant.regular,
            color: walletGrey600Color,
          ),
          CustomText(
            value,
            fontSize: 14,
            fontWeight: FontVariant.bold,
            color: black4Color,
          ),
        ],
      ),
    );
  }
}
