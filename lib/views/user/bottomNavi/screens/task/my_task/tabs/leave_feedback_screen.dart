import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../../utils/dialog_helpers.dart';

class LeaveFeedbackScreen extends StatelessWidget {
  const LeaveFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,

        /// -------------- OVERFLOW FIX --------------
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 25),

          child: Column(
            children: [
              const SizedBox(height: 80),

              /// ------------------ TOP LOGO ------------------
              Image.asset(
                "assets/appLogo/White Minimalist Jumma Mubarak Instagram Post (2) 1.png",
                height: 95,
              ),

              const SizedBox(height: 15),

              /// ------------------ TITLE ------------------
              const CustomText(
                "Leave Feedback",
                fontSize: 20,
                fontWeight: FontVariant.bold,
              ),

              const SizedBox(height: 6),

              CustomText(
                "Your feedback helps build a trusted community.",
                fontSize: 13,
                color: walletTextGreyColor,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              /// ------------------ TASK CARD ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  conColor:whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  child: Row(
                    children: [
                      /// RED INITIAL
                      CustomContainer(
                        height: 38,
                        width: 38,
                        borderRadius: BorderRadius.circular(100),
                        conColor: redColor.withOpacity(0.15),
                        child: Center(
                          child: CustomText(
                            "AA",
                            fontSize: 14,
                            fontWeight: FontVariant.bold,
                            color: redColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// TEXT BLOCK
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            "Help Move Furniture",
                            fontWeight: FontVariant.semiBold,
                            fontSize: 14,
                          ),

                          const SizedBox(height: 3),

                          CustomText(
                            "Helper: Ahmed Al-Rashid",
                            fontSize: 12,
                            color: timeColor,
                          ),

                          const SizedBox(height: 2),

                          CustomText(
                            "Helper ID: RB-876",
                            fontSize: 12,
                            color: timeColor,
                          ),

                          const SizedBox(height: 2),

                          CustomText(
                            "Completed 2h ago",
                            fontSize: 10,
                            color: walletTextGreyColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// ------------------ EXPERIENCE TITLE ------------------
              const CustomText(
                "How was your experience?",
                fontWeight: FontVariant.semiBold,
                fontSize: 16,
              ),

              const SizedBox(height: 25),

              /// ------------------ STAR RATING ------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return const Image(
                    image: AssetImage('assets/icons/star2.png'),
                    height: 60,
                    width: 39,
                  );
                }),
              ),

              const SizedBox(height: 8),

              const CustomText(
                "Tap to rate",
                fontSize: 13,
                color:blackColor,
              ),

              const SizedBox(height: 25),

              /// ------------------ REVIEW TEXT FIELD ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      "Write a short review (optional)",
                      fontSize: 14,
                      color:blackColor,
                    ),

                    const SizedBox(height: 10),

                    CustomContainer(
                      height: 145,
                      conColor:greyLiteColor,
                      borderRadius: BorderRadius.circular(14),
                      padding: const EdgeInsets.all(12),
                      child: const TextField(
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type your message...",
                          hintStyle: TextStyle(color:walletProgressBgColor),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        "0/250 characters",
                        fontSize: 12,
                        color:walletTransactionDescColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ------------------ BOTTOM BUTTONS ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    /// SKIP
                    Expanded(
                      child: CustomContainer(
                        height: 50,
                        borderRadius: BorderRadius.circular(30),
                        conColor: whiteColor,
                        border: Border.all(color: fundCardBorderColor),
                        child: const Center(
                          child: CustomText(
                            "Skip",
                            fontSize: 15,
                            fontWeight: FontVariant.semiBold,
                            color: lastTextColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// SUBMIT
                    Expanded(
                      child: CustomButton(
                        label: 'Submit Feedback',
                        borderRadius: BorderRadius.circular(30),
                        fontSize: 15,
                        onPressed: () {
                          DialogHelpers().showFeedbackSubmittedDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
