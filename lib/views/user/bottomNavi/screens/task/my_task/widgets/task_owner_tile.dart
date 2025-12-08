import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/user_profile_screen.dart';

import '../../../../../../../utils/colors.dart';

class TaskOwnerTile extends StatelessWidget {
  final String? photoUrl;
  final String? name;
  final String? id;
  const TaskOwnerTile({super.key, this.id, this.name, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: photoUrl == null
              ? AssetImage("assets/images/profile3.png")
              : NetworkImage(photoUrl!),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(name == null ? "Ahmed Al Harbi" : name!),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: yellow, size: 20),
                const SizedBox(width: 4),
                const CustomText(
                  "4.9",
                  color: textcolord,
                  fontSize: 14,
                  fontWeight: FontVariant.medium,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  "assets/icons/dot.png",
                  width: 9,
                  height: 24,
                  fit: BoxFit.contain,
                ),

                const SizedBox(width: 4),
                const CustomText(
                  "Verified",
                  color: textcolord,
                  fontSize: 12,
                  fontWeight: FontVariant.regular,
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              id == null ? "RB-124" : id!,
              color: textcolord,
              fontSize: 12,
              fontWeight: FontVariant.regular,
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () {
                Get.to(
                  () => UserProfileScreen(
                    userPhoto: photoUrl,
                    userId: id,
                    userName: name!,
                    userInitials: '',
                    rating: 0,
                    tasksCompleted: 0,
                    tasksRequested: 0,
                  ),
                );
              },
              child: CustomText(
                "View Profile",
                color: pricecolor,
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
