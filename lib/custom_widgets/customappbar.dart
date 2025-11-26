import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'customtext.dart'; // <-- Correct import (important!)

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  final String? leftImagePath;
  final String? rightImagePath;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  final double? leftImageHeight;
  final double? leftImageWidth;
  final double? rightImageHeight;
  final double? rightImageWidth;

  final double? titleFontSize;
  final FontVariant? titleFontWeight;
  final AppFont? titleFontType;
  final Color? titleColor;
  final Gradient? titleGradient;

  final Color? backgroundColor;
  final double? elevation;
  final SystemUiOverlayStyle? systemOverlayStyle;

  final BoxDecoration? decoration;
  final Gradient? gradient;

  final String? subtitle;
  final bool showLeftImage;
  final bool showRightImage; // ✅ NEW — Same as showLeftImage
  final Widget? leading;

  const CustomAppBar1({
    super.key,
    this.title,
    this.leftImagePath,
    this.rightImagePath,
    this.onLeftPressed,
    this.onRightPressed,
    this.leftImageHeight,
    this.leftImageWidth,
    this.rightImageHeight,
    this.rightImageWidth,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleFontType,
    this.titleColor,
    this.titleGradient,
    this.backgroundColor,
    this.elevation,
    this.systemOverlayStyle,
    this.decoration,
    this.gradient,
    this.subtitle,
    this.showLeftImage = true,
    this.showRightImage = true, // ✅ default true (same behavior as left)
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final effectiveLeft = leftImagePath ?? 'assets/icons/ep_back.png';
    final effectiveRight = rightImagePath ?? 'assets/icons/appBarRighticon.png';

    return Container(
      decoration:
          decoration ??
          BoxDecoration(
            color: backgroundColor ?? Colors.white,
            gradient: gradient,
          ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              /// LEFT ICON
              if (showLeftImage)
                GestureDetector(
                  onTap:
                      onLeftPressed ?? () => Navigator.of(context).maybePop(),
                  child: Image.asset(
                    effectiveLeft,
                    height: leftImageHeight ?? 20,
                    width: leftImageWidth ?? 20,
                  ),
                )
              else
                const SizedBox(width: 20),

              /// TITLE
              Expanded(child: Center(child: _buildTitle())),

              /// RIGHT ICON  (same logic as left)
              if (showRightImage)
                GestureDetector(
                  onTap: onRightPressed,
                  child: Image.asset(
                    effectiveRight,
                    height: rightImageHeight ?? 24,
                    width: rightImageWidth ?? 24,
                  ),
                )
              else
                const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (title == null) return const SizedBox.shrink();

    final widget = CustomText(
      title!,
      fontSize: titleFontSize ?? 20,
      fontWeight: titleFontWeight ?? FontVariant.bold,
      fontType: titleFontType ?? AppFont.montserrat,
      color: titleGradient == null ? titleColor ?? Colors.black : Colors.white,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    if (titleGradient == null) return widget;

    return ShaderMask(
      shaderCallback: (bounds) => titleGradient!.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: BlendMode.srcIn,
      child: widget,
    );
  }
}
