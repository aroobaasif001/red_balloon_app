import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomTabBarTask extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onAllTasksTap;
  final VoidCallback onPostedByMeTap;
  final VoidCallback onInProgressTap;
  final VoidCallback onDraftsTap;

  const CustomTabBarTask({
    super.key,
    required this.selectedIndex,
    required this.onAllTasksTap,
    required this.onPostedByMeTap,
    required this.onInProgressTap,
    required this.onDraftsTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _tabItem(label: "ALL TASKS", isSelected: selectedIndex == 0, onTap: onAllTasksTap),
          const SizedBox(width: 10),

          _tabItem(label: "POSTED BY ME", isSelected: selectedIndex == 1, onTap: onPostedByMeTap),
          const SizedBox(width: 10),

          _tabItem(label: "IN PROGRESS", isSelected: selectedIndex == 2, onTap: onInProgressTap),
          const SizedBox(width: 10),

          _tabItem(label: "DRAFTS", isSelected: selectedIndex == 3, onTap: onDraftsTap),
        ],
      ),
    );
  }

  Widget _tabItem({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        conColor: isSelected ? redColor : appbard,
        borderRadius: BorderRadius.circular(999),

        child: CustomText(
          label,
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontVariant.semiBold,
          fontSize: 14,
        ),
      ),
    );
  }
}
