import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../../utils/colors.dart';

class StatsSmallCard extends StatelessWidget {
  final String imagePath; // 🔥 icon ki jagah image
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
      width: (MediaQuery.of(context).size.width / 2) - 22,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white2Color,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: bordercol, width: 1),
          right: BorderSide(color: bordercol, width: 1),
          left: BorderSide(color: bordercol, width: 1),
        ),         boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.25),
            blurRadius: 1,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Replace Icon with Image
          Image.asset(imagePath, height: 26, width: 26, fit: BoxFit.contain),

          const SizedBox(height: 10),

          CustomText(
            title,
            color: greyColor,
            fontWeight: FontVariant.regular,
            fontSize: 12,
          ),

          const SizedBox(height: 6),

          CustomText(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
