import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
class CompletedTaskItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String completedAgo;
  final String image;
  const CompletedTaskItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.completedAgo,
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      conColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          blurRadius: 3,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      price,
                      fontSize: 17,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      "Completed · $completedAgo",
                      fontSize: 14,
                      color: timeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CustomContainer(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    image,
                    width: 105,
                    height: 105,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: CustomButton(
              label: "Task Completed",
              textColor: Colors.white,
              fontSize: 16,
              borderRadius: BorderRadius.circular(10),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
