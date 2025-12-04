import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class UserProfileScreen extends StatelessWidget {
  final String userName;
  final String userInitials;
  final double rating;
  final int tasksCompleted;
  final int tasksRequested;

  const UserProfileScreen({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.rating,
    required this.tasksCompleted,
    required this.tasksRequested,
  });

  Widget _ratingBar(String label, double value) {
    return Row(
      children: [
        CustomText(
          label,
          fontSize: 12,
          color: whiteColor,
          fontWeight: FontVariant.medium,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: whiteColor.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation(yellow),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        CustomText(
          "${(value * 100).toInt()}%",
          fontSize: 11,
          color: whiteColor,
          fontWeight: FontVariant.medium,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// BACK ARROW + TITLE
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back,
                      color: whiteColor,
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: CustomText(
                        "User Profile",
                        fontSize: 18,
                        fontWeight: FontVariant.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            /// MAIN PROFILE CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// RED AVATAR WITH BADGE
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomContainer(
                            height: 100,
                            width: 100,
                            shape: BoxShape.circle,
                            conColor: redColor,
                            alignment: Alignment.center,
                            child: CustomText(
                              userInitials, // 🔥 Real initials
                              fontSize: 45,
                              fontWeight: FontVariant.bold,
                              color: whiteColor,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CustomContainer(
                              height: 24,
                              width: 24,
                              conColor: redColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: whiteColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// NAME
                      CustomText(
                        userName, // 🔥 Real name
                        fontSize: 22,
                        fontWeight: FontVariant.bold,
                      ),
                      const SizedBox(height: 12),

                      /// BADGES ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// RB TAG
                          CustomContainer(
                            conColor: lightredcolor2,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: const CustomText(
                              "RB-452",
                              fontSize: 11,
                              color: redColor,
                              fontWeight: FontVariant.semiBold,
                            ),
                          ),
                          const SizedBox(width: 8),

                          /// VERIFIED BADGE
                          CustomContainer(
                            conColor: greenBg,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: redColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                const CustomText(
                                  "Verified",
                                  fontSize: 11,
                                  color: walletSuccessColor,
                                  fontWeight: FontVariant.semiBold,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          /// ELITE TASKER BADGE
                          CustomContainer(
                            conColor: const Color(0xFFFFF3E0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/icons/star.png",
                                  height: 14,
                                  width: 14,
                                ),
                                const SizedBox(width: 4),
                                const CustomText(
                                  "Elite Tasker",
                                  fontSize: 11,
                                  color: Color(0xFFF57C00),
                                  fontWeight: FontVariant.semiBold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      /// USER RATING CARD
                      CustomContainer(
                        conColor: white2Color,
                        borderRadius: BorderRadius.circular(14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              "User's Rating",
                              fontSize: 14,
                              color: textcolord,
                              fontWeight: FontVariant.medium,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: redColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                CustomText(
                                  rating.toStringAsFixed(1), // 🔥 Real rating
                                  fontSize: 18,
                                  fontWeight: FontVariant.bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// STATS CARD (RED BACKGROUND)
                      CustomContainer(
                        conColor: redColor,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          "Total Tasks Completed",
                                          fontSize: 13,
                                          color: whiteColor,
                                          fontWeight: FontVariant.medium,
                                        ),
                                        const SizedBox(height: 8),
                                        CustomText(
                                          tasksCompleted
                                              .toString()
                                              .padLeft(2, '0'), // 🔥 Real count
                                          fontSize: 28,
                                          fontWeight: FontVariant.bold,
                                          color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          "Total Tasks Requested",
                                          fontSize: 13,
                                          color: whiteColor,
                                          fontWeight: FontVariant.medium,
                                        ),
                                        const SizedBox(height: 8),
                                        CustomText(
                                          tasksRequested
                                              .toString()
                                              .padLeft(2, '0'), // 🔥 Real count
                                          fontSize: 28,
                                          fontWeight: FontVariant.bold,
                                          color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: Image.asset(
                                "assets/icons/white_balloon.png",
                                height: 90,
                                width: 90,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// USER RATING BREAKDOWN
                      CustomContainer(
                        conColor: redColor,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: Column(
                          children: [
                            CustomContainer(
                              conColor: redColor,
                              borderRadius: BorderRadius.circular(16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    "User Rating",
                                    fontSize: 16,
                                    fontWeight: FontVariant.bold,
                                    color: whiteColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          const CustomText(
                                            "4.8",
                                            fontSize: 28,
                                            fontWeight: FontVariant.bold,
                                            color: whiteColor,
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: yellow,
                                                size: 24,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: yellow,
                                                size: 24,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: yellow,
                                                size: 24,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: yellow,
                                                size: 24,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: yellow,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          const CustomText(
                                            "234 reviews",
                                            fontSize: 12,
                                            color: whiteColor,
                                            fontWeight: FontVariant.medium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            _ratingBar("5 ★", 0.75),
                                            const SizedBox(height: 8),
                                            _ratingBar("4 ★", 0.15),
                                            const SizedBox(height: 8),
                                            _ratingBar("3 ★", 0.07),
                                            const SizedBox(height: 8),
                                            _ratingBar("2 ★", 0.02),
                                            const SizedBox(height: 8),
                                            _ratingBar("1 ★", 0.01),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// REVIEWS SECTION
                            CustomContainer(
                              conColor: redColor,
                              borderRadius: BorderRadius.circular(16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              child: Column(
                                children: [
                                  /// REVIEW 1
                                  CustomContainer(
                                    conColor: whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const CustomText(
                                              "Michael Chen",
                                              fontSize: 14,
                                              fontWeight: FontVariant.bold,
                                            ),
                                            const CustomText(
                                              "2 weeks ago",
                                              fontSize: 11,
                                              color: timeColor,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5,
                                                (index) => Icon(
                                                  Icons.star,
                                                  color: yellow,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const CustomText(
                                          "Absolutely stunning paint! They arrived healthy and vibrant. The colors are even better in person. The seller packaged them perfectly with the pots and the fish adapted quickly to my tank. Highly recommended!",
                                          fontSize: 12,
                                          color: textcolord,
                                          fontWeight: FontVariant.regular,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  /// REVIEW 2
                                  CustomContainer(
                                    conColor: whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const CustomText(
                                              "Sarah Johnson",
                                              fontSize: 14,
                                              fontWeight: FontVariant.bold,
                                            ),
                                            const CustomText(
                                              "1 month ago",
                                              fontSize: 11,
                                              color: timeColor,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5,
                                                (index) => Icon(
                                                  Icons.star,
                                                  color: yellow,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const CustomText(
                                          "Beautiful discus pair. Arrived on time and in perfect condition. They're eating well and have great temperament. The seller was very responsive to questions.",
                                          fontSize: 12,
                                          color: textcolord,
                                          fontWeight: FontVariant.regular,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  /// READ ALL REVIEWS BUTTON
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          "Read All 234 Reviews",
                                          fontSize: 13,
                                          color: whiteColor,
                                          fontWeight: FontVariant.semiBold,
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: whiteColor,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
