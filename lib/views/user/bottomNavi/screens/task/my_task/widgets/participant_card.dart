import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ParticipantCard extends StatelessWidget {
  final String name;
  final String id;
  final String tasksCompleted;
  final double rating;

  const ParticipantCard({
    super.key,
    required this.name,
    required this.id,
    required this.tasksCompleted,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(12),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: redColor.withOpacity(0.1),
            child: CustomText(
              name[0],
              fontSize: 18,
              fontWeight: FontVariant.bold,
              color: redColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  name,
                  fontSize: 14,
                  fontWeight: FontVariant.semiBold,
                  color: textcolord,
                ),
                const SizedBox(height: 4),
                CustomText(id, fontSize: 11, color: grey2Color),
                const SizedBox(height: 2),
                CustomText(tasksCompleted, fontSize: 11, color: grey2Color),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.star, color: yellow, size: 16),
              const SizedBox(width: 4),
              CustomText(
                rating.toStringAsFixed(1),
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
