import 'dart:io' show Platform;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/admin_bottom_navi_screen.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';
import 'package:red_balloon_app/views/auth/widgets/social_button.dart';

import '../../../user/bottomNavi/bottom_navi_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  bool _isAgreed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    final user = await authController.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (user != null) {
      if (user.email?.trim().toLowerCase() == 'admin@gmail.com') {
        Get.offAll(() => const AdminBottomNaviScreen());
      } else {
        Get.offAll(() => const BottomNaviScreen());
      }

      // Clear fields
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: CustomContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            image: const DecorationImage(
              image: AssetImage('assets/images/splash_bg.png'),
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
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

                // Email & Password Fields (FadeInUp)
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        iconPath: 'assets/icons/message.png',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        iconPath: 'assets/icons/lock.png',
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => CustomButton(
                          label: 'Login',
                          isLoading: authController.isLoading.value,
                          onPressed: _isAgreed ? _handleLogin : null,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const CustomText('— OR —', color: greyColor, fontSize: 14),
                const SizedBox(height: 30),

                // Social buttons fade in from bottom
                FadeInUp(
                  delay: const Duration(milliseconds: 1600),
                  child: Column(
                    children: [
                      if (Platform.isIOS) ...[
                        Obx(
                          () => SocialButton.apple(
                            isLoading: authController.isLoading.value,
                            onPressed: _isAgreed
                                ? () async {
                                    final user = await authController
                                        .signInWithApple();
                                    if (user != null) {
                                      Get.off(() => const BottomNaviScreen());
                                    }
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Obx(
                        () => SocialButton.google(
                          isLoading: authController.isLoading.value,
                          onPressed: _isAgreed
                              ? () async {
                                  final user = await authController
                                      .signInWithGoogle();
                                  if (user != null) {
                                    Get.offAll(() => const BottomNaviScreen());
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 42),
                FadeIn(
                  delay: const Duration(milliseconds: 1900),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        activeColor: redColor,
                        onChanged: (val) {
                          setState(() {
                            _isAgreed = val ?? false;
                          });
                        },
                      ),
                      Flexible(
                        child: CustomText(
                          'By continuing, you agree to Red Balloon\'s Terms & Privacy Policy',
                          fontSize: 12,
                          textAlign: TextAlign.start,
                          color: grey2Color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
