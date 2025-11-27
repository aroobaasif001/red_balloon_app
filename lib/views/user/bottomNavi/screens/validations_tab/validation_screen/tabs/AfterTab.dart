import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../../utils/dialog_helpers.dart';

class AfterTab extends StatelessWidget {
  const AfterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// ---------------------------
          /// IMAGE (289 x 291)
          /// ---------------------------
          CustomContainer(
            height: 289,
            width: 291,
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/Rectangle 34625290.png", // replace with your actual image
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 25),

          /// ---------------------------
          /// RED INFO BOX
          /// ---------------------------
          CustomContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            borderRadius: BorderRadius.circular(14),
            conColor: redColor,
            child: CustomText(
              "Helper uploaded proof of completion.\n"
              "Review if the task was done properly.",
              fontSize: 15,
              textAlign: TextAlign.center,
              fontWeight: FontVariant.medium,
              color: whiteColor,
            ),
          ),

          const SizedBox(height: 20),

          /// ---------------------------
          /// BUTTON ROW
          /// ---------------------------
          Row(
            children: [
              /// ❌ SUPPORT USER BUTTON
              Flexible(
                child: CustomButton(
                  label: "Support User",
                  height: 50,
                  fontSize: 14, // slightly smaller = no overflow
                  fontWeight: FontVariant.semiBold,
                  bgColor: redColor,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () {
                    DialogHelpers.showPaymentSuccessDialog(
                      context: context,
                      showButton: false,
                    );
                  },
                  leading: const Icon(Icons.close, color: whiteColor, size: 18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // prevents overflow
                ),
              ),

              const SizedBox(width: 14),

              /// ✔ SUPPORT PROVIDER BUTTON
              Flexible(
                child: CustomButton(
                  label: "Support Provider",
                  height: 50,
                  fontSize: 14, // same as above
                  fontWeight: FontVariant.semiBold,
                  bgColor: redColor,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () {
                    DialogHelpers.showPaymentSuccessDialog(
                      context: context,
                      showButton: false,
                    );
                  },
                  leading: const Icon(Icons.check, color: whiteColor, size: 18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // prevents overflow
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// ---------------------------
          /// FOOTNOTE
          /// ---------------------------
          CustomText(
            "Your vote must match community majority to earn rewards.",
            fontSize: 13,
            textAlign: TextAlign.center,
            fontWeight: FontVariant.regular,
            color: Colors.grey.shade600,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
