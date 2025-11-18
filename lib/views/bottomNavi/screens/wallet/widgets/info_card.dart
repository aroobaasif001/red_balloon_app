import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

class InfoCard extends StatelessWidget {
  final String message;
  final String linkText;
  final VoidCallback onLinkTap;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  InfoCard({
    super.key,
    required this.message,
    required this.linkText,
    required this.onLinkTap,
    this.borderColor = walletInfoBorderColor,
    this.backgroundColor = walletInfoBgColor,
    this.iconColor = grey4Color,
    this.textColor = walletInfoTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 73,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      conColor: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor),
      child: Row(
        children: [
          Image(
            height: 24,
            width: 24,
            color: iconColor,
            image: AssetImage('assets/icons/help.png'), // 👈 important
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: message,
                    style: TextStyle(color: textColor, fontSize: 13),
                  ),
                  TextSpan(
                    text: ' $linkText',
                    style: TextStyle(
                      color: walletPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
