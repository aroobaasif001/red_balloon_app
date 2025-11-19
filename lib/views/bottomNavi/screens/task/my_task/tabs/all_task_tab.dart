import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/post_new_task/post_new_task_screen.dart';

import 'clean_my_solar_panels.dart';

class AllTaskTab extends StatelessWidget {
  const AllTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText('My Tasks', fontSize: 24, fontWeight: FontVariant.bold),
          SizedBox(height: 15),
          CustomMyTaskCard(
            title: "Help needed move furniture",
            amount: "SAR 500",
            status: "Not accepted",
            postedTime: "Posted 2 hours ago",
            image: "assets/images/sofa.png",
            onEdit: () {
              Get.to(() => PostNewTaskScreen());
            },
          ),
          SizedBox(height: 26),
          CustomText('Active Tasks Near Me', fontSize: 24, fontWeight: FontVariant.bold),
          SizedBox(height: 15),
          CustomMyTaskCard(
            title: "Help needed move furniture",
            amount: "SAR 500",
            status: "Not accepted",
            postedTime: "Posted 2 hours ago",
            image: "assets/images/sofa.png",
            onEdit: () {
              Get.to(() => PostNewTaskScreen());
            },
            showButton: true,
            onViewDetails: () {
              Get.to(() => Cleanmysolarpanels());
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
