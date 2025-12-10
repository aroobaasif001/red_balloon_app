import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_disputed_controller.dart';

class DisputeReasonCard extends StatelessWidget {
  final TaskDisputedController controller;
  final dynamic dispute;

  const DisputeReasonCard({super.key, required this.controller, this.dispute});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          spreadRadius: 0,
          blurRadius: 2,
          color: blackColor.withOpacity(0.05),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Dispute Reason",
              fontSize: 16,
              fontWeight: FontVariant.semiBold,
              color: textcolord,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: white2Color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                "\"${dispute['requesterReason'] == '' ? dispute['requesterDetails'] : dispute['requesterReason']}\"",
                fontSize: 14,
                color: rbtxColor,
                fontWeight: FontVariant.regular,
              ),
            ),
            const SizedBox(height: 8),
            CustomText(
              "This description was provided by the requester",
              fontSize: 12,
              fontWeight: FontVariant.regular,
              color: grey2Color,
            ),
          ],
        ),
      ),
    );
  }
}
