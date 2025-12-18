import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ProviderCard extends StatelessWidget {
  final String initials;
  final String name;
  final String id;
  final String rating;
  final String description;
  final String price;
  final String distance;
  final String? userPhoto;

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
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: CustomContainer(
        conColor: whiteColor,
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.all(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP SECTION: AVATAR & INFO
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// AVATAR
                CustomContainer(
                  height: 60,
                  width: 60,
                  shape: BoxShape.circle,
                  conColor: redColor,
                  alignment: Alignment.center,
                  child: userPhoto == null || userPhoto!.isEmpty
                      ? CustomText(
                          initials,
                          fontSize: 24,
                          fontWeight: FontVariant.bold,
                          color: whiteColor,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            userPhoto!,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(width: 12),

                /// NAME, ID, RATING
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomText(
                              name,
                              fontSize: 18,
                              fontWeight: FontVariant.bold,
                              color: const Color(0xff333333),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildBadge(
                            text: id.isEmpty ? 'RB-124' : id,
                            bgColor: const Color(0xffFFF1F1),
                            textColor: const Color(0xffFE7062),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Color(0xffDC4137)),
                          const SizedBox(width: 4),
                          CustomText(
                            rating,
                            fontSize: 14,
                            fontWeight: FontVariant.bold,
                            color: const Color(0xff333333),
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            description,
                            fontSize: 13,
                            color: const Color(0xff666666),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// PRICE & DISTANCE ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      distance,
                      fontSize: 13,
                      color: const Color(0xffFE7062),
                      fontWeight: FontVariant.medium,
                    ),
                  ],
                ),
                CustomText(
                  price,
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                  color: const Color(0xff333333),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ACTION BUTTONS
            Row(
              children: [
                _buildActionButton(
                  "View Profile",
                  onViewProfile,
                  isSecondary: true,
                ),
                const SizedBox(width: 8),
                _buildActionButton("Accept", onAccept),
                const SizedBox(width: 8),
                _buildActionButton("Chat", onChat, isSecondary: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return CustomContainer(
      conColor: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      borderRadius: BorderRadius.circular(6),
      child: CustomText(
        text,
        fontSize: 12,
        color: textColor,
        fontWeight: FontVariant.medium,
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    VoidCallback? onTap, {
    bool isSecondary = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: CustomContainer(
          height: 44,
          borderRadius: BorderRadius.circular(10),
          alignment: Alignment.center,
          conColor: isSecondary ? const Color(0xffF5F5F5) : redColor,
          child: CustomText(
            label,
            color: isSecondary ? const Color(0xff666666) : whiteColor,
            fontSize: 13,
            fontWeight: FontVariant.semiBold,
          ),
        ),
      ),
    );
  }
}
