import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class HelpSection extends StatelessWidget {
  final String? helpText;
  final String? helpLinkText;
  final String? logoutButtonLabel;
  final Color? helpTextColor;
  final Color? helpLinkColor;
  final double? helpTextFontSize;
  final double? helpLinkFontSize;
  final double? spacingBetweenTexts;
  final double? spacingBeforeButton;
  final VoidCallback? onHelpTap;
  final VoidCallback? onLogoutTap;

  const HelpSection({
    super.key,
    this.helpText = 'Need help? ',
    this.helpLinkText = 'Visit Help Center',
    this.logoutButtonLabel = 'Logout',
    this.helpTextColor,
    this.helpLinkColor,
    this.helpTextFontSize = 13,
    this.helpLinkFontSize = 13,
    this.spacingBetweenTexts = 0,
    this.spacingBeforeButton = 16,
    this.onHelpTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Help Text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              helpText ?? 'Need help? ',
              fontSize: helpTextFontSize ?? 13,
              fontWeight: FontVariant.regular,
              color: helpTextColor ?? blackColor,
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: onHelpTap,
              child: CustomText(
                helpLinkText ?? 'Visit Help Center',
                fontSize: helpLinkFontSize ?? 13,
                fontWeight: FontVariant.semiBold,
                color: helpLinkColor ?? redColor,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(height: spacingBeforeButton ?? 16),

        // Logout Button
        CustomButton(
          label: logoutButtonLabel ?? 'Logout',
          onPressed: onLogoutTap ?? () {},
        ),
      ],
    );
  }
}
