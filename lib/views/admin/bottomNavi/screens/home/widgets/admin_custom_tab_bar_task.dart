import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class AdminCustomTabBarTask extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onTaskTap;
  final VoidCallback onValidationTap;
  final VoidCallback onWalletTap;

  const AdminCustomTabBarTask({
    super.key,
    required this.selectedIndex,
    required this.onTaskTap,
    required this.onValidationTap,
    required this.onWalletTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 4,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabItem(
              label: "TASK",
              isSelected: selectedIndex == 0,
              onTap: onTaskTap,
            ),
            _tabItem(
              label: "VALIDATION",
              isSelected: selectedIndex == 1,
              onTap: onValidationTap,
            ),
            _tabItem(
              label: "WALLET",
              isSelected: selectedIndex == 2,
              onTap: onWalletTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: CustomContainer(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          conColor: isSelected ? redColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: CustomText(
              label,
              color: isSelected ? whiteColor : blackColor,
              fontWeight: FontVariant.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
