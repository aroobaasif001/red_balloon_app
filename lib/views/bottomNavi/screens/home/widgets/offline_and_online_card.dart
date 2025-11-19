import 'package:flutter/material.dart';
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
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText(
                            title,
                            fontSize: 18,
                            fontWeight: FontVariant.bold,
                          ),
                        ),

                        // 🔥 SHOW BADGE ONLY IF NOT NULL
                        // if (taskType != null)
                        //   CustomContainer(
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 10,
                        //       vertical: 4,
                        //     ),
                        //     conColor: white1Color,
                        //     borderRadius: BorderRadius.circular(10),
                        //     child: CustomText(
                        //       taskType!, // e.g. "Online task"
                        //       fontSize: 12,
                        //       color: grey5Color,
                        //     ),
                        //   ),
                      ],
                    ),
                    const SizedBox(height: 15.1),

                    CustomText(
                      price,
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      color: blackColor,
                    ),

                    //
                    // const SizedBox(height: 2.1),
                    //
                    // CustomText(subtitle, fontSize: 13, color: grey5Color),
                    const SizedBox(height: 10.1),

                    // Distance + Time Row
                    Row(
                      children: [
                        // 🔥 Distance only if not null
                        if (distance != null)
                          CustomContainer(
                            // padding: const EdgeInsets.symmetric(
                            //   horizontal: 10,
                            //   vertical: 7,
                            // ),
                            // conColor: white1Color,
                            // borderRadius: BorderRadius.circular(12),
                            child: Row(
                              children: [
                                CustomText(
                                  distance!,
                                  fontSize: 12,
                                  color: grey5Color,
                                ),
                              ],
                            ),
                          ),

                        if (distance != null) const SizedBox(width: 7),

                        CustomContainer(
                          // padding: const EdgeInsets.symmetric(
                          //   horizontal: 10,
                          //   vertical: 7,
                          // ),
                          // conColor: white1Color,
                          // borderRadius: BorderRadius.circular(12),
                          child: Row(
                            children: [
                              // const Icon(
                              //   Icons.access_time,
                              //   size: 14,
                              //   color: grey5Color,
                              // ),
                              // const SizedBox(width: 4),
                              CustomText(
                                " • ${timeAgo}",
                                fontSize: 12,
                                color: grey5Color,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15.73),

                    // Price + button
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Image
              CustomContainer(
                height: 80,
                width: 80,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: AssetImage(image)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                conColor: white1Color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: grey5Color,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      type,
                      fontSize: 14,
                      fontWeight: FontVariant.regular,
                      color: txColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              CustomButton(
                width: 107,
                fontSize: 12,
                // borderRadius: BorderRadius.circular(30),
                height: 30,
                label: 'View Details',
                onPressed: onViewDetails,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
