import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/views/auth/view/login/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => SignInScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeInDown(
          duration: const Duration(milliseconds: 1200),
          child: CustomContainer(
            height: 188,
            width: double.infinity,
            image: const DecorationImage(
              image: AssetImage('assets/images/splash_logo.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
