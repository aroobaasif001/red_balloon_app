import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../utils/colors.dart';

class TaskHeaderBar extends StatelessWidget {
  final String title;
  final String status;

  const TaskHeaderBar({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Icon(Icons.arrow_back, size: 22),
            ),
          ),

          CustomText(
            title,
            fontSize: 18,
            fontWeight: FontVariant.semiBold,
            color: textcolord,
          ),
        ],
      ),
    );
  }
}
