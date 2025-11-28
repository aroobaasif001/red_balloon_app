import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../../utils/colors.dart';

class ProgressBarTile extends StatelessWidget {
  final String title;
  final double percent;

  const ProgressBarTile({
    super.key,
    required this.title,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(title,
              fontSize: 14,
              fontWeight: FontVariant.regular,
              color:textcolord,
            ),
            Text("${(percent * 100).round()}%"),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 7,
            color: redColor,
            backgroundColor: white2Color,
          ),
        ),
      ],
    );
  }
}
