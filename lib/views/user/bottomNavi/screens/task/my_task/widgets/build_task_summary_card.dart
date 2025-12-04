import 'package:flutter/material.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/in_progress_task_controller.dart';

/// TASK SUMMARY CARD: title, price, location, posted time
Widget buildTaskSummaryCard(
  InProgressTaskController controller,
  String timeAgo,
  String price,
  String,
  title,
  String location,
) {
  return CustomContainer(
    width: double.infinity,
    conColor: white2Color,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title,
              fontSize: 15,
              fontWeight: FontVariant.semiBold,
              color: textcolord,
            ),
            const SizedBox(height: 8),
            CustomText(
              'SAR ${price} 	 ${location}',
              fontSize: 14,
              fontWeight: FontVariant.semiBold,
              color: rbtxColor,
            ),
            const SizedBox(height: 4),
            CustomText(
              'Posted ${timeAgo}',
              fontSize: 12,
              color: walletInfoTextColor,
              fontWeight: FontVariant.regular,
            ),
          ],
        ),
      ],
    ),
  );
}
