import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/post_new_task/post_new_task_screen.dart';

class ActivityOfflineTaskTabs extends StatelessWidget {
  const ActivityOfflineTaskTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 11),
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CustomMyTaskCard(
                  title: "Help needed move furniture",
                  amount: "SAR 500",
                  status: "Offline task",
                  postedTime: "Posted 2 hours ago",
                  image: "assets/images/sofa.png",
                  showButton: true,
                  btnText: 'In Progress',
                  // onViewDetails: () {},
                  showType: false,
                  onEdit: () {
                    Get.to(() => PostNewTaskScreen());
                  },
                ),
              );
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
