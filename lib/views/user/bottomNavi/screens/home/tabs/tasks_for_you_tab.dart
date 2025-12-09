import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../bottom_navi_screen.dart';
import '../../task/my_task/tabs/clean_my_solar_panels.dart';
import '../widgets/offline_and_online_card.dart';

class TasksForYouTab extends StatefulWidget {
  const TasksForYouTab({super.key});

  @override
  State<TasksForYouTab> createState() => _TasksForYouTabState();
}

class _TasksForYouTabState extends State<TasksForYouTab> {
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
              CustomText(
                'Tasks for you',
                fontSize: 24,
                fontWeight: FontVariant.bold,
              ),
              InkWell(
                onTap: () {
                  Get.offAll(() => BottomNaviScreen(initialIndex: 1));
                },
                child: CustomText(
                  'View All',
                  fontSize: 14,
                  fontWeight: FontVariant.medium,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(color: blackColor.withOpacity(0.35)),
        ),
        SizedBox(height: 17),
        CustomContainer(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: 4,
            itemBuilder: (context, index) {
              return FadeInUp(
                duration: const Duration(milliseconds: 700),
                delay: Duration(milliseconds: index * 700),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OfflineAndOnlineCard(
                    title: "Deliver groceries to my home",
                    subtitle: "Need help loading boxes into truck.",
                    distance: "3.2 km away",
                    taskType: 'Offline Task',
                    timeAgo: "15 mins ago",
                    price: "SAR 500",
                    image: "assets/icons/chair.png",
                    type: 'Offline Task',
                    onViewDetails: () {
                      print("Details tapped");
                      Get.to(() => Cleanmysolarpanels());
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
