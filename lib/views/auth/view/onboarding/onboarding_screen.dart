import 'dart:io' show Platform;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';
import 'package:red_balloon_app/views/auth/widgets/social_button.dart';
import 'package:red_balloon_app/views/bottomNavi/bottom_navi_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(
        () => authController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : CustomContainer(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/splash_bg.png'),
                  alignment: Alignment.center,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideInUp(
                      duration: const Duration(milliseconds: 900),
                      child: CustomContainer(
                        height: 177,
                        width: 280,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/splash_logo.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 39),
                    // Social buttons fade in from bottom
                    FadeInUp(
                      delay: const Duration(milliseconds: 1600),
                      child: Column(
                        children: [
                          if (Platform.isIOS) ...[
                            SocialButton.apple(
                              onPressed: () async {
                                final user = await authController
                                    .signInWithApple();
                                if (user != null) {
                                  Get.off(() => BottomNaviScreen());
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                          SocialButton.google(
                            onPressed: () async {
                              // final user = await authController.signInWithGoogle();
                              // if (user != null) {
                              Get.offAll(() => BottomNaviScreen());
                              // }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 42),
                    FadeIn(
                      delay: const Duration(milliseconds: 1900),
                      child: CustomText(
                        'By continuing, you agree to Red Balloon\'s Terms & Privacy\nPolicy',
                        fontSize: 12,
                        textAlign: TextAlign.center,
                        color: grey2Color,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
