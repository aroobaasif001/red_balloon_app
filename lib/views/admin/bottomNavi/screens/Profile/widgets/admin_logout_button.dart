import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:red_balloon_app/views/auth/view/onboarding/onboarding_screen.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminLogoutButton() {
  return Column(
    children: [
      InkWell(
        onTap: () async {
          Get.deleteAll(force: true);

          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          Get.offAll(() => OnboardingScreen());
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
