import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class OfflineAndOnlineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? distance; // 🔥 null = hide distance
  final String? taskType; // 🔥 null = hide badge
  final String timeAgo;
  final String price;
  final String image;
  final String type;

  final VoidCallback? onViewDetails;

  const OfflineAndOnlineCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.distance,
    this.taskType, // 🔥 NEW OPTIONAL BADGE
    required this.timeAgo,
    required this.price,
    required this.image,
    this.onViewDetails,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: Get.width * 0.45,
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.15),
          offset: const Offset(0, 4),
          blurRadius: 8,
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image
          CustomContainer(
            height: 115,
            width: Get.width * 0.45,
            conColor: whiteColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            child: Center(child: Image.asset(image)),
          ),

          CustomContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomText(
                              title,
                              fontSize: 13,
                              fontWeight: FontVariant.bold,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.1),

                      FittedBox(
                        child: Row(
                          children: [
                            if (distance != null)
                              CustomContainer(
                                child: Row(
                                  children: [
                                    CustomText(
                                      distance!,
                                      fontSize: 11,
                                      fontWeight: FontVariant.regular,
                                      color: grey5Color,
                                    ),
                                  ],
                                ),
                              ),

                            // if (distance != null) const SizedBox(width: 7),
                            CustomContainer(
                              child: Row(
                                children: [
                                  CustomText(
                                    " • ${timeAgo}",
                                    fontSize: 11,
                                    fontWeight: FontVariant.regular,

                                    color: grey5Color,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.1),

                      CustomText(
                        price,
                        fontSize: 18,
                        fontWeight: FontVariant.bold,
                        color: blackColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomContainer(
            margin: EdgeInsets.only(bottom: 15),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CustomButton(
              // width: Get.width * 0.4,
              fontSize: 12,
              height: 40,
              label: 'View Details',
              onPressed: onViewDetails,
            ),
          ),
        ],
      ),
    );
  }
}
