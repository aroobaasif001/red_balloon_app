import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_completed_controller.dart';

class CompletedBanner extends StatelessWidget {
  final TaskCompletedController controller;

  const CompletedBanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      conColor: redColor,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          CustomContainer(
            padding: const EdgeInsets.all(12),
            conColor: whiteColor,
            shape: BoxShape.circle,
            child: Icon(Icons.check, color: redColor, size: 32),
          ),
          const SizedBox(height: 12),
          CustomText(
            "Task Completed Successfully",
            fontSize: 18,
            fontWeight: FontVariant.semiBold,
            color: whiteColor,
          ),
          const SizedBox(height: 4),
          Obx(
            () => CustomText(
              "Completed on ${controller.completedDate.value}",
              fontSize: 14,
              fontWeight: FontVariant.regular,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
