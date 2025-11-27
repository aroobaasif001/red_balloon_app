import 'package:flutter/material.dart';

import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';

class RatingRow extends StatelessWidget {
  const RatingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: yellow, size: 16),
        SizedBox(width: 4),
        CustomText(
          '4.9',
          fontSize: 13,
          fontWeight: FontVariant.semiBold,
          color: textcolord,
        ),
        SizedBox(width: 6),
        CustomText(
          '•  Requester',
          fontSize: 12,
          color: walletInfoTextColor,
          fontWeight: FontVariant.regular,
        ),
      ],
    );
  }
}
