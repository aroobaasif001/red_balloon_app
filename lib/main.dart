import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/auth/view/onboarding/onboarding_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/bottom_navi_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/validation_hub_screen/validation_hub_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/validation_screen/validation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: BottomNaviScreen(),
    );
  }
}
