import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/leave_feedback_controller.dart';

class LeaveFeedbackRatingRow extends StatelessWidget {
  final LeaveFeedbackController controller;

  const LeaveFeedbackRatingRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          final isFilled = controller.rating.value >= starIndex;
          return GestureDetector(
            onTap: () => controller.setRating(starIndex),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(
                Icons.star,
                size: 32,
                color: isFilled ? yellow : fundCardBorderColor,
              ),
            ),
          );
        }),
      ),
    );
  }
}
