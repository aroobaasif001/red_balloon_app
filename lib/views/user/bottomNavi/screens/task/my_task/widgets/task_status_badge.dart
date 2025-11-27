import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../utils/colors.dart';

class TaskStatusBadge extends StatelessWidget {
  final String status;
  final Color textColor;
  final Color bgColor;

  const TaskStatusBadge({
    super.key,
    required this.status,
    this.textColor = const Color(0xff202020),
    this.bgColor = taskstatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomText(
        status,
        fontSize: 10,
        fontWeight: FontVariant.semiBold,
        color: textColor,
      ),
    );
  }
}
