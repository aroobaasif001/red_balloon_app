import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_completed_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/completed_banner.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/completed_evidence_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/completed_participants_section.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/completed_task_summary_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/feedback_ratings_card.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/payment_summary_card.dart';

class TaskCompletedScreen extends StatelessWidget {
  final Map<String, dynamic> taskData;
  final String taskId;
  final bool isRequester;
  final Map<String, dynamic> otherUserData;
  final Map<String, dynamic> validationInfo;

  TaskCompletedScreen({
    super.key,
    required this.taskData,
    required this.taskId,
    required this.isRequester,
    required this.otherUserData,
    required this.validationInfo,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 Use taskId as tag to prevent reuse of controllers between different tasks
    final controller = Get.put(
      TaskCompletedController(
        taskData: taskData,
        taskId: taskId,
        isRequester: isRequester,
        otherUserData: otherUserData,
        validationInfo: validationInfo,
      ),
      tag: taskId,
      permanent: false,
    );
    
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

            // Green Success Banner
            CompletedBanner(controller: controller),

            const SizedBox(height: 24),

            // Task Summary Section
            CompletedTaskSummaryCard(controller: controller),

            const SizedBox(height: 24),

            // Before & After Evidence
            CompletedEvidenceCard(controller: controller),

            const SizedBox(height: 24),

            // Participants Section
            CompletedParticipantsSection(controller: controller),

            const SizedBox(height: 24),

            // Payment Summary Section
            PaymentSummaryCard(controller: controller),

            const SizedBox(height: 24),

            // Feedback & Ratings Section
            FeedbackRatingsCard(controller: controller),

            const SizedBox(height: 24),

            // Bottom Info
            CustomContainer(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(12),
              child: Center(
                child: CustomText(
                  controller.bottomNote,
                  fontSize: 12,
                  color: rbtxColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
