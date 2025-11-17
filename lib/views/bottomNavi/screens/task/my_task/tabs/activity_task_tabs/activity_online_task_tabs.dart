import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_my_task_card.dart';

class ActivityOnlineTaskTabs extends StatelessWidget {
  const ActivityOnlineTaskTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                  status: "Online  task",
                  postedTime: "Posted 2 hours ago",
                  image: "assets/images/sofa.png",
                  onEdit: () {
                    print("Edit tapped");
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
