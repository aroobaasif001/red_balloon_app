import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomTaskTypeTabs extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onOfflineTap;
  final VoidCallback onOnlineTap;

  const CustomTaskTypeTabs({
    super.key,
    required this.selectedIndex,
    required this.onOfflineTap,
    required this.onOnlineTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ------------------- Offline Task -------------------
        GestureDetector(
          onTap: onOfflineTap,
          child: CustomContainer(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.5),
            conColor: selectedIndex == 0 ? redColor : Colors.transparent,
            border: selectedIndex == 0 ? null : Border.all(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: CustomText(
                'Offline Task',
                color: selectedIndex == 0 ? Colors.white : Colors.black,
                fontWeight: FontVariant.semiBold,
                fontSize: 18,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ------------------- Online Task -------------------
        GestureDetector(
          onTap: onOnlineTap,
          child: CustomContainer(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.5),
            conColor: selectedIndex == 1 ? redColor : Colors.transparent,
            border: selectedIndex == 1 ? null : Border.all(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: CustomText(
                'Online Task',
                color: selectedIndex == 1 ? Colors.white : Colors.black,
                fontWeight: FontVariant.semiBold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
