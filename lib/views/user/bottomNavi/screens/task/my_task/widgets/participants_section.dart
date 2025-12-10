import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_disputed_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/participant_card.dart';

class ParticipantsSection extends StatelessWidget {
  final TaskDisputedController controller;
  final dynamic requester;
  final dynamic helper;

  const ParticipantsSection({
    super.key,
    required this.controller,
    this.helper,
    this.requester,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(6),
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
            CustomText("Helper", fontSize: 12, color: grey2Color),
            const SizedBox(height: 8),
            ParticipantCard(
              photoUrl: helper['photoUrl'],
              name: helper['name'],
              id: "ID: ${helper['userId']}",
              tasksCompleted:
                  "${controller.helperTasksCompleted.value} tasks completed",
              rating: controller.helperRating.value,
            ),
            const SizedBox(height: 16),
            CustomText("Requester", fontSize: 12, color: grey2Color),
            const SizedBox(height: 8),
            ParticipantCard(
              photoUrl: requester['photoUrl'],
              name: requester['name'],
              id: "ID: ${requester['userId']}",
              tasksCompleted:
                  "Member since ${controller.requesterMemberSince.value}",
              rating: controller.requesterRating.value,
            ),
          ],
        ),
      ),
    );
  }
}
