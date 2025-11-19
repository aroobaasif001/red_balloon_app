import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

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

      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage("assets/images/user1.png"),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    name,
                    fontSize: 14,
                    fontWeight: FontVariant.semiBold,
                  ),
                  Row(
                    children:
                        List.generate(
                          stars,
                          (index) => Icon(Icons.star, color: yellow, size: 15),
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
          const SizedBox(height: 14),
          Container(
            width: 254,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.pricecolor,
              borderRadius: BorderRadius.circular(12),
            ),
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
    );
  }
}
