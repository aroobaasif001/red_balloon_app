import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_disputed_controller.dart';

class EvidenceToggleCard extends StatelessWidget {
  final TaskDisputedController controller;

  const EvidenceToggleCard({super.key, required this.controller});

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
              "Before & After Evidence",
              fontSize: 16,
              fontWeight: FontVariant.semiBold,
              color: textcolord,
            ),
            const SizedBox(height: 12),
            CustomContainer(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              height: 60,
              conColor: white2Color,
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.showBefore.value = true,
                        child: CustomContainer(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          conColor: controller.showBefore.value
                              ? redColor
                              : white2Color,
                          borderRadius: BorderRadius.circular(6),
                          child: Center(
                            child: CustomText(
                              "BEFORE",
                              fontSize: 14,
                              fontWeight: FontVariant.semiBold,
                              color: controller.showBefore.value
                                  ? whiteColor
                                  : textcolord,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => controller.showBefore.value = false,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !controller.showBefore.value
                                ? redColor
                                : white2Color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CustomText(
                              "AFTER",
                              fontSize: 14,
                              fontWeight: FontVariant.semiBold,
                              color: !controller.showBefore.value
                                  ? whiteColor
                                  : textcolord,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/homedetail.png",
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
