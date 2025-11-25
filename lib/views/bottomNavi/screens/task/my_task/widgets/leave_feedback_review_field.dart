import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/leave_feedback_controller.dart';

class LeaveFeedbackReviewField extends StatelessWidget {
  final LeaveFeedbackController controller;

  const LeaveFeedbackReviewField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            'Write a short review (optional)',
            fontSize: 14,
            fontWeight: FontVariant.semiBold,
            color: textcolord,
          ),
        ),
        const SizedBox(height: 10),
        CustomContainer(
          conColor: whiteColor,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: CustomTextField(
            maxLines: 5,
            controller: controller.reviewController,
            hintText:
                'Add any comments about your experience with this requester...',
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: CustomText(
            '${controller.reviewLength}/250 characters',
            fontSize: 11,
            color: walletGrey500Color,
          ),
        ),
      ],
    );
  }
}
