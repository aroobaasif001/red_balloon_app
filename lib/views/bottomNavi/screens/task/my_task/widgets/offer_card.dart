import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import '../../../../../../utils/colors.dart' as Colors;
import '../../../../../../utils/colors.dart';

class OfferCard extends StatelessWidget {
  final String name;
  final String price;
  final int ratingCount;
  final int stars;

  const OfferCard({
    super.key,
    required this.name,
    required this.price,
    required this.ratingCount,
    required this.stars,
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
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/images/user1.png"),
          ),
          Column(
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
                          children:
                              List.generate(
                                stars,
                                (index) =>
                                    Icon(Icons.star, color: yellow, size: 15),
                              )..add(
                                CustomText(
                                  "  $ratingCount completed",
                                  fontSize: 12,
                                  color: walletInfoTextColor,
                                  fontWeight: FontVariant.regular,
                                ),
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        CustomText(
                          "00:15",
                          fontSize: 12,
                          color: walletInfoTextColor,
                          fontWeight: FontVariant.regular,
                        ),

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
              CustomContainer(
                width: 254,
                height: 40,
                conColor: Colors.pricecolor,
                borderRadius: BorderRadius.circular(12),
                child: const Center(
                  child: CustomText(
                    "View Profile",
                    color: Colors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontVariant.semiBold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
