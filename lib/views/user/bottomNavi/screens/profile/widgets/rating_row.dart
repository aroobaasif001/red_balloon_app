import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class RatingRow extends StatelessWidget {
  final String star;
  final double fill;
  final String count;

  const RatingRow({
    super.key,
    required this.star,
    required this.fill,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 23),
      child: Row(
        children: [
          /// Number + Red Star
          Row(
            children: [
              CustomText(
                star,
                fontSize: 14,
                color: Colors.black,
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.star,
                color: redColor,
                size: 16,
              ),
            ],
          ),

          const SizedBox(width: 10),

          /// Progress bar
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Count (70)
          CustomText(
            "($count)",
            fontSize: 14,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
