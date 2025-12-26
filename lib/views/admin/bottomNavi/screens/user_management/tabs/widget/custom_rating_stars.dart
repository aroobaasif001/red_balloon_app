import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../../../utils/colors.dart';

class CustomRatingStars extends StatelessWidget {
  final double stars;

  const CustomRatingStars({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: stars,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: yellow,
      ),
      itemCount: 5,
      itemSize: 16.0,
      unratedColor: Colors.grey[300],
      direction: Axis.horizontal,
    );
  }
}
