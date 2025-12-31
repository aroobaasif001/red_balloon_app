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
import 'screens/validations_tab/validation_hub_screen/controller/validation_hub_controller.dart';

class BottomNaviScreen extends StatefulWidget {
  final int initialIndex;
  final int subIndex; // 🔥 For inner tabs like "My Tasks" on the Task tab
  const BottomNaviScreen({super.key, this.initialIndex = 0, this.subIndex = 0});

  @override
  State<BottomNaviScreen> createState() => _BottomNaviScreenState();
}

class _BottomNaviScreenState extends State<BottomNaviScreen> {
  late int currentIndex;
  late List<ModernBottomNavItem> navItems;
  late List<Widget> screens; // 🔥 Declare here

  @override
  void initState() {
    super.initState();
    // Initialize global trackers for badges - set to permanent to ensure they stay active
    Get.put(NotificationController(), permanent: true);
    Get.put(MessagesController(), permanent: true);
    Get.put(ValidationHubController(), permanent: true); // 🔥 Add validation counter
    
    currentIndex = widget.initialIndex;
    _initializeNavItems();

    // 🔥 Initialize screens here to pass the initialTab
    screens = [
      HomeScreen(),
      MyTaskScreen(initialTab: widget.subIndex),
      InAppStoreScreen(),
      ValidationHubScreen(),
      WalletTab(),
    ];
  }

  void _initializeNavItems() {
    final validationController = Get.find<ValidationHubController>();
    
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
        // 🔥 Add validation counter badge
        badge: Obx(() {
          if (validationController.unreadValidationCount.value > 0) {
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '${validationController.unreadValidationCount.value}',
                style: const TextStyle(
                  color: redColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
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
