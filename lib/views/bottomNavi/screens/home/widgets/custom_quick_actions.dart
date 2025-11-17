import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomQuickActions extends StatelessWidget {
  const CustomQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    debugPrint("Create Task tapped");
                  },
                  child: CustomContainer(
                    height: 70,
                    width: 70,
                    conColor: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                    child: Ink(
                      decoration: BoxDecoration(color: redColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/create_task.png",
                          width: 26,
                          height: 26,
                          fit: BoxFit.contain,
                          color: redColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const CustomText("Create Task", fontSize: 11, color: grey1Color),
            ],
          ),
        ),

        Expanded(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    debugPrint("Wallet tapped");
                  },
                  child: CustomContainer(
                    height: 70,
                    width: 70,
                    conColor: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                    child: Ink(
                      decoration: BoxDecoration(color: redColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/Wallet.png",
                          width: 26,
                          height: 26,
                          fit: BoxFit.contain,
                          color: redColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const CustomText("Wallet", fontSize: 11, color: grey1Color),
            ],
          ),
        ),

        Expanded(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    debugPrint("Validation tapped");
                  },
                  child: CustomContainer(
                    height: 70,
                    width: 70,
                    conColor: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                    child: Ink(
                      decoration: BoxDecoration(color: redColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/Validation.png",
                          width: 26,
                          height: 26,
                          fit: BoxFit.contain,
                          color: redColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const CustomText("Validate", fontSize: 11, color: grey1Color),
            ],
          ),
        ),

        Expanded(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    debugPrint("Redeem tapped");
                  },
                  child: CustomContainer(
                    height: 70,
                    width: 70,
                    conColor: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                    child: Ink(
                      decoration: BoxDecoration(color: redColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Center(
                        child: Image.asset(
                          "assets/icons/Redeem.png",
                          width: 26,
                          height: 26,
                          fit: BoxFit.contain,
                          color: redColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const CustomText("Redeem", fontSize: 11, color: grey1Color),
            ],
          ),
        ),
      ],
    );
  }
}
