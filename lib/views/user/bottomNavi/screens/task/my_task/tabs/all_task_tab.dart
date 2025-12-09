import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/home/widgets/offline_and_online_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_details_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_in_progress_screen.dart';

class AllTaskTab extends StatefulWidget {
  const AllTaskTab({super.key});

  @override
  State<AllTaskTab> createState() => _AllTaskTabState();
}

class _AllTaskTabState extends State<AllTaskTab> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                Get.to(() => TaskInProgressScreen());
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
                Get.to(() => TaskDetailsScreen());
              },
            ),
          ),
          SizedBox(height: 26),
          SizedBox(height: 140),
        ],
      ),
    );
  }
}
