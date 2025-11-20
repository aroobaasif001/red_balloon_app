import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/bottomNavi/bottom_navi_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/home/widgets/offline_and_online_card.dart';

import '../../task/my_task/tabs/clean_my_solar_panels.dart';

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
              CustomText('Online Requests', fontSize: 18, fontWeight: FontVariant.bold),
              InkWell(
                onTap: () {
                  Get.offAll(() => BottomNaviScreen(initialIndex: 1));
                },
                child: CustomText('View All', fontSize: 14, fontWeight: FontVariant.medium),
              ),
            ],
          ),
        ),
        SizedBox(height: 22),
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
                distance: "3.2 km away",
                taskType: 'Online Task',
                timeAgo: "15 mins ago",
                price: "SAR 500",
                image: "assets/icons/chair.png",

                onViewDetails: () {
                  Get.to(() => Cleanmysolarpanels());
                },
                type: '',
              ),
            );
          },
        ),
      ],
    );
  }
}
