// ------------------------------
// UPDATED CUSTOM BUTTON
// ------------------------------
import 'package:flutter/material.dart';
import 'package:red_balloon_app/utils/colors.dart';

import 'custom_container.dart';
import 'customtext.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  final double height;
  final double? width;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;

  final Color bgColor;
  final Gradient? gradient;
  final Color textColor;
  final TextStyle? textStyle;
  final List<BoxShadow>? boxShadow;
  final Color? splashColor;
  final Color? disabledBgColor;
  final Color? disabledTextColor;

  final bool isLoading;
  final Widget? leading;   // image or icon support
  final Widget? trailing;

  final double? fontSize;

  final FontVariant? fontWeight;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 50,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.padding,
    this.bgColor = redColor,
    this.gradient,
    this.textColor = whiteColor,
    this.textStyle,
    this.boxShadow,
    this.splashColor,
    this.disabledBgColor,
    this.disabledTextColor,
    this.isLoading = false,
    this.leading,           // <-- now supports icon/image
    this.trailing,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return CustomContainer(
      height: height,
      width: width ?? double.maxFinite,
      conColor: gradient == null
          ? (enabled ? bgColor : (disabledBgColor ?? bgColor.withOpacity(0.5)))
          : null,
      gradient: gradient,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          splashColor: splashColor,
          onTap: enabled ? onPressed : null,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 8),
                  ],

                  CustomText(
                    label,
                    color: enabled ? textColor : Colors.white70,
                    fontWeight: fontWeight ?? FontVariant.semiBold,
                    fontSize: fontSize ?? 18,
                    style: textStyle,
                  ),

                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
