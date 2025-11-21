import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ProviderCard extends StatelessWidget {
  final String initials;
  final String name;
  final String id;
  final String rating;
  final String description;
  final String price;
  final String distance;

  final VoidCallback? onViewProfile;
  final VoidCallback? onAccept;
  final VoidCallback? onChat;

  const ProviderCard({
    super.key,
    required this.initials,
    required this.name,
    required this.id,
    required this.rating,
    required this.description,
    required this.price,
    required this.distance,
    this.onViewProfile,
    this.onAccept,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CustomContainer(
        conColor: Colors.white,
        borderRadius: BorderRadius.circular(22),
        padding: const EdgeInsets.all(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// AVATAR CIRCLE
                CustomContainer(
                  height: 50,
                  width: 50,
                  shape: BoxShape.circle,
                  conColor: redColor.withOpacity(0.12),
                  alignment: Alignment.center,
                  child: CustomText(
                    initials,
                    fontSize: 20,
                    fontWeight: FontVariant.bold,
                    color: redColor,
                  ),
                ),

                const SizedBox(width: 14),

                /// NAME + TAG + RATING
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME + TAG
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            name,
                            fontSize: 18,
                            fontWeight: FontVariant.bold,
                          ),

                          CustomContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            conColor: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                            child: CustomText(
                              id,
                              fontSize: 12,
                              color: redColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// RATING ROW
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 20, color: Color(0xfff7d400)),
                          const SizedBox(width: 5),
                          CustomText(
                            rating,
                            fontSize: 14,
                            fontWeight: FontVariant.semiBold,
                            color: redColor,
                          ),
                          const SizedBox(width: 6),
                          CustomText(
                            description,
                            fontSize: 13,
                            color: redColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// PRICE + DISTANCE
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              price,
                              fontSize: 20,
                              fontWeight: FontVariant.bold,
                            ),
                            CustomText(
                              distance,
                              fontSize: 13,
                              color: redColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// BUTTONS ROW
            Row(
              children: [
                buildButton("View Profile", onViewProfile),
                buildButton("Accept", onAccept),
                buildButton("Chat", onChat),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// BUTTON WIDGET WITH onTap SUPPORT
  Widget buildButton(String label, VoidCallback? onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: onTap,
          child: CustomContainer(
            height: 40,
            borderRadius: BorderRadius.circular(15),
            alignment: Alignment.center,
            conColor: redColor,
            child: CustomText(
              label,
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontVariant.regular,
            ),
          ),
        ),
      ),
    );
  }
}
