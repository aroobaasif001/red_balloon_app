import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomHomeTypeTabs extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onOfflineTap;
  final VoidCallback onOnlineTap;
  final VoidCallback onLatestTap;
  final VoidCallback onNearbyTap;

  const CustomHomeTypeTabs({
    super.key,
    required this.selectedIndex,
    required this.onOfflineTap,
    required this.onOnlineTap,
    required this.onLatestTap,
    required this.onNearbyTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ------------------- Offline Task -------------------
          GestureDetector(
            onTap: onOfflineTap,
            child: CustomContainer(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16.5,
              ),
              conColor: selectedIndex == 0 ? whiteColor : Colors.transparent,
              border: selectedIndex == 0
                  ? Border(
                      bottom: BorderSide(color: walletPrimaryColor, width: 1.5),
                    )
                  : null,
              // borderRadius: BorderRadius.circular(12),
              child: Center(
                child: CustomText(
                  'Tasks for you',
                  color: selectedIndex == 0 ? redColor : blackColor,
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
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16.5,
              ),
              conColor: selectedIndex == 1 ? whiteColor : Colors.transparent,
              border: selectedIndex == 1
                  ? Border(
                      bottom: BorderSide(color: walletPrimaryColor, width: 1.5),
                    )
                  : null,
              // borderRadius: BorderRadius.circular(12),
              child: Center(
                child: CustomText(
                  'Recommended',
                  color: selectedIndex == 1 ? redColor : blackColor,
                  fontWeight: FontVariant.semiBold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ------------------- Online Task -------------------
          GestureDetector(
            onTap: onLatestTap,
            child: CustomContainer(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16.5,
              ),
              conColor: selectedIndex == 2 ? whiteColor : Colors.transparent,
              border: selectedIndex == 2
                  ? Border(
                      bottom: BorderSide(color: walletPrimaryColor, width: 1.5),
                    )
                  : null,
              // borderRadius: BorderRadius.circular(12),
              child: Center(
                child: CustomText(
                  'Latest',
                  color: selectedIndex == 2 ? redColor : blackColor,
                  fontWeight: FontVariant.semiBold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ------------------- Online Task -------------------
          GestureDetector(
            onTap: onNearbyTap,
            child: CustomContainer(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16.5,
              ),
              conColor: selectedIndex == 3 ? whiteColor : Colors.transparent,
              border: selectedIndex == 3
                  ? Border(
                      bottom: BorderSide(color: walletPrimaryColor, width: 1.5),
                    )
                  : null,
              // borderRadius: BorderRadius.circular(12),
              child: Center(
                child: CustomText(
                  'Nearby',
                  color: selectedIndex == 3 ? redColor : blackColor,
                  fontWeight: FontVariant.semiBold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
