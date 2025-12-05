import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/in_progress_view_details.dart';

import '../../post_new_task/post_new_task_screen.dart';
import 'clean_my_solar_panels.dart';

class ActiveTab extends StatelessWidget {
  const ActiveTab({super.key});

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
              Get.to(() => InProgressViewDetails());
            },
            showButton: true,
          ),
          SizedBox(height: 10),
          CustomMyTaskCard(
            title: "Help needed move furniture",
            amount: "SAR 500",

            // type: 'Offline Task',
            status: "Not accepted",
            postedTime: "2 hours ago",
            image: "assets/images/sofa.png",
            onEdit: () {
              Get.to(() => PostNewTaskScreen());
            },
            showButton: true,
            onViewDetails: () {
              Get.to(() => Cleanmysolarpanels(taskType: 'Offline Task'));
            },
          ),
          SizedBox(height: 140),
        ],
      ),
    );
  }
}
