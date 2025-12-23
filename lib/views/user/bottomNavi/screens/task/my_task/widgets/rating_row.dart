import 'package:flutter/material.dart';

import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';

class RatingRow extends StatelessWidget {
  final double rating;
  final String role;
  
  const RatingRow({
    super.key,
    this.rating = 4.9,
    this.role = 'Provider',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: yellow, size: 16),
        const SizedBox(width: 4),
        CustomText(
          rating.toStringAsFixed(1),
          fontSize: 13,
          fontWeight: FontVariant.semiBold,
          color: textcolord,
        ),
        const SizedBox(width: 6),
        CustomText(
          '•  $role',
          fontSize: 12,
          color: walletInfoTextColor,
          fontWeight: FontVariant.regular,
        ),
      ],
    );
  }
}
