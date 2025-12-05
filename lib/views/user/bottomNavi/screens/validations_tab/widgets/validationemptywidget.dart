import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ValidationEmptyWidget extends StatelessWidget {
  const ValidationEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 100),

          /// ICON
          CustomContainer(
            height: 128,
            width: 128,
            borderRadius: BorderRadius.circular(100),
            conColor: balanceconbgColor,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/icons/balanceicon.png",
              height: 60,
              width: 75,
            ),
          ),

          const SizedBox(height: 30),

          /// TITLE
          CustomText(
            "No Validations Pending\nRight Now.",
            fontSize: 24,
            textAlign: TextAlign.center,
            fontWeight: FontVariant.bold,
            fontType: AppFont.montserrat,
            color: grey50Color,
          ),

          const SizedBox(height: 12),

          /// SUBTITLE
          CustomText(
            "When community reviews become\navailable, you'll see them here.",
            fontSize: 16,
            textAlign: TextAlign.center,
            fontWeight: FontVariant.regular,
            fontType: AppFont.montserrat,
            color: txColor,
          ),

          const SizedBox(height: 40),

          /// BUTTON
          CustomButton(
            label: "Refresh Validation Pool",
            onPressed: () {},
            height: 55,
            fontSize: 18,
            width: 320,
            bgColor: redColor,
            borderRadius: BorderRadius.circular(14),
          ),

          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
