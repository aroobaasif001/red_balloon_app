import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_in_progress_screen.dart';

import '../../post_new_task/post_new_task_screen.dart';

class AllTaskTab extends StatelessWidget {
  const AllTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomMyTaskCard(
            title: "Help needed move furniture",
            amount: "SAR 500",
            status: "Not accepted",
            postedTime: "2 hours ago",
            image: "assets/images/sofa.png",
            btnText: 'In Progress',
            // type: 'Offline Task',
            onEdit: () {},
            onViewDetails: () {
              Get.to(() => TaskInProgressScreen());
            },
            showButton: true,
          ),
          SizedBox(height: 10),
          CustomMyTaskCard(
            title: "Help needed move furniture",
            amount: "SAR 500",
            status: "Not accepted",
            postedTime: "2 hours ago",
            image: "assets/images/sofa.png",
            // type: 'Offline Task',
            onEdit: () {
              Get.to(() => PostNewTaskScreen());
            },
            onViewDetails: () {
              Get.to(() => TaskDetailsScreen());
            },
            showButton: true,
          ),
          SizedBox(height: 26),
          SizedBox(height: 140),
        ],
      ),
    );
  }
}
