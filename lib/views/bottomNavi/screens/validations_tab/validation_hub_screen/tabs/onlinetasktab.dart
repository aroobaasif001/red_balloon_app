// lib/screens/validation/online_task_empty_state.dart

import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/widgets/offline_and_online_card.dart';

class OnlineTaskTab extends StatelessWidget {
  const OnlineTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('Requests Near You', fontSize: 18, fontWeight: FontVariant.bold),
              InkWell(
                onTap: () {},
                child: CustomText('View All', fontSize: 14, fontWeight: FontVariant.medium),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
          itemCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OfflineAndOnlineCard(
                title: "Help move furniture",
                subtitle: "Need help loading boxes into truck.",
                timeAgo: "15 mins ago",
                taskType: 'Online Task',
                price: "SAR 500",
                image: "assets/icons/chair.png",
                onViewDetails: () {
                  print("Details tapped");
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
