import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_completed_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_disputed_screen.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/widgets/history_task_card.dart';

import '../../../../../../../utils/colors.dart';
import '../../../validations_tab/validation_screen/validation_screen.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
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
      child: Column(
        children: [
          FadeIn(
            duration: const Duration(milliseconds: 700),

            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 11),
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // Define button text and navigation based on index
                String buttonText;
                VoidCallback onViewDetails;
                Color statusBgColor;
                Color statusTextColor;

                if (index == 0) {
                  buttonText = 'Disputed';
                  statusBgColor = redColor.withOpacity(0.25);
                  statusTextColor = redColor;
                  onViewDetails = () {
                    // For 'Disputed', we fetch user data before navigating
                    // In a real app, you might fetch this from an API
                    // Here we use placeholder fetching logic as per previous implementation
                    // or just direct navigation since data fetching was moved to logic
                    // Wait, previous implementation had data fetching inside onViewDetails.
                    // I will preserve the logic structure but simplify for now or assume fetch happens elsewhere
                    // Actually, I should keep the logic if it was there.
                    // However, the provided file content in step 359 shows direct Get.to().
                    // Step 346 summary said HistoryTab logic updated to fetch data.
                    // But step 359 view_file shows simple Get.to().
                    // This means my view_file result is the current truth. The summary might be from a previous state or other file.
                    // Wait, the summary said "Refactored HistoryTab UI to use placeholder data...".
                    // So the simple Get.to is correct.
                    Get.to(() => TaskDisputedScreen());
                  };
                } else if (index == 1) {
                  buttonText = 'Validation';
                  statusBgColor = redColor.withOpacity(0.25);
                  statusTextColor = redColor;
                  onViewDetails = () {
                    Get.to(() => ValidationScreen(isTask: true));
                  };
                } else {
                  buttonText = 'Completed';
                  statusBgColor = greenColor.withOpacity(0.25);
                  statusTextColor = greenColor;
                  onViewDetails = () {
                    Get.to(() => TaskCompletedScreen());
                  };
                }

                return FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  delay: Duration(milliseconds: index * 700),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: HistoryTaskCard(
                      title: "Help needed move furniture",
                      amount: "SAR 500",

                      statusText: buttonText,
                      statusBgColor: statusBgColor,
                      statusTextColor: statusTextColor,

                      // postedTime: "Posted 2 hours ago",
                      // // image: "assets/images/sofa.png",
                      // showButton: true,
                      // btnText: buttonText,
                      // showType: false,
                      onViewDetails: onViewDetails,
                      location: 'Fazal Town Phase 1',
                      dateTime: DateTime.now().toString(),
                      // onEdit: () {},
                    ),
                  ),
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
