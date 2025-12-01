import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class admin_home_morning_widget extends StatelessWidget {
  final String iconPath;
  final String greeting;
  const admin_home_morning_widget({
    super.key,
    this.iconPath = 'assets/icons/sun.png',
    this.greeting = 'Good Morning',
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      height: 152,
      conColor: redColor,
      borderRadius: BorderRadius.circular(16),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      boxShadow: [
        BoxShadow(
          spreadRadius: 0,
          offset: Offset(0, 4),
          blurRadius: 1,
          color: blackColor.withOpacity(0.25),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(iconPath, height: 32),
              SizedBox(width: 25),
              Expanded(
                child: CustomText(
                  '${greeting}, Admin!',
                  color: whiteColor,
                  fontWeight: FontVariant.bold,
                  fontSize: 24,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: CustomText(
              'Here\'s what needs your attention today',
              color: whiteColor,
              fontWeight: FontVariant.regular,
              fontSize: 14,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
