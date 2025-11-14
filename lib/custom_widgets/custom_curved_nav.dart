import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_navi_bottom.dart';

import '../utils/colors.dart';

class CustomCurvedNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomCurvedNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      color: redColor,
      height: 70,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: redColor,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        CurvedNavigationBarItem(
          child: Image.asset(
            currentIndex == 0 ? 'assets/navi_icons/home_active.png' : 'assets/navi_icons/home_inactive.png',
            height: 24,
            color: currentIndex == 0 ? Colors.white : grey3Color,
          ),
          label: 'Home',
          labelStyle: TextStyle(
            color: currentIndex == 0 ? Colors.white : grey3Color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        CurvedNavigationBarItem(
          child: Image.asset(
            currentIndex == 1 ? 'assets/navi_icons/task_active.png' : 'assets/navi_icons/search_inactive.png',
            height: 24,
            color: currentIndex == 1 ? Colors.white : grey3Color,
          ),
          label: 'Search',
          labelStyle: TextStyle(
            color: currentIndex == 1 ? Colors.white : grey3Color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        CurvedNavigationBarItem(
          child: Image.asset(
            currentIndex == 2 ? 'assets/navi_icons/validations_active.png' : 'assets/navi_icons/validation_inactive.png',
            height: 24,
            color: currentIndex == 2 ? Colors.white : grey3Color,
          ),
          label: 'Validations',
          labelStyle: TextStyle(
            color: currentIndex == 2 ? Colors.white : grey3Color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        CurvedNavigationBarItem(
          child: Image.asset(
            currentIndex == 3 ? 'assets/navi_icons/wallet_active.png' : 'assets/navi_icons/wallet_inactive.png',
            height: 24,
            color: currentIndex == 3 ? Colors.white : grey3Color,
          ),
          label: 'Wallet',
          labelStyle: TextStyle(
            color: currentIndex == 3 ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
      onTap: onTap,
    );
  }
}
