import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class UserProfileScreen extends StatelessWidget {
  final String userName;
  final String userInitials;
  final double rating;
  final int tasksCompleted;
  final int tasksRequested;
  final String? userId;
  final String? userPhoto;

  const UserProfileScreen({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.rating,
    required this.tasksCompleted,
    required this.tasksRequested,
    this.userId,
    this.userPhoto,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        titleText: 'User Profile',
        leadingIcon: Icons.arrow_back,
        titleFontSize: 24,
        titleFontWeight: FontVariant.bold,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// AVATAR SECTION
            Stack(
              children: [
                CustomContainer(
                  height: 120,
                  width: 120,
                  shape: BoxShape.circle,
                  conColor: redColor,
                  alignment: Alignment.center,
                  child:
                      userPhoto == null || userPhoto!.isEmpty
                          ? CustomText(
                            userInitials,
                            fontSize: 48,
                            fontWeight: FontVariant.bold,
                            color: whiteColor,
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              userPhoto!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: CustomContainer(
                    height: 28,
                    width: 28,
                    shape: BoxShape.circle,
                    conColor: const Color(0xffDC4137), // Status dot color
                    border: Border.all(color: whiteColor, width: 3),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// NAME
            CustomText(
              userName,
              fontSize: 26,
              fontWeight: FontVariant.bold,
              color: const Color(0xff333333),
            ),

            const SizedBox(height: 12),

            /// BADGES ROW 1 (ID & VERIFIED)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(
                  text: userId ?? "RB-452",
                  bgColor: const Color(0xffFFF1F1),
                  textColor: const Color(0xffFE7062),
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  text: "Verified",
                  bgColor: const Color(0xffE9F8F1),
                  textColor: const Color(0xff43A047),
                  icon: Icons.verified,
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ELITE TASKER BADGE
            _buildBadge(
              text: "Elite Tasker",
              bgColor: const Color(0xffE9F8F1),
              textColor: const Color(0xff43A047),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/star.png", // Assuming this exists or using a substitute icon
                    height: 20,
                    width: 20,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.stars, size: 20, color: Colors.orange),
                  ),
                  const SizedBox(width: 6),
                  const CustomText(
                    "Elite Tasker",
                    fontSize: 14,
                    color: Color(0xff43A047),
                    fontWeight: FontVariant.medium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// STATS CARDS
            _buildStatCard(
              label: "Total Tasks Completed",
              value: tasksCompleted.toString().padLeft(2, '0'),
            ),
            _buildStatCard(
              label: "Total Tasks Requested",
              value: tasksRequested.toString().padLeft(2, '0'),
            ),
            _buildStatCard(
              label: "User's Rating",
              value: rating.toStringAsFixed(1),
              isRating: true,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
    IconData? icon,
    Widget? child,
  }) {
    return CustomContainer(
      conColor: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      child: child ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.red, size: 18),
            const SizedBox(width: 6),
          ],
          CustomText(
            text,
            fontSize: 14,
            color: textColor,
            fontWeight: FontVariant.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    bool isRating = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: CustomContainer(
        conColor: whiteColor,
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              label,
              fontSize: 18,
              color: const Color(0xff666666),
              fontWeight: FontVariant.medium,
            ),
            Row(
              children: [
                if (isRating) ...[
                  const Icon(Icons.star, color: Color(0xffDC4137), size: 28),
                  const SizedBox(width: 8),
                ],
                CustomText(
                  value,
                  fontSize: 32,
                  fontWeight: FontVariant.bold,
                  color: const Color(0xff333333),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
