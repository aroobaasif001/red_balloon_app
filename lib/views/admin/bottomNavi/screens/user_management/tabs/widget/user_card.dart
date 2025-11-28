import 'package:flutter/material.dart';
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
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
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
                CustomText(
                  code,
                  fontSize: 18,
                  fontWeight: FontVariant.bold,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    CustomTag(title: userType),
                    const SizedBox(width: 8),
                    if (verified) CustomTag(title: "Verified"),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    CustomLocationTag(city),
                  ],
                ),

                const SizedBox(height: 10),

                // Row(
                //   children: [
                //     CustomRatingStars(stars: stars),
                //     const SizedBox(width: 8),
                //     CustomText(tasksText, fontSize: 14),
                //   ],
                // ),

                const SizedBox(height: 10),
                CustomText(
                  price,
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// RIGHT SIDE (Avatar + Button)
          Column(
            children: [
              ProfileCircle(initials: initials),
              const SizedBox(height: 16),

              SizedBox(
                width: 120, // REQUIRED FIX
                child: CustomButton(
                  label: "View Profile",
                  onPressed: onView,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
