import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/modern_bottom_nav.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/home_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/tabs/in_app_store_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/my_task_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_hub_screen/validation_hub_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/wallet/wallet_tab.dart';

import 'screens/notification/controller/notification_controller.dart';
import 'screens/profile/tabs/controller/messages_controller.dart';

class BottomNaviScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNaviScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNaviScreen> createState() => _BottomNaviScreenState();
}

class _BottomNaviScreenState extends State<BottomNaviScreen> {
  late int currentIndex;
  late List<ModernBottomNavItem> navItems;

  @override
  void initState() {
    super.initState();
    // Initialize global trackers for badges
    // Initialize global trackers for badges - set to permanent to ensure they stay active
    Get.put(NotificationController(), permanent: true);
    Get.put(MessagesController(), permanent: true);
    
    currentIndex = widget.initialIndex;
    _initializeNavItems();
  }

  void _initializeNavItems() {
    navItems = [
      ModernBottomNavItem(
        label: 'Home',
        activeIcon: Image.asset(
          'assets/navi_icons/home_active.png',
          height: 24,
          color: whiteColor,
        ),
        inactiveIcon: Image.asset(
          'assets/navi_icons/home_inactive.png',
          height: 24,
          color: whiteColor,
        ),
      ),
      ModernBottomNavItem(
        label: 'Tasks',
        activeIcon: Image.asset(
          'assets/navi_icons/task_active.png',
          height: 24,
          color: whiteColor,
        ),
        inactiveIcon: Image.asset(
          'assets/navi_icons/search_inactive.png',
          height: 24,
          color: whiteColor,
        ),
      ),
      ModernBottomNavItem(
        label: 'Store',
        activeIcon: Image.asset(
          'assets/navi_icons/reward_active.png',
          height: 24,
          color: whiteColor,
        ),
        inactiveIcon: Image.asset(
          'assets/navi_icons/reward_inactive.png',
          height: 24,
          color: whiteColor,
        ),
      ),
      ModernBottomNavItem(
        label: 'Validations',
        activeIcon: Image.asset(
          'assets/navi_icons/validations_active.png',
          height: 24,
          color: whiteColor,
        ),
        inactiveIcon: Image.asset(
          'assets/navi_icons/validation_inactive.png',
          height: 24,
          color: whiteColor,
        ),
      ),
      ModernBottomNavItem(
        label: 'Wallet',
        activeIcon: Image.asset(
          'assets/navi_icons/wallet_active.png',
          height: 24,
          color: whiteColor,
        ),
        inactiveIcon: Image.asset(
          'assets/navi_icons/wallet_inactive.png',
          height: 24,
          color: whiteColor,
        ),
      ),
    ];
  }

  List<Widget> screens = [
    HomeScreen(),
    MyTaskScreen(),
    InAppStoreScreen(),
    ValidationHubScreen(),
    WalletTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: screens.elementAt(currentIndex),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: ModernBottomNav(
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: navItems,
          ),
        ),
      ),
    );
  }
}
