import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../auth/view/onboarding/onboarding_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../widgets/help_section.dart';
import '../widgets/menu_section.dart';
import '../widgets/profile_card.dart';
import '../widgets/stats_grid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          titleText: 'Profile Section',
          action: [
            IconButton(
              onPressed: () {
                Get.to(() => EditProfileScreen());
              },
              icon: Image.asset(
                'assets/icons/edit_2.png',
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: GetBuilder<AuthController>(
              // init: AuthController(),
              builder: (authController) {
                final currentUser = authController.currentUser.value;
                final displayName = currentUser?.displayName ?? 'User';
                final photoURL = currentUser?.photoURL;
                final initials = displayName.isNotEmpty
                    ? displayName
                          .split(' ')
                          .map((e) => e[0])
                          .join()
                          .toUpperCase()
                    : 'RB';

                return Column(
                  children: [
                    // Profile Card
                    ProfileCard(
                      avatarInitials: initials,
                      photoURL: photoURL,
                      userName: displayName,
                      location: 'Riyadh, Saudi Arabia',
                      verificationLabel: 'Verified Requester',
                      loyaltyPoints: 'Your Loyalty Points: 05',
                      avatarColor: redColor,
                      containerColor: white2Color,
                      shadowColor: walletBlackColor,
                      shadowOpacity: 0.25,
                      shadowBlur: 4,
                      avatarSize: 100,
                      namefontSize: 22,
                      locationFontSize: 14,
                      onAvatarTap: () {
                        // Handle avatar tap
                      },
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        'User Badges',
                        fontSize: 16,
                        fontWeight: FontVariant.bold,
                        color: textColor2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StatsGrid(postedCount: '500'),
                    const SizedBox(height: 20),

                    // Menu Section
                    MenuSection(
                      containerColor: white2Color,
                      shadowColor: walletBlackColor,
                      shadowOpacity: 0.25,
                      shadowBlur: 4,
                      dividerColor: walletCardBorderColor,
                    ),
                    const SizedBox(height: 20),

                    // Help Section
                    HelpSection(
                      helpText: 'Need help? ',
                      helpLinkText: 'Visit Help Center',
                      logoutButtonLabel: 'Logout',
                      helpTextColor: blackColor,
                      helpLinkColor: redColor,
                      helpTextFontSize: 13,
                      helpLinkFontSize: 13,
                      spacingBeforeButton: 16,
                      onHelpTap: () {
                        // Handle help center tap
                      },
                      onLogoutTap: () {
                        DialogHelpers.showLogoutDialog(
                          context,
                          onConfirm: () async {
                            await FirebaseAuth.instance.signOut();
                            await GoogleSignIn().signOut();
                            Get.offAll(() => OnboardingScreen());
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
