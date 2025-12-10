import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_completed_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/participant_card.dart';

class CompletedParticipantsSection extends StatelessWidget {
  final TaskCompletedController controller;

  const CompletedParticipantsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          spreadRadius: 0,
          blurRadius: 4,
          color: blackColor.withOpacity(0.25),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Participants",
              fontSize: 16,
              fontWeight: FontVariant.bold,
              color: textcolord,
            ),
            const SizedBox(height: 16),
            CustomText(controller.isRequester ? "Helper" : "Requester", fontSize: 12, color: grey2Color),
            const SizedBox(height: 8),
            ParticipantCard(
              photoUrl: controller.otherUserPhoto,
              name: controller.otherUserName,
              id: "${controller.isRequester ? 'Helper' : 'Requester'} ID: ${controller.otherUserId}",
              tasksCompleted:
                  "${controller.otherUserTasksCompleted} tasks completed",
              rating: controller.otherUserRating,
            ),
          ],
        ),
      ),
    );
  }
}
