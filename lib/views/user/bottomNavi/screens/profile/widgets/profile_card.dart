import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ProfileCard extends StatelessWidget {
  final String? avatarInitials;
  final String? photoURL;
  final String? userName;
  final String? location;
  final String? phoneNumber;
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
    this.photoURL,
    this.userName = 'Saad Sajid',
    this.location,
    this.phoneNumber,
    this.verificationLabel = 'Verified',
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
          color: (shadowColor ?? walletBlackColor).withOpacity(
            shadowOpacity ?? 0.25,
          ),
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
                  child: photoURL != null && photoURL!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            avatarSize ?? 100,
                          ),
                          child: Image.network(
                            photoURL!,
                            width: avatarSize,
                            height: avatarSize,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return CustomText(
                                avatarInitials ?? 'RB',
                                fontSize: (avatarSize ?? 100) * 0.4,
                                fontWeight: FontVariant.bold,
                                color: whiteColor,
                              );
                            },
                          ),
                        )
                      : CustomText(
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
                    border: Border.all(
                      color: avatarColor ?? redColor,
                      width: 2,
                    ),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                'Rating',
                fontSize: 16,
                fontWeight: FontVariant.bold,
                color: textColor2,
              ),
              CustomText(
                ' - (4.9)',
                fontSize: 16,
                fontWeight: FontVariant.bold,
                color: textColor2,
              ),
            ],
          ),
          const SizedBox(height: 13),
          // Location
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// VERIFIED BADGE (full row or left aligned)
              CustomContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                conColor: white3Color,
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/check_2.png',
                      height: 20,
                      width: 20,
                      color: red2Color,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      'Verified',
                      fontSize: 13,
                      fontWeight: FontVariant.regular,
                      color: greenColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),

              /// LOCATION ROW (only show if location is not empty)
              if (location != null && location!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 19, color: redColor),

                    /// Make ONLY text flexible
                    CustomText(
                      location!,
                      fontSize: locationFontSize ?? 12,
                      fontWeight: FontVariant.regular,
                      color: lastTextColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 2),

          // Phone Number (only show if phoneNumber is not empty)
          if (phoneNumber != null && phoneNumber!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, size: 19, color: redColor),
                CustomText(
                  '  $phoneNumber',
                  fontSize: 12,
                  fontWeight: FontVariant.medium,
                  color: grey4Color,
                ),
              ],
            ),
          if (phoneNumber != null && phoneNumber!.isNotEmpty)
            const SizedBox(height: 5),
          // Loyalty Points
          CustomText(
            'Posted Tasks: 09',
            fontSize: 12,
            fontWeight: FontVariant.medium,
            color: grey4Color,
          ),
          const SizedBox(height: 5),

          CustomText(
            'Helped Tasks: 09',
            fontSize: 12,
            fontWeight: FontVariant.medium,
            color: grey4Color,
          ),
        ],
      ),
    );
  }
}
