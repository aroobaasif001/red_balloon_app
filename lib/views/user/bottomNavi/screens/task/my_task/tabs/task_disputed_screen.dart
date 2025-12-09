import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_disputed_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/dispute_banner.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/dispute_reason_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/evidence_toggle_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/participants_section.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/task_summary_card.dart';

class TaskDisputedScreen extends StatelessWidget {
  final Map<String, dynamic>? requesterData;
  final Map<String, dynamic>? helperData;
  final Map<String, dynamic>? disputeData;
  final Map<String, dynamic>? taskData;

  TaskDisputedScreen({
    super.key,
    this.requesterData,
    this.helperData,
    this.disputeData,
    this.taskData,
  });

  final controller = Get.put(TaskDisputedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomAppBar(titleText: "Task Details"),
            ),

            const SizedBox(height: 20),

            // Red Dispute Banner
            DisputeBanner(controller: controller),

            const SizedBox(height: 24),

            // Task Summary Section
            TaskSummaryCard(controller: controller),

            const SizedBox(height: 24),

            // Dispute Reason Section
            DisputeReasonCard(controller: controller),

            const SizedBox(height: 24),

            // Before & After Evidence
            EvidenceToggleCard(controller: controller),

            const SizedBox(height: 24),

            // Participants Section
            ParticipantsSection(controller: controller),

            const SizedBox(height: 24),

            // Bottom Notification
            CustomContainer(
              height: 90,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(12),
              conColor: white2Color,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  Icon(Icons.info, color: grey2Color, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomText(
                      "You will be notified once the dispute is resolved.\nResolution time: 24-48 hours.",
                      textAlign: TextAlign.center,
                      fontSize: 12,
                      color: rbtxColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
