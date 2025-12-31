import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/user_profile_controller.dart';

import '../widgets/rating_row.dart';
import '../widgets/reviewcard.dart';

class ReviewsAndFeedback extends StatelessWidget {
  const ReviewsAndFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final controller = Get.put(
      UserProfileController(userUid: currentUserUid),
      tag: 'current_user_reviews',
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: CustomAppBar(
          titleText: 'Reviews & Feedback',
          titleFontSize: 20,
          titleFontWeight: FontVariant.bold,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: redColor));
          }

          final avgRating = controller.averageRating.value;
          final totalReviews = controller.totalReviews.value;

          return SingleChildScrollView(
            child: Column(
              children: [
                /// BODY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      /// ⭐ RATING SECTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            avgRating.toStringAsFixed(1),
                            fontSize: 28,
                            fontWeight: FontVariant.bold,
                            color: redColor,
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.star, color: redColor, size: 28),
                          const SizedBox(width: 5),
                          CustomText(
                            "/ 5",
                            fontSize: 18,
                            fontWeight: FontVariant.regular,
                            color: timeColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      CustomText(
                        "Based on $totalReviews reviews",
                        fontSize: 14,
                        fontWeight: FontVariant.regular,
                        color: lastTextColor,
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        "Your trust helps our community grow!",
                        fontSize: 14,
                        color: blackLightColor,
                        fontWeight: FontVariant.regular,
                      ),
                      const SizedBox(height: 15),

                      /// ⭐ RATING BARS
                      _buildRatingBars(controller),
                      const SizedBox(height: 30),

                      /// --- RECENT REVIEWS TITLE ---
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          "Recent Reviews",
                          fontSize: 16,
                          fontWeight: FontVariant.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// REVIEWS LIST
                      if (controller.feedbacks.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: CustomText(
                            "No reviews yet.",
                            fontSize: 14,
                            color: grey2Color,
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.feedbacks.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final feedback = controller.feedbacks[index];
                            final initials = (feedback['reviewerName'] ?? 'RB')
                                .toString()
                                .split(' ')
                                .map((e) => e.isNotEmpty ? e[0] : '')
                                .join()
                                .toUpperCase();

                            return ReviewCard(
                              initials: initials.isEmpty ? 'RB' : initials,
                              id: feedback['reviewerName'] ?? 'Anonymous',
                              review: feedback['review'] ?? 'No comment provided.',
                              // Assuming we don't have a specific "days ago" logic here like the mockup, 
                              // we can use a helper to format the date
                              time: _formatDate(feedback['createdAt']),
                            );
                          },
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRatingBars(UserProfileController controller) {
    // Count occurrences of each star
    Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var f in controller.feedbacks) {
      int rating = (f['rating'] ?? 0).toInt();
      if (rating >= 1 && rating <= 5) {
        counts[rating] = (counts[rating] ?? 0) + 1;
      }
    }

    int total = controller.totalReviews.value;

    return Column(
      children: [5, 4, 3, 2, 1].map((star) {
        int count = counts[star] ?? 0;
        double fill = total > 0 ? count / total : 0;
        return RatingRow(
          star: star.toString(),
          fill: fill,
          count: count.toString(),
        );
      }).toList(),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'just now';
    DateTime date;
    if (timestamp is DateTime) {
      date = timestamp;
    } else {
      try {
        date = (timestamp as dynamic).toDate();
      } catch (e) {
        return 'Recently';
      }
    }

    final diff = DateTime.now().difference(date);
    if (diff.inDays > 30) return "${(diff.inDays / 30).floor()} months ago";
    if (diff.inDays > 7) return "${(diff.inDays / 7).floor()} weeks ago";
    if (diff.inDays >= 1) return "${diff.inDays} days ago";
    if (diff.inHours >= 1) return "${diff.inHours} hours ago";
    return "just now";
  }
}
