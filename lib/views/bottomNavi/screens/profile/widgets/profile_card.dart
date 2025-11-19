import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ProfileCard extends StatelessWidget {
  final String? avatarInitials;
  final String? userName;
  final String? location;
  final String? verificationLabel;
  final String? loyaltyPoints;
  final Color? avatarColor;
  final Color? containerColor;
  final Color? shadowColor;
  final double? shadowBlur;
  final double? shadowOpacity;
  final double? avatarSize;
  final double? namefontSize;
  final double? locationFontSize;
  final VoidCallback? onAvatarTap;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const ProfileCard({
    super.key,
    this.avatarInitials = 'RB',
    this.userName = 'Saad Sajid',
    this.location = 'Riyadh, Saudi Arabia',
    this.verificationLabel = 'Verified Requester',
    this.loyaltyPoints = 'Your Loyalty Points: 05',
    this.avatarColor,
    this.containerColor,
    this.shadowColor,
    this.shadowBlur = 4,
    this.shadowOpacity = 0.25,
    this.avatarSize = 100,
    this.namefontSize = 22,
    this.locationFontSize = 14,
    this.onAvatarTap,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: padding,
      conColor: containerColor ?? white2Color,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? walletBlackColor).withOpacity(shadowOpacity ?? 0.25),
          blurRadius: shadowBlur ?? 4,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        children: [
          // Avatar with Badge
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: avatarColor ?? redColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomText(
                    avatarInitials ?? 'RB',
                    fontSize: (avatarSize ?? 100) * 0.4,
                    fontWeight: FontVariant.bold,
                    color: whiteColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAvatarTap,
                child: CustomContainer(
                  width: 32,
                  height: 32,
                  conColor: avatarColor ?? redColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: whiteColor, width: 2),
                  child: CustomContainer(
                    width: 30,
                    height: 30,
                    conColor: avatarColor ?? redColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: avatarColor ?? redColor, width: 2),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: whiteColor,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          CustomText(
            userName ?? 'Saad Sajid',
            fontSize: namefontSize ?? 22,
            fontWeight: FontVariant.bold,
            color: textColor2,
          ),
          const SizedBox(height: 4),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 19, color: blackColor),
              const SizedBox(width: 4),
              CustomText(
                location ?? 'Riyadh, Saudi Arabia',
                fontSize: locationFontSize ?? 14,
                fontWeight: FontVariant.regular,
                color: grey5Color,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Verified Badge
          CustomContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            conColor: white3Color,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/check_2.png',
                  height: 24,
                  width: 24,
                  color: red2Color,
                ),
                const SizedBox(width: 6),
                CustomText(
                  verificationLabel ?? 'Verified Requester',
                  fontSize: 12,
                  fontWeight: FontVariant.medium,
                  color: greenColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Loyalty Points
          CustomText(
            loyaltyPoints ?? 'Your Loyalty Points: 05',
            fontSize: 12,
            fontWeight: FontVariant.regular,
            color: grey4Color,
          ),
        ],
      ),
    );
  }
}
