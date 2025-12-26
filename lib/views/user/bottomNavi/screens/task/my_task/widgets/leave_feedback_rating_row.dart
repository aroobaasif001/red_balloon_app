import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/leave_feedback_controller.dart';

class LeaveFeedbackRatingRow extends StatelessWidget {
  final LeaveFeedbackController controller;

  const LeaveFeedbackRatingRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RatingBar.builder(
        initialRating: controller.rating.value,
        minRating: 0.5,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 48,
        unratedColor: Colors.grey[300],
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: yellow,
        ),
        onRatingUpdate: (rating) {
          controller.setRating(rating);
        },
      ),
    );
  }
}
