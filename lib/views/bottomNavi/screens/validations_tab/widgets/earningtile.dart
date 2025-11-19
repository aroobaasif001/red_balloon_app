import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class EarningTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  const EarningTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      margin: const EdgeInsets.only(bottom: 14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                fontSize: 14,
                fontWeight: FontVariant.regular,
                color: totaTextColor,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Image(
                    image: AssetImage('assets/icons/fas5.png'),
                    height: 15,
                    width: 15,
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    date,
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ],
          ),

          /// RIGHT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                borderRadius: BorderRadius.circular(10),
                conColor: Colors.green.withOpacity(0.12),
                child: Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4),
                    CustomText(
                      "Correct",
                      fontSize: 12,
                      fontWeight: FontVariant.regular,
                      color: historyGreenColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              CustomText(
                amount,
                fontSize: 16,
                fontWeight: FontVariant.bold,
                color: historyGreenColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
