import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import 'customtext.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String titleText;
  final double titleFontSize;
  final FontVariant titleFontWeight;
  final double elevation;
  final double scrolledUnderElevation;
  final action;
  final bool centerTitle;
  final Color iconColor;
  final double iconSize;
  final double iconOpacity;
  final Color leadingIconColor;
  final IconData leadingIcon;
  final leadingOnPressed;
  final bool disableLeading;
  final Color titleTextColor;

  const CustomAppBar({
    super.key,
    this.action,
    this.backgroundColor = whiteColor,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
    this.titleFontSize = 24,
    this.titleFontWeight = FontVariant.bold,
    this.titleText = 'Red Ballon',
    this.centerTitle = true,
    this.iconColor = blackColor,
    this.iconOpacity = 1.0,
    this.iconSize = 24,
    this.leadingIconColor = blackColor,
    this.leadingIcon = Icons.arrow_back_ios_new_sharp,
    this.leadingOnPressed,
    this.disableLeading = false,
    this.titleTextColor = blackColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: disableLeading == false
          ? IconButton(
              onPressed: leadingOnPressed == null
                  ? () {
                      Get.back();
                    }
                  : leadingOnPressed,
              icon: Icon(leadingIcon, color: leadingIconColor),
            )
          : null,
      backgroundColor: whiteColor,
      centerTitle: centerTitle,
      title: CustomText(
        titleText,
        fontSize: titleFontSize,
        fontWeight: titleFontWeight,
        color: titleTextColor,
      ),
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      actions: action,
      iconTheme: IconThemeData(
        color: iconColor,
        size: iconSize,
        opacity: iconOpacity,
      ),
    );
  }
}
