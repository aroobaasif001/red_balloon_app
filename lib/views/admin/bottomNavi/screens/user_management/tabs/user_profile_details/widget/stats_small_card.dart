import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../../utils/colors.dart';

class StatsSmallCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;

  const StatsSmallCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 30,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Image.asset(
            imagePath,
            height: 26,
            width: 26,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 10),

          CustomText(
            title,
            style: const TextStyle(
              color:greyColor,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 6),

          CustomText(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
