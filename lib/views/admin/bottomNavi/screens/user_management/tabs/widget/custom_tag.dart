import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

class CustomTag extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;

  const CustomTag({
    super.key,
    required this.title,
    this.bgColor = const Color(0xffFFE5E5),
    this.textColor = const Color(0xffFF4D4D),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
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
