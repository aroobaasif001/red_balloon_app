import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/post_new_task/post_new_task_screen.dart';

class DraftTab extends StatelessWidget {
  const DraftTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CustomMyTaskCard(
                  title: "Help needed move furniture",
                  amount: "SAR 500",
                  status: "Not accepted",
                  postedTime: "Edited 3 hours ago",
                  image: "assets/images/sofa.png",
                  showType: false,
                  onEdit: () {
                    Get.to(() => PostNewTaskScreen());
                  },
                  showButton: true,
                  btnText: 'Continue Editing',
                  onViewDetails: () {},
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
