import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/clean_my_solar_panels.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';

import '../../../../../../../custom_widgets/custom_my_task_card.dart';
import '../../post_new_task/post_new_task_screen.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

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
                  btnText: 'Completed',
                  showType: false,
                  onViewDetails: () {
                    index==0?Get.to(()=>Cleanmysolarpanels()):Get.to(()=>TaskDetailsScreen());
                  },
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
