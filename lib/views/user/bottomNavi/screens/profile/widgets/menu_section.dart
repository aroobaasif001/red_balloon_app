import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../tabs/help_center_screen.dart';
import '../tabs/in_app_store_screen.dart';
import '../tabs/messages_screen.dart';
import '../tabs/reviews_and_feedback_screen.dart';
import '../tabs/terms_and_policy_screen.dart';
import 'menu_item.dart';

class MenuSection extends StatelessWidget {
  final List<MenuItemData>? menuItems;
  final Color? containerColor;
  final Color? shadowColor;
  final double? shadowBlur;
  final double? shadowOpacity;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? dividerColor;

  const MenuSection({
    super.key,
    this.menuItems,
    this.containerColor,
    this.shadowColor,
    this.shadowBlur = 4,
    this.shadowOpacity = 0.25,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
    this.dividerColor,
  });

  List<MenuItemData> get defaultMenuItems => [
    MenuItemData(
      icon: 'assets/icons/notification_2.png',
      label: 'Notifications',
      hasToggle: true,
    ),
    MenuItemData(
      icon: 'assets/icons/star.png',
      label: 'Help Center',
      hasArrow: true,
      onTap: () {
        Get.to(() => HelpCenterScreen());
      },
    ),
    MenuItemData(
      icon: 'assets/icons/terms.png',
      label: 'Terms & Privacy',
      hasArrow: true,
      onTap: () {
        Get.to(() => TermsAndPolicyScreen());
      },
    ),
    MenuItemData(
      icon: 'assets/icons/feedback.png',
      label: 'Feedbacks and Reviews',
      hasArrow: true,
      onTap: () {
        Get.to(() => ReviewsAndFeedback());
      },
    ),
    MenuItemData(
      icon: 'assets/icons/inapp.png',
      label: 'In-App Store',
      hasArrow: true,
      onTap: () {
        Get.to(() => InAppStoreScreen());
      },
    ),
    MenuItemData(
      icon: 'assets/icons/homemessage.png',
      label: 'Messages',
      hasArrow: true,
      onTap: () {
        Get.to(() => MessagesScreen());
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = menuItems ?? defaultMenuItems;

    return CustomContainer(
      padding: padding,
      conColor: containerColor ?? white2Color,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? walletBlackColor).withOpacity(
            shadowOpacity ?? 0.25,
          ),
          blurRadius: shadowBlur ?? 4,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        children: List.generate(
          items.length,
          (index) => Column(
            children: [
              MenuItem(
                icon: items[index].icon,
                label: items[index].label,
                hasArrow: items[index].hasArrow,
                hasToggle: items[index].hasToggle,
                onTap: items[index].onTap,
                onToggleChanged: items[index].onToggleChanged,
              ),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  color: dividerColor ?? walletCardBorderColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemData {
  final String icon;
  final String label;
  final bool hasArrow;
  final bool hasToggle;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleChanged;

  MenuItemData({
    required this.icon,
    required this.label,
    this.hasArrow = false,
    this.hasToggle = false,
    this.onTap,
    this.onToggleChanged,
  });
}
