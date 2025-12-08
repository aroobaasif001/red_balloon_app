import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/controller/validation_screen_controller.dart';

import '../../../../../../../utils/dialog_helpers.dart';

class AfterTab extends StatelessWidget {
  final bool isTask;
  const AfterTab({super.key, required this.isTask});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// -------------------------------
          /// 📸 IMAGE (289 × 291)
          /// -------------------------------
          CustomContainer(
            height: 289,
            width: 291,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(15),
            conColor: whiteColor,
            alignment: Alignment.center,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.25),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
            child: CustomContainer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/Rectangle 34625290.png", // <-- replace with your actual image
                  height: 289,
                  width: 291,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: isTask == false ? 20 : 0),

          /// -------------------------------
          /// RED DESCRIPTION BOX
          /// -------------------------------
          isTask == false
              ? CustomContainer(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                  conColor: redColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 12,
                  ),
                  alignment: Alignment.center,
                  child: CustomText(
                    "Helper uploaded proof of completion.\n"
                    "Review if the task appears done properly.",
                    fontSize: 15,
                    textAlign: TextAlign.center,
                    fontWeight: FontVariant.semiBold,
                    color: whiteColor,
                  ),
                )
              : CustomContainer(),

          SizedBox(height: isTask == false ? 20 : 0),

          /// -------------------------------
          /// BUTTONS ROW
          /// -------------------------------
          isTask == false
              ? Row(
                  children: [
                    /// ❌ SUPPORT HELPER BUTTON
                    Flexible(
                      child: CustomButton(
                        label: "Support Helper",
                        height: 50,
                        fontSize: 14,
                        fontWeight: FontVariant.semiBold,
                        bgColor: redColor,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () {
                          DialogHelpers.showVoteConfirmationDialog(
                            context: context,
                            voteType: 'helper',
                            onConfirm: () async {
                              final controller = Get.find<ValidationScreenController>();
                              await controller.submitVote('helper');
                            },
                          );
                        },
                        leading: const Icon(
                          Icons.close,
                          color: whiteColor,
                          size: 18,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    /// ✔ SUPPORT REQUESTER BUTTON
                    Flexible(
                      child: CustomButton(
                        label: "Support Requester",
                        height: 50,
                        fontSize: 14,
                        fontWeight: FontVariant.semiBold,
                        bgColor: redColor,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () {
                          DialogHelpers.showVoteConfirmationDialog(
                            context: context,
                            voteType: 'requester',
                            onConfirm: () async {
                              final controller = Get.find<ValidationScreenController>();
                              await controller.submitVote('requester');
                            },
                          );
                        },
                        leading: const Icon(
                          Icons.check,
                          color: whiteColor,
                          size: 18,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                      ),
                    ),
                  ],
                )
              : CustomContainer(),

          const SizedBox(height: 25),

          /// -------------------------------
          /// FOOTER NOTE
          /// -------------------------------
          CustomText(
            "Your vote must match community majority to earn\nrewards.",
            fontSize: 14,
            fontWeight: FontVariant.regular,
            textAlign: TextAlign.center,
            color: grey5Color,
          ),
          SizedBox(height: 40),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
