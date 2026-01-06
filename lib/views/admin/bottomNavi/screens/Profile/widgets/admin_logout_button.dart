import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/views/auth/view/onboarding/onboarding_screen.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminLogoutButton() {
  final AuthService _authService = AuthService();

  return Column(
    children: [
      InkWell(
        onTap: () async {
          Get.deleteAll(force: true);

          await _authService.signOut();
          Get.offAll(() => const OnboardingScreen());
        },
        child: CustomContainer(
          height: 48,
          borderRadius: BorderRadius.circular(15),
          conColor: redColor,
          child: const Center(
            child: CustomText(
              'Logout',
              fontSize: 16,
              fontWeight: FontVariant.semiBold,
              color: whiteColor,
            ),
          ),
        ),
      ),
    ],
  );
}
