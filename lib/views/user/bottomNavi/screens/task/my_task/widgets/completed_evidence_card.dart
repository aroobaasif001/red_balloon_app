import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_completed_controller.dart';

class CompletedEvidenceCard extends StatelessWidget {
  final TaskCompletedController controller;

  const CompletedEvidenceCard({super.key, required this.controller});

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
              "Before & After Evidence",
              fontSize: 16,
              fontWeight: FontVariant.bold,
              color: textcolord,
            ),
            const SizedBox(height: 12),
            CustomContainer(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                              fontSize: 12,
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
                        child: CustomContainer(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          conColor: !controller.showBefore.value
                              ? redColor
                              : white2Color,
                          borderRadius: BorderRadius.circular(6),
                          child: Center(
                            child: CustomText(
                              "AFTER",
                              fontSize: 12,
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
            Obx(() {
               final showBefore = controller.showBefore.value;
               final url = showBefore ? controller.beforePhotoUrl : controller.afterPhotoUrl;
               
               if (url.isNotEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      url,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/homedetail.png", 
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        );
                      }
                    ),
                  );
               } else {
                 return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/images/homedetail.png",
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                );
               }
            }),
          ],
        ),
      ),
    );
  }
}
