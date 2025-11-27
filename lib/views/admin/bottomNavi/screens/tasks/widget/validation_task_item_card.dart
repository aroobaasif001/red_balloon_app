import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ValidationTaskItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String startedAgo;
  final String image;

  const ValidationTaskItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.startedAgo,
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

          /// 🔵 TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TEXT (Flexible to avoid overflow)
              Flexible(
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
                    const SizedBox(height: 8),
                    CustomText(
                      price,
                      fontSize: 17,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 3),
                    CustomText(
                      startedAgo,
                      fontSize: 14,
                      color: timeColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// IMAGE
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
                    width: 110,
                    height: 105,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// 🔴 BOTTOM ROW
          Row(
            children: [

              /// BADGE
              CustomContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                borderRadius: BorderRadius.circular(30),
                conColor: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                child: const CustomText(
                  "Validation in progress",
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),

              /// VIEW DETAILS BUTTON
              SizedBox(
                height: 40,
                width: 115,
                child: CustomButton(
                  label: "View Details",
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
