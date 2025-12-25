import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/user_profile_screen.dart';
import '../../../../../../../utils/colors.dart';

class OfferCard extends StatelessWidget {
  final String name;
  final String price;
  final int tasksCompleted;
  final int tasksRequested;
  final double rating;
  final int stars; // Keeping stars for legacy UI if needed, but rating is preferred
  final String photoUrl;
  final Widget? timerWidget;
  final String? customId; // RB-XXXX
  final String? authUid; // Firestore UID

  const OfferCard({
    super.key,
    required this.name,
    required this.price,
    required this.tasksCompleted,
    required this.tasksRequested,
    required this.rating,
    this.stars = 0,
    required this.photoUrl,
    this.customId,
    this.authUid,
    this.timerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: bordercolor1),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : const AssetImage("assets/images/user1.png") as ImageProvider,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                CustomContainer(
                  width: Get.width * 0.61,
                  child: Row(
                    children: [
                      // const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            name,
                            fontSize: 14,
                            fontWeight: FontVariant.semiBold,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              if (stars == 0)
                                const CustomText(
                                  "No Rating",
                                  fontSize: 12,
                                  color: walletInfoTextColor,
                                  fontWeight: FontVariant.regular,
                                ),
                              if (stars > 0)
                                ...List.generate(
                                  stars,
                                  (index) =>
                                      Icon(Icons.star, color: yellow, size: 15),
                                ),
                              CustomText(
                                "  $tasksCompleted completed",
                                fontSize: 12,
                                color: walletInfoTextColor,
                                fontWeight: FontVariant.regular,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          timerWidget ?? const SizedBox.shrink(),

                          const SizedBox(height: 6),
                          CustomText(
                            price,
                            fontSize: 18,
                            color: pricecolor,
                            fontWeight: FontVariant.bold,
                          ),

                          const CustomText(
                            "SAR",
                            color: walletInfoTextColor,
                            fontSize: 12,
                            fontWeight: FontVariant.regular,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => UserProfileScreen(
                        userName: name,
                        userInitials: name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        rating: rating,
                        tasksCompleted: tasksCompleted,
                        tasksRequested: tasksRequested,
                        userId: customId,
                        userUid: authUid,
                        userPhoto: photoUrl,
                      ),
                    );
                  },
                  child: CustomContainer(
                    width: 254,
                    height: 40,
                    conColor: pricecolor,
                    borderRadius: BorderRadius.circular(12),
                    child: const Center(
                      child: CustomText(
                        "View Profile",
                        color: whiteColor,
                        fontSize: 14,
                        fontWeight: FontVariant.semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
