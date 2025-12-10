import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/verified_tag.dart';

import '../../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../../utils/colors.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String initial;
  final bool verified;
  final String? photoUrl;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.initial,
    required this.verified,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: CustomContainer(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 1,
            color: blackColor.withOpacity(0.25),
          ),
        ],
        height: 234,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 69),
        conColor: redColor,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image or Initial
            if (photoUrl != null && photoUrl!.isNotEmpty)
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(photoUrl!),
                backgroundColor: whiteColor.withOpacity(0.2),
              )
            else
              CustomText(
                initial,
                fontSize: 30,
                fontWeight: FontVariant.bold,
                alignment: Alignment.center,
                color: whiteColor,
              ),
            const SizedBox(height: 6),

            // Green Online Dot
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 14,
                width: 14,
                margin: const EdgeInsets.only(right: 70),
                decoration: BoxDecoration(
                  color: greenColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: whiteColor, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 10),
            CustomText(
              name,
              fontSize: 20,
              fontWeight: FontVariant.bold,
              alignment: Alignment.center,
              color: whiteColor,

              maxLines: 1, // 🔥 Force one line
              overflow: TextOverflow.ellipsis, // 🔥 Prevent wrapping
              softWrap: false, // 🔥 Disable automatic line break
            ),

            const SizedBox(height: 12),
            if (verified) const VerifiedTag(),
          ],
        ),
      ),
    );
  }
}
