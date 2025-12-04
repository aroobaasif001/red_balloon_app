import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_completed_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_disputed_screen.dart';

import '../../../../../../../custom_widgets/custom_my_task_card.dart';
import '../../../validations_tab/validation_screen/validation_screen.dart';

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
              // Define button text and navigation based on index
              String buttonText;
              VoidCallback onViewDetails;

              if (index == 0) {
                buttonText = 'Disputed';
                onViewDetails = () {
                  Get.to(() => TaskDisputedScreen());
                };
              } else if (index == 1) {
                buttonText = 'Validation';
                onViewDetails = () {
                  Get.to(() => ValidationScreen(isTask: true));
                };
              } else {
                buttonText = 'Completed';
                onViewDetails = () {
                  Get.to(() => TaskCompletedScreen());
                };
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CustomMyTaskCard(
                  title: "Help needed move furniture",
                  amount: "SAR 500",
                  status: "Offline task",
                  postedTime: "Posted 2 hours ago",
                  image: "assets/images/sofa.png",
                  showButton: true,
                  btnText: buttonText,
                  showType: false,
                  onViewDetails: onViewDetails,
                  onEdit: () {},
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
