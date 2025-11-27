import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../bottom_navi_screen.dart';
import '../controller/leave_feedback_controller.dart';
import '../my_task_screen.dart';
import '../widgets/leave_feedback_rating_row.dart';
import '../widgets/leave_feedback_review_field.dart';
import '../widgets/leave_feedback_task_card.dart';

class LeaveFeedback extends StatelessWidget {
  const LeaveFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    final LeaveFeedbackController controller = Get.put(
      LeaveFeedbackController(),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    // height: 250,
                    width: 283,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Title & subtitle
              const CustomText(
                'Leave Feedback',
                fontSize: 20,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
              const SizedBox(height: 6),
              const CustomText(
                'Your feedback helps build a trusted community.',
                fontSize: 13,
                color: walletGrey600Color,
                fontWeight: FontVariant.regular,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Task summary card (dynamic)
              LeaveFeedbackTaskCard(controller: controller),

              const SizedBox(height: 32),

              // Rating title
              const CustomText(
                'How was your experience?',
                fontSize: 16,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
              const SizedBox(height: 16),

              // Stars row (interactive with GetX)
              LeaveFeedbackRatingRow(controller: controller),
              const SizedBox(height: 8),
              const CustomText(
                'Tap to rate',
                fontSize: 13,
                color: walletGrey600Color,
              ),

              const SizedBox(height: 28),

              // Review field (dynamic length + controller)
              LeaveFeedbackReviewField(controller: controller),

              const SizedBox(height: 28),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.offAll(() => MyTaskScreen());
                      },
                      child: CustomContainer(
                        height: 48,
                        borderRadius: BorderRadius.circular(24),
                        conColor: whiteColor,
                        border: Border.all(color: fundCardBorderColor),
                        alignment: Alignment.center,
                        child: const CustomText(
                          'Skip',
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: walletGrey700Color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.offAll(() => MyTaskScreen());
                      },
                      child: CustomContainer(
                        height: 48,
                        borderRadius: BorderRadius.circular(24),
                        conColor: redColor,
                        alignment: Alignment.center,
                        child: const CustomText(
                          'Submit Feedback',
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
