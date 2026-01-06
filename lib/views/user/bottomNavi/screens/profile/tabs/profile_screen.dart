import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:red_balloon_app/services/auth_service.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../auth/view/onboarding/onboarding_screen.dart';
import '../../home/info/about_app_screen.dart';
import '../../home/info/contact_us_screen.dart';
import '../../home/info/faq_screen.dart';
import '../../home/info/how_it_works_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../tabs/help_center_screen.dart';
import '../controller/in_app_store_controller.dart';
import '../controllers/user_app_content_controller.dart';
import '../widgets/help_section.dart';
import '../widgets/menu_section.dart';
import '../widgets/profile_card.dart';
import '../widgets/stats_grid.dart';
import '../../task/my_task/controller/user_profile_controller.dart';
import 'badge_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeController = Get.put(InAppStoreController());
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
              init: AuthController(),
              builder: (authController) {
                return Column(
                  children: [
                    // Profile Card
                    Builder(
                      builder: (context) {
                        final userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
                        final statsController = Get.put(
                          UserProfileController(userUid: userUid),
                          tag: 'profile_stats',
                        );

                        return Obx(() {
                          // Get reactive values inside Obx
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

                          // Build location string from city and country
                          String? locationText;
                          final city = authController.userCity.value;
                          final country = authController.userCountry.value;

                          if (city.isNotEmpty && country.isNotEmpty) {
                            locationText = '$city, $country';
                          } else if (city.isNotEmpty) {
                            locationText = city;
                          } else if (country.isNotEmpty) {
                            locationText = country;
                          }

                          return statsController.isLoading.value
                              ? const Center(child: CircularProgressIndicator(color: redColor))
                              : ProfileCard(
                                  avatarInitials: initials,
                                  photoURL: photoURL,
                                  userName: displayName,
                                  location: locationText,
                                  phoneNumber: authController.userPhone.value.isNotEmpty
                                      ? authController.userPhone.value
                                      : null,
                                  verificationLabel: 'Verified Requester',
                                  loyaltyPoints: 'Your Loyalty Points: 05',
                                  rating: statsController.averageRating.value.toStringAsFixed(1),
                                  postedTasks: statsController.tasksRequested.value.toString(),
                                  helpedTasks: statsController.tasksCompleted.value.toString(),
                                  avatarColor: redColor,
                                  containerColor: white2Color,
                                  shadowColor: walletBlackColor,
                                  shadowOpacity: 0.25,
                                  shadowBlur: 4,
                                  avatarSize: 100,
                                  namefontSize: 22,
                                  locationFontSize: 14,
                                  onAvatarTap: () async {},
                                  onAvatarLongPressStart: (details) {
                                    if (photoURL != null && photoURL!.isNotEmpty) {
                                      Get.dialog(
                                        GestureDetector(
                                          onTap: () => Get.back(),
                                          child: Container(
                                            color: Colors.black.withOpacity(0.9),
                                            alignment: Alignment.center,
                                            child: Image.network(
                                              photoURL!,
                                              fit: BoxFit.contain,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                        ),
                                        barrierDismissible: true,
                                        useSafeArea: false,
                                      );
                                    }
                                  },
                                  onAvatarLongPressEnd: (details) {
                                    if (Get.isDialogOpen ?? false) {
                                      Get.back();
                                    }
                                  },
                                );
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          'User Badges',
                          fontSize: 16,
                          fontWeight: FontVariant.bold,
                          color: textColor2,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => BadgeScreen());
                          },
                          child: CustomText(
                            'View All',
                            fontSize: 16,
                            fontWeight: FontVariant.bold,
                            color: textColor2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dynamic Selected Badges (Top 2)
                    Obx(() {
                      final selectedBadges = storeController.selectedBadgesData;

                      if (selectedBadges.isEmpty) {
                        return CustomContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          conColor: white2Color,
                          borderRadius: BorderRadius.circular(16),
                          child: const Center(
                            child: CustomText(
                              "No badges selected yet",
                              fontSize: 14,
                              color: greyColor,
                            ),
                          ),
                        );
                      }

                      return CustomContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        conColor: white2Color,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: walletBlackColor.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        child: Column(
                          children: selectedBadges.map((badge) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    badge['image'],
                                    height: 32,
                                    width: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  CustomText(
                                    badge['title'],
                                    fontSize: 16,
                                    fontWeight: FontVariant.medium,
                                    color: textColor2,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Menu Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: CustomContainer(
                        conColor: rbcolor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.25),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        child: Obx(() {
                          final contentController = Get.put(UserAppContentController());
                          
                          return Column(
                            children: [
                              if (contentController.isVisible('about_app')) ...[
                                _buildMenuItem(
                                  Icons.info_outline,
                                  contentController.getTitle('about_app', "About the app"),
                                  () {
                                    Get.to(() => const AboutAppScreen());
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Divider(
                                    height: 1,
                                    color: walletCardBorderColor,
                                  ),
                                ),
                              ],
                              if (contentController.isVisible('contact_us')) ...[
                                _buildMenuItem(
                                  Icons.chat_outlined,
                                  contentController.getTitle('contact_us', "Contact Us"),
                                  () {
                                    Get.to(() => const ContactUsScreen());
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Divider(
                                    height: 1,
                                    color: walletCardBorderColor,
                                  ),
                                ),
                              ],
                              if (contentController.isVisible('faq')) ...[
                                _buildMenuItem(
                                  Icons.help_outline,
                                  contentController.getTitle('faq', "FAQ's"),
                                  () {
                                    Get.to(() => const FAQScreen());
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Divider(
                                    height: 1,
                                    color: walletCardBorderColor,
                                  ),
                                ),
                              ],
                              if (contentController.isVisible('how_it_works')) ...[
                                _buildMenuItem(
                                  Icons.history,
                                  contentController.getTitle('how_it_works', "How it works"),
                                  () {
                                    Get.to(() => const HowItWorksScreen());
                                  },
                                ),
                              ],
                            ],
                          );
                        }),
                      ),
                    ),
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
                        Get.to(() => const HelpCenterScreen());
                      },
                      onLogoutTap: () {
                        DialogHelpers.showLogoutDialog(
                          context,
                          onConfirm: () async {
                            // Clear all GetX controllers before logout
                            Get.deleteAll(force: true);

                            await AuthService().signOut();
                            Get.offAll(() => const OnboardingScreen());
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

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 24, color: redColor),
            const SizedBox(width: 15),
            Expanded(
              child: CustomText(
                title,
                fontSize: 14,
                fontWeight: FontVariant.regular,
                color: blackColor,
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: arrowColor),
          ],
        ),
      ),
    );
  }
}
