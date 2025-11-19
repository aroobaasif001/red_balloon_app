import 'package:flutter/material.dart';

import '../../../../../custom_widgets/custom_container.dart';
import '../../../../../custom_widgets/customtext.dart';
import '../../../../../utils/colors.dart';

class StatCard extends StatelessWidget {
  final String number;
  final String label;

  const StatCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(20),
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
          CustomText(
            number,
            fontSize: 22,
            fontWeight: FontVariant.bold,
            color: blackColor,
          ),
          const SizedBox(height: 4),
          CustomText(
            label,
            fontSize: 14,
            fontWeight: FontVariant.regular,
            color: blackColor,
          ),
        ],
      ),
    );
  }
}
