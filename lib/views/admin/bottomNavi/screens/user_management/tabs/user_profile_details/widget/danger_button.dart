import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../../utils/colors.dart';

class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DangerButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color:redColor2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: MaterialButton(
          onPressed: onTap,
          child: CustomText(
            label,
            color: whiteColor,
            fontSize: 14,
            fontWeight: FontVariant.semiBold,

          ),
        ),
      ),
    );
  }
}
