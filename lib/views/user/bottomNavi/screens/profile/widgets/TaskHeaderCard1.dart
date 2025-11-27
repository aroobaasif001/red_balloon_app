import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class TaskHeaderCard extends StatelessWidget {
  const TaskHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: rbcolor,
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/sofa.png",
              height: 80,
              width: 106,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Help Move Furniture",
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                  color:blackColor,
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    CustomText(
                      "500 SAR",
                      fontSize: 16,
                      fontWeight: FontVariant.bold,
                      color: redColor,
                    ),

                    const SizedBox(width: 25),

                    Icon(Icons.watch_later_outlined,
                        size: 16, color:grey4Color),

                    const SizedBox(width: 4),

                    CustomText(
                      "2 min ago",
                      fontSize: 13,
                      color: grey4Color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
