import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../../utils/colors.dart';

class RatingSummaryCard extends StatelessWidget {
  final double rating;
  final int completed;

  const RatingSummaryCard({
    super.key,
    required this.rating,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white2Color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.25),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: yellow, size: 28),
              const SizedBox(width: 6),
              CustomText(
                rating.toString(),
                fontSize: 30,
                fontWeight: FontVariant.bold,
                alignment: Alignment.center,
              ),
            ],
          ),
          Column(
            children: [
              const CustomText(
                "Tasks Completed",
                fontSize: 14,
                fontWeight: FontVariant.regular,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  completed.toString(),
                  fontSize: 24,
                  fontWeight: FontVariant.bold,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

