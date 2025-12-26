import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../utils/colors.dart';

class CustomTag extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;

  const CustomTag({
    super.key,
    required this.title,
    this.bgColor = iconBg6,
    this.textColor = redColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      conColor: bgColor,
      borderRadius: BorderRadius.circular(30),
      child: CustomText(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
