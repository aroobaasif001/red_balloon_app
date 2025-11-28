import 'package:flutter/material.dart';

import '../../../../../../../utils/colors.dart';

class CustomRatingStars extends StatelessWidget {
  final int stars;

  const CustomRatingStars({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: yellow,
          size: 20,
        ),
      ),
    );
  }
}
