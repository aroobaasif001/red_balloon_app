import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/widgets/offline_and_online_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/in_progress_view_details.dart';

import 'clean_my_solar_panels.dart';

class ActiveTab extends StatefulWidget {
  const ActiveTab({super.key});

  @override
  State<ActiveTab> createState() => _ActiveTabState();
}

class _ActiveTabState extends State<ActiveTab> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Lottie.asset(
              'assets/animation/loader.json',
              width: 250,
              height: 250,
            ),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: OfflineAndOnlineCard(
                    title: "Help needed move furniture",
                    subtitle: "Not accepted", // Mapping subtitle for now
                    price: "SAR 500",
                    distance: '2.5 km away',
                    taskType: 'Offline Task',
                    timeAgo: "2 hours ago",
                    image: "assets/images/sofa.png",
                    type: 'Offline Task',
                    onViewDetails: () {
                      Get.to(() => InProgressViewDetails());
                    },
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 700),
                  child: OfflineAndOnlineCard(
                    title: "Help needed move furniture",
                    subtitle: "Not accepted", // Mapping subtitle for now
                    price: "SAR 500",
                    distance: '2.5 km away',
                    taskType: 'Offline Task',
                    timeAgo: "2 hours ago",
                    image: "assets/images/sofa.png",
                    type: 'Offline Task',
                    onViewDetails: () {
                      Get.to(
                        () => Cleanmysolarpanels(taskType: 'Offline Task'),
                      );
                    },
                  ),
                ),
                SizedBox(height: 140),
              ],
            ),
          );
  }
}
