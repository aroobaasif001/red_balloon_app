import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../utils/colors.dart';

class TaskInfoTopRow extends StatelessWidget {
  const TaskInfoTopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// ---- Left Side ----
        Row(
          children: [
            Image.asset("assets/icons/location2.png", height: 16),
            const SizedBox(width: 6),

            const CustomText(
              "2.4 km away",
              fontSize: 12,
              fontWeight: FontVariant.medium,
            ),

            // const SizedBox(width: 12),
          ],
        ),

        Image.asset("assets/icons/dot.png", height: 16, width: 7),

        Row(
          children: [
            const CustomText(
              "SAR 1000",
              fontSize: 12,
              fontWeight: FontVariant.semiBold,
              color: pricecolor,
            ),

            // const SizedBox(width: 8),
          ],
        ),

        Image.asset("assets/icons/dot.png", height: 6, width: 6),

        Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: walletGrey600Color),
            const SizedBox(width: 6),

            const CustomText(
              "15 mins ago",
              fontSize: 12,
              fontWeight: FontVariant.regular,
              color: walletGrey600Color,
            ),
          ],
        ),
      ],
    );
  }
}
