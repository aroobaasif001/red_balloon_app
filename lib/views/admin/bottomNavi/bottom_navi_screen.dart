import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/modern_bottom_nav.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/disputes/tabs/disputes_tab.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/home/tabs/home_tab.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_tasks_tabs.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_management_screen.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/wallet/tabs/wallet_tab.dart';

import '../../../utils/colors.dart';

class AdminBottomNaviScreen extends StatefulWidget {
  final int initialIndex;
  const AdminBottomNaviScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminBottomNaviScreen> createState() => _AdminBottomNaviScreenState();
}

class _AdminBottomNaviScreenState extends State<AdminBottomNaviScreen> {
  late int currentIndex;
  late List<ModernBottomNavItem> navItems;

  @override
  void initState() {
    super.initState();
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
      ModernBottomNavItem(
        label: 'Disputes',
        activeIcon: Image.asset(
          'assets/navi_icons/disputes_active.png',
          height: 24,
          color: whiteColor,
        ),
        inactiveIcon: Image.asset(
          'assets/navi_icons/disputes_inactive.png',
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
        label: 'Users',
        activeIcon: Image.asset(
          'assets/navi_icons/user_active.png',
          height: 24,
          color: whiteColor,
        ),
        inactiveIcon: Image.asset(
          'assets/navi_icons/user_inactive.png',
          height: 24,
          color: whiteColor,
        ),
      ),
    ];
  }

  List<Widget> screens = [
    AdminHomeTab(),
    AdminWalletTab(),
    AdminDisputesTab(),
    AdminTaskCenterScreen(),
    UserManagementScreen(),
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
