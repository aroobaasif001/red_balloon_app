// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_management_screen2.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/user_profile_details_screen.dart';
import 'package:red_balloon_app/views/auth/view/onboarding/onboarding_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;

    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: whiteColor),
      debugShowCheckedModeBanner: false,
      // home: user == null ? const OnboardingScreen() : const BottomNaviScreen(),
      home: UserProfileDetailsScreen(),
    );
  }
}
