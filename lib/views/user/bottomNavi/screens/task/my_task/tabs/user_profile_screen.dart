import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:intl/intl.dart';
import '../controller/user_profile_controller.dart';
import '../../../profile/controller/in_app_store_controller.dart';

class UserProfileScreen extends StatelessWidget {
  final String userName;
  final String userInitials;
  final double rating;
  final int tasksCompleted;
  final int tasksRequested;
  final String? userId;
  final String? userUid; // 🔥 Added for DB queries
  final String? userPhoto;

  const UserProfileScreen({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.rating,
    required this.tasksCompleted,
    required this.tasksRequested,
    this.userId,
    this.userUid,
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      UserProfileController(userUid: userUid ?? ''),
      tag: userUid,
    );

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
                  child: userPhoto == null || userPhoto!.isEmpty
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
                    conColor: dotColor, // Status dot color
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
              color: textColor2,
            ),

            const SizedBox(height: 12),

            /// BADGES ROW 1 (ID & VERIFIED)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(
                  text: (userId == null || userId!.isEmpty) ? "RB-0000" : userId!,
                  bgColor: whiteLightColor,
                  textColor: redLightColor,
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  text: "Verified",
                  bgColor: greenbgColor,
                  textColor: greenColor,
                  icon: Icons.verified,
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// DYNAMIC MOST EXPENSIVE BADGE (Specific to viewed user)
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: WalletService().getOwnedBadgesStreamByUid(
                (userUid != null && userUid!.isNotEmpty)
                    ? userUid!
                    : (userId != null && userId!.startsWith('RB-')
                        ? "" // Can't query by RB-ID directly without search
                        : (userId ?? "")),
              ),
              builder: (context, snapshot) {
                // Debug print for developer console
                print('🔍 UserProfileScreen Badge Debug:');
                print('   userUid: $userUid');
                print('   userId: $userId');
                if (snapshot.hasError) print('   Error: ${snapshot.error}');
                if (snapshot.hasData) {
                  print('   Badges found: ${snapshot.data!.length}');
                } else {
                  print('   No data yet');
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }

                final bestBadge =
                    InAppStoreController.getMostExpensiveFromList(
                        snapshot.data!);

                if (bestBadge == null) {
                  print('   Best badge is null after filtering master list');
                  return const SizedBox.shrink();
                }

                print('   Displaying best badge: ${bestBadge['title']}');

                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: _buildBadge(
                    text: bestBadge['title'],
                    bgColor: greenbgColor,
                    textColor: greenColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          bestBadge['image'],
                          height: 20,
                          width: 20,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.stars,
                                  size: 20, color: orangeColor),
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          bestBadge['title'],
                          fontSize: 14,
                          color: greenColor,
                          fontWeight: FontVariant.medium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            /// STATS CARDS
            Obx(() => _buildStatCard(
              label: "Tasks Completed (Helper)",
              value: (controller.isLoading.value && tasksCompleted > 0)
                  ? tasksCompleted.toString().padLeft(2, '0')
                  : controller.tasksCompleted.value.toString().padLeft(2, '0'),
            )),
            Obx(() => _buildStatCard(
              label: "Tasks Requested",
              value: (controller.isLoading.value && tasksRequested > 0)
                  ? tasksRequested.toString().padLeft(2, '0')
                  : controller.tasksRequested.value.toString().padLeft(2, '0'),
            )),
            Obx(() => _buildStatCard(
              label: "User's Rating",
              value: (controller.isLoading.value) 
                  ? rating.toStringAsFixed(1)
                  : (controller.totalReviews.value == 0 ? rating.toStringAsFixed(1) : controller.averageRating.value.toStringAsFixed(1)),
              isRating: true,
            )),

            const SizedBox(height: 32),

            /// FEEDBACKS SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "User Feedbacks",
                    fontSize: 20,
                    fontWeight: FontVariant.bold,
                    color: textColor2,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: redColor),
                      );
                    }
                    if (controller.feedbacks.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: CustomText(
                            "No feedbacks available yet.",
                            fontSize: 14,
                            color: grey2Color,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.feedbacks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final feedback = controller.feedbacks[index];
                        return _buildFeedbackItem(feedback);
                      },
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackItem(Map<String, dynamic> feedback) {
    final double ratingValue = (feedback['rating'] ?? 0).toDouble();
    final DateTime date = feedback['createdAt'] is Timestamp 
        ? (feedback['createdAt'] as Timestamp).toDate()
        : DateTime.tryParse(feedback['createdAt']?.toString() ?? '') ?? DateTime.now();
    
    return CustomContainer(
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      border: Border.all(color: greyLiteColor.withOpacity(0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      feedback['reviewerName'] ?? 'Anonymous',
                      fontSize: 14,
                      fontWeight: FontVariant.bold,
                      color: textColor2,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      "on \"${feedback['taskTitle']}\"",
                      fontSize: 12,
                      color: grey2Color,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: dotColor, size: 16),
                      const SizedBox(width: 4),
                      CustomText(
                        ratingValue.toStringAsFixed(1),
                        fontSize: 14,
                        fontWeight: FontVariant.bold,
                        color: textColor2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    DateFormat('MMM d, yyyy').format(date),
                    fontSize: 11,
                    color: grey2Color,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomText(
            feedback['review'] ?? 'No comment provided.',
            fontSize: 13,
            color: lastTextColor,
            fontWeight: FontVariant.regular,
          ),
          const SizedBox(height: 8),
          _buildBadge(
            text: feedback['role'] ?? 'User',
            bgColor: whiteLightColor,
            textColor: redLightColor,
          ).paddingOnly(top: 4),
        ],
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
      child:
          child ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: redColor, size: 18),
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
            color: blackColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
              width: 210,
              child: CustomText(
                label,
                fontSize: 17,
                color: lastTextColor,
                fontWeight: FontVariant.medium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                if (isRating) ...[
                  const Icon(Icons.star, color: dotColor, size: 28),
                  const SizedBox(width: 8),
                ],
                CustomText(
                  value,
                  fontSize: 26,
                  fontWeight: FontVariant.bold,
                  color: textColor2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
