import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ReviewCard extends StatelessWidget {
  final String initials;
  final String id;
  final String review;
  final String time;

  const ReviewCard({
    super.key,
    required this.initials,
    required this.id,
    required this.review,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          blurRadius: 3,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row with initials + ID + stars
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: CustomText(
                  initials,
                  fontSize: 16,
                  fontWeight: FontVariant.bold,
                  color: redColor,
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    id,
                    fontSize: 14,
                    fontWeight: FontVariant.bold,
                    color: Colors.black,
                  ),

                  /// Stars Row
                  Row(
                    children: const [
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                      Icon(Icons.star, size: 16, color: redColor),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Review text
          CustomText(
            review,
            fontSize: 14,
            color: Colors.black87,
          ),

          const SizedBox(height: 12),

          /// Time
          CustomText(
            time,
            fontSize: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
