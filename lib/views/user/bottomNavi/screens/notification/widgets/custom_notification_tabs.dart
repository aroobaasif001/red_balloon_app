import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomNotificationTabs extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onAllTap;
  final VoidCallback onOffersTap;
  final VoidCallback onValidationTap;

  const CustomNotificationTabs({
    super.key,
    required this.selectedIndex,
    required this.onAllTap,
    required this.onOffersTap,
    required this.onValidationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ------------------- All -------------------
        GestureDetector(
          onTap: onAllTap,
          child: CustomContainer(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            conColor: selectedIndex == 0 ? redColor : white1Color,
            borderRadius: selectedIndex == 0
                ? BorderRadius.circular(15)
                : BorderRadius.circular(20),
            child: Center(
              child: CustomText(
                'All',
                color: selectedIndex == 0 ? whiteColor : blackColor,
                fontWeight: FontVariant.regular,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // ------------------- Offers -------------------
        GestureDetector(
          onTap: onOffersTap,
          child: CustomContainer(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            conColor: selectedIndex == 1 ? redColor : white1Color,
            borderRadius: selectedIndex == 1
                ? BorderRadius.circular(15)
                : BorderRadius.circular(20),
            child: CustomText(
              'Offers',
              color: selectedIndex == 1 ? whiteColor : blackColor,
              fontWeight: FontVariant.regular,
            ),
          ),
        ),

        const SizedBox(width: 10),

        // ------------------- Validation Hub -------------------
        GestureDetector(
          onTap: onValidationTap,
          child: CustomContainer(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            conColor: selectedIndex == 2 ? redColor : white1Color,
            borderRadius: selectedIndex == 2
                ? BorderRadius.circular(15)
                : BorderRadius.circular(20),
            child: CustomText(
              'Validation Hub',
              color: selectedIndex == 2 ? whiteColor : blackColor,
              fontWeight: FontVariant.regular,
            ),
          ),
        ),
      ],
    );
  }
}
