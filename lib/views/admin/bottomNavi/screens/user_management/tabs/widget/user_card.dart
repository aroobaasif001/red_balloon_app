import 'package:flutter/material.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/widget/profile_circle.dart';

import '../../../../../../../custom_widgets/custom_button.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import 'custom_location_tag.dart';
import 'custom_rating_stars.dart';
import 'custom_tag.dart';

class UserCard extends StatelessWidget {
  final String code;
  final String userType;
  final bool verified;
  final String city;
  final int stars;
  final String tasksText;
  final String price;
  final String initials;
  final String? imageUrl;
  final bool isSuspended; // 🔥 Added
  final VoidCallback onView;

  const UserCard({
    super.key,
    required this.code,
    required this.userType,
    required this.verified,
    required this.city,
    required this.stars,
    required this.tasksText,
    required this.price,
    required this.initials,
    this.imageUrl,
    this.isSuspended = false, // 🔥 Added
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(color: bordercol, width: 1),
          right: BorderSide(color: bordercol, width: 1),
          left: BorderSide(color: bordercol, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.25),
            blurRadius: 1,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT SIDE
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          code,
                          fontSize: 18,
                          fontWeight: FontVariant.bold,
                          color: black4Color,
                        ),
                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (verified) CustomTag(title: "Verified"),
                            if (isSuspended)
                              CustomTag(
                                title: "Suspended",
                                textColor: whiteColor,
                                bgColor: redColor,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    /// RIGHT SIDE (Avatar + Button)
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: isSuspended
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.matrix(<double>[
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0,      0,      0,      1, 0,
                              ]),
                              child: ProfileCircle(initials: initials, imageUrl: imageUrl),
                            )
                          : ProfileCircle(initials: initials, imageUrl: imageUrl),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: taskstatus3),
                    const SizedBox(width: 6),
                    CustomLocationTag(city),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    CustomRatingStars(stars: stars),
                    const SizedBox(width: 8),
                    CustomText(
                      tasksText,
                      fontSize: 14,
                      color: walletGrey600Color,
                      fontWeight: FontVariant.regular,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      price,
                      fontSize: 12,
                      color: walletGrey500Color,
                      fontWeight: FontVariant.regular,
                    ),
                    SizedBox(
                      width: 135, // REQUIRED FIX
                      child: CustomButton(
                        borderRadius: BorderRadius.circular(16),
                        height: 36,
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        label: "View Profile",
                        onPressed: onView,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
