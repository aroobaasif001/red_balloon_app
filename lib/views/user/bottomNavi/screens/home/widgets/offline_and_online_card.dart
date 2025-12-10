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
  final String btnText; // 🔥 Dynamic button text

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
    this.btnText = 'View Details', // 🔥 Default value
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: Get.width,
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
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 7),
          CustomContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomText(
                        title,
                        fontSize: 15,
                        fontWeight: FontVariant.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 25.1),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (distance != null)
                            CustomText(
                              distance!,
                              fontSize: 12,
                              fontWeight: FontVariant.regular,
                              color: blackColor,
                              overflow: TextOverflow.ellipsis,
                            ),

                          // if (distance == null) const Spacer(),
                          CustomText(
                            distance != null ? " • ${timeAgo}" : timeAgo,
                            fontSize: 12,
                            fontWeight: FontVariant.regular,
                            color: blackColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 7),
                Expanded(
                  child: Column(
                    children: [
                      CustomText(
                        price,
                        fontSize: 18,
                        fontWeight: FontVariant.semiBold,
                        color: blackColor,
                      ),
                      SizedBox(height: 10),
                      CustomContainer(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 15),
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        child: CustomButton(
                          // width: Get.width * 0.4,
                          fontSize: 12,
                          height: 40,
                          label: btnText, // 🔥 Dynamic button text
                          onPressed: onViewDetails,
                        ),
                      ),
                    ],
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
