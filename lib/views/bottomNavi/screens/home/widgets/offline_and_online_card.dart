import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: blackColor.withOpacity(0.15), offset: const Offset(0, 4), blurRadius: 8)],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          CustomContainer(
            height: 80,
            width: 80,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: AssetImage(image)),
          ),

          const SizedBox(width: 16),

          // Right content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: CustomText(title, fontSize: 15, fontWeight: FontVariant.bold)),

                    // 🔥 SHOW BADGE ONLY IF NOT NULL
                    if (taskType != null)
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        conColor: white1Color,
                        borderRadius: BorderRadius.circular(10),
                        child: CustomText(
                          taskType!, // e.g. "Online task"
                          fontSize: 12,
                          color: grey5Color,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 2.1),

                CustomText(subtitle, fontSize: 13, color: grey5Color),

                const SizedBox(height: 10.1),

                // Distance + Time Row
                Row(
                  children: [
                    // 🔥 Distance only if not null
                    if (distance != null)
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        conColor: white1Color,
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: redColor),
                            const SizedBox(width: 4),
                            CustomText(distance!, fontSize: 12, color: grey5Color),
                          ],
                        ),
                      ),

                    if (distance != null) const SizedBox(width: 7),

                    CustomContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      conColor: white1Color,
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: grey5Color),
                          const SizedBox(width: 4),
                          CustomText(timeAgo, fontSize: 12, color: grey5Color),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15.73),

                // Price + button
                Row(
                  children: [
                    CustomText(price, fontSize: 18, fontWeight: FontVariant.bold, color: redColor),

                    const SizedBox(width: 14),

                    MaterialButton(
                      onPressed: onViewDetails,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: CustomContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        conColor: redColor,
                        borderRadius: BorderRadius.circular(5),
                        child: const CustomText(
                          'View Details',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontVariant.semiBold,
                        ),
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
