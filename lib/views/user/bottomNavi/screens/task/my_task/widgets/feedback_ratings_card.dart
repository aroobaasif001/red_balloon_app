import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_completed_controller.dart';

class FeedbackRatingsCard extends StatelessWidget {
  final TaskCompletedController controller;

  const FeedbackRatingsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          spreadRadius: 0,
          blurRadius: 4,
          color: blackColor.withOpacity(0.25),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Feedback & Ratings",
              fontSize: 16,
              fontWeight: FontVariant.bold,
              color: textcolord,
            ),
            const SizedBox(height: 16),
            Obx(
              () => Column(
                children: controller.reviews.map((review) {
                  return CustomContainer(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    conColor: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              review['name'],
                              fontSize: 14,
                              fontWeight: FontVariant.semiBold,
                              color: textcolord,
                            ),
                            CustomText(
                              review['time'],
                              fontSize: 11,
                              color: grey2Color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
                        CustomText(
                          review['review'],
                          fontSize: 12,
                          color: rbtxColor,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
