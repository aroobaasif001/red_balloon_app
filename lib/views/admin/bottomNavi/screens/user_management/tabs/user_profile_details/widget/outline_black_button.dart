import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../../utils/colors.dart';

class OutlineBlackButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const OutlineBlackButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor),
        ),
        child: MaterialButton(
          onPressed: isLoading ? null : onTap,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: blackColor,
                    strokeWidth: 2,
                  ),
                )
              : CustomText(
                  label,
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontVariant.semiBold,
                ),
        ),
      ),
    );
  }
}
