import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

// IMPORT SEPARATE WIDGETS
import 'package:red_balloon_app/views/bottomNavi/screens/profile/widgets/rating_row.dart';
import '../widgets/reviewcard.dart';

class ReviewsAndFeedback extends StatefulWidget {
  const ReviewsAndFeedback({super.key});

  @override
  State<ReviewsAndFeedback> createState() => _ReviewsAndFeedbackState();
}

class _ReviewsAndFeedbackState extends State<ReviewsAndFeedback> {

  List<bool> isOpenList = [false, false, false, false, false];

  String mainAnswer =
      "To post a new task:\n1. Go to the Create Task section.\n2. Enter your task details (title, description, deadline, budget, etc.).\n3. Upload any required files (optional).\n4. Submit the task. Once submitted, your task becomes visible to validators who can review and accept it.";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// APP BAR
              CustomAppBar1(
                title: 'Reviews & Feedback',
                showRightImage: false,
              ),
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
                          "4.8",
                          fontSize: 28,
                          fontWeight: FontVariant.bold,
                          color: redColor,
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.star, color: Colors.red, size: 28),
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
                      "Based on 87 reviews",
                      fontSize: 14,
                      color: timeColor,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      "Your trust helps our community grow!",
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15),
                    /// ⭐ RATING BARS (USING SEPARATE CLASS)
                    Column(
                      children: const [
                        RatingRow(star: "5", fill: 0.85, count: "70"),
                        RatingRow(star: "4", fill: 0.20, count: "13"),
                        RatingRow(star: "3", fill: 0.08, count: "4"),
                        RatingRow(star: "2", fill: 0.00, count: "0"),
                        RatingRow(star: "1", fill: 0.00, count: "0"),
                      ],
                    ),
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
                    /// FIRST REVIEW (USING SEPARATE CLASS)
                    const ReviewCard(
                      initials: "RB",
                      id: "RB-452",
                      review:
                      "Excellent helper, very efficient and friendly. Cleaned the solar panels perfectly!",
                      time: "2 days ago",
                    ),
                    const SizedBox(height: 15),
                    /// SECOND REVIEW
                    const ReviewCard(
                      initials: "AB",
                      id: "RB-102",
                      review:
                      "Very satisfied with the quick response and professional service. Will definitely use again!",
                      time: "1 week ago",
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
