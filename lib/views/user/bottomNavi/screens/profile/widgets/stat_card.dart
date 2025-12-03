import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class StatCard extends StatelessWidget {
  final String number;
  final String label;
  final String iconPath;

  const StatCard({
    required this.number,
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      conColor: white2Color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: walletBlackColor.withOpacity(0.25),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        children: [
          /// -------- FIRST ROW ---------
          Row(
            children: [
              Image.asset(iconPath, height: 40, width: 40),

              const SizedBox(width: 10),

              Expanded(
                child: CustomText(
                  label,
                  fontSize: 18,
                  fontWeight: FontVariant.medium,
                  color: blackColor,
                ),
              ),

              Row(
                children: [
                  CustomText(
                    'SAR',
                    fontSize: 18,
                    fontWeight: FontVariant.regular,
                    color: blackColor,
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    number,
                    fontSize: 18,
                    fontWeight: FontVariant.regular,
                    color: blackColor,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// -------- SECOND ROW (STATIC FOR NOW) ---------
          Row(
            children: [
              Image.asset('assets/icons/image 49.png', height: 40, width: 40),

              const SizedBox(width: 10),

              Expanded(
                child: CustomText(
                  "Pro Performer", // <-- CHANGE HERE
                  fontSize: 18,
                  fontWeight: FontVariant.medium,
                  color: blackColor,
                ),
              ),

              Row(
                children: [
                  CustomText(
                    "SAR", // <-- CHANGE HERE
                    fontSize: 18,
                    fontWeight: FontVariant.regular,
                    color: blackColor,
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    "100", // <-- CHANGE HERE
                    fontSize: 18,
                    fontWeight: FontVariant.regular,
                    color: blackColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
