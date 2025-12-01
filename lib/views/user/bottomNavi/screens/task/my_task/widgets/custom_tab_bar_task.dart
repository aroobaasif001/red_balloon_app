import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomTabBarTask extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onPostedByMeTap;
  final VoidCallback onInProgressTap;

  const CustomTabBarTask({
    super.key,
    required this.selectedIndex,
    required this.onPostedByMeTap,
    required this.onInProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // _tabItem(
          //   label: "ALL TASKS",
          //   isSelected: selectedIndex == 0,
          //   onTap: onAllTasksTap,
          // ),
          // const SizedBox(width: 10),

          _tabItem(
            label: "ACTIVE TASKS",
            isSelected: selectedIndex == 0,
            onTap: onPostedByMeTap,
          ),
          const SizedBox(width: 10),

          _tabItem(
            label: "HISTORY",
            isSelected: selectedIndex == 1,
            onTap: onInProgressTap,
          ),
        ],
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
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        conColor: isSelected ? redColor : appbard,
        borderRadius: BorderRadius.circular(999),

        child: CustomText(
          label,
          color: isSelected ?whiteColor :blackColor,
          fontWeight: FontVariant.semiBold,
          fontSize: 14,
        ),
      ),
    );
  }
}
