import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_curved_nav.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/home_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/my_task_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/validation_hub_screen/validation_hub_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/tabs/wallet_tab.dart';

class BottomNaviScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNaviScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNaviScreen> createState() => _BottomNaviScreenState();
}

class _BottomNaviScreenState extends State<BottomNaviScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  List<Widget> screens = [
    HomeScreen(),
    MyTaskScreen(),
    ValidationHubScreen(),
    WalletTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: screens.elementAt(currentIndex),
        bottomNavigationBar: CustomCurvedNav(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
