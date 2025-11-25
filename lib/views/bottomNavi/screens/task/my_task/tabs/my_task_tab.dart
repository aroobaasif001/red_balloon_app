import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/post_new_task/post_new_task_screen.dart';

import '../../../../../../custom_widgets/customtext.dart';

class MyTaskTab extends StatelessWidget {
  const MyTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: CustomText('My Posted Tasks', fontSize: 24, fontWeight: FontVariant.bold),
            ),
          ),
          SizedBox(height: 15),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CustomMyTaskCard(
                  title: "Help needed move furniture",
                  amount: "SAR 500",
                  status: "Not accepted",
                  postedTime: "Posted 2 hours ago",
                  image: "assets/images/sofa.png",
                  showButton: true,
                  onViewDetails: () {},
                  onEdit: () {
                    Get.to(() => PostNewTaskScreen());
                  },
                ),
              );
            },
          ),
          SizedBox(height: 140),
        ],
      ),
    );
  }
}
