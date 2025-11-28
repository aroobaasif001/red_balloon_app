import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminBuildBottomInfoBar(BuildContext context) {
  return CustomContainer(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    conColor: popupBg,
    borderRadius: BorderRadius.circular(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Icon(Icons.info_outline, size: 16, color: redColor),
        SizedBox(width: 8),
        Expanded(
          child: CustomText(
            'Funds auto-release after validation (48h hold). Manual approval required for disputes and withdrawals.',
            fontSize: 11,
            fontWeight: FontVariant.regular,
            color: lastTextColor,
          ),
        ),
      ],
    ),
  );
}
