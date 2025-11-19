import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/widgets/task_status_badge.dart';

import '../../../../../../utils/colors.dart';

class TaskHeaderBar extends StatelessWidget {
  final String title;
  final String status;

  const TaskHeaderBar({
    super.key,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.arrow_back, size: 22),

        CustomText(
          title,
          fontSize: 17.5,
          fontWeight: FontVariant.semiBold,
          color: textcolord,
        ),
        TaskStatusBadge(
          status: status,
          textColor: greyColor,

          bgColor: appbard,
        ),
      ],
    );

  }
}
