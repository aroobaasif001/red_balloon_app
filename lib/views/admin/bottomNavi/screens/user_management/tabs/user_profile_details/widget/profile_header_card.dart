import 'package:flutter/material.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/verified_tag.dart';

import '../../../../../../../../custom_widgets/customtext.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String initial;
  final bool verified;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.initial,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 60),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CustomText(
              initial,
              fontSize: 30,
              fontWeight: FontVariant.bold,
              alignment: Alignment.center,
              color: Colors.white,
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
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),



            const SizedBox(height: 10),
            CustomText(
              name,
              fontSize: 20,
              fontWeight: FontVariant.bold,
              alignment: Alignment.center,
              color: Colors.white,

              maxLines: 1,        // 🔥 Force one line
              overflow: TextOverflow.ellipsis, // 🔥 Prevent wrapping
              softWrap: false,    // 🔥 Disable automatic line break
            ),

            const SizedBox(height: 12),
            if (verified) const VerifiedTag(),
          ],
        ),
      ),
    );
  }
}
