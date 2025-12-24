import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ModernBottomNavItem {
  final String label;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final Widget? badge; // 🔥 Optional badge widget

  ModernBottomNavItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    this.badge,
  });
}

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ModernBottomNavItem> items;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.only(left: 3),
      conColor: redColor,
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: redColor.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, -2),
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          items.length,
          (index) => _NavBarItem(
            item: items[index],
            isActive: currentIndex == index,
            onTap: () => onTap(index),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final ModernBottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CustomContainer(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: isActive ? item.activeIcon : item.inactiveIcon,
                ),
              ),
              // 🔥 Show badge if provided
              if (item.badge != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: item.badge!,
                ),
            ],
          ),
          const SizedBox(height: 4),
          CustomText(
            item.label,
            color: isActive ? whiteColor : whiteColor.withOpacity(0.7),
            fontSize: 11,
            fontWeight: isActive ? FontVariant.medium : FontVariant.regular,
          ),
          const SizedBox(height: 4),
          isActive
              ? CustomContainer(
                  width: 12,
                  height: 6,
                  conColor: whiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                )
              : const SizedBox(width: 12, height: 6),
        ],
      ),
    );
  }
}
