import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../admin_task_center_screen/admin_task_details_tabs_screen/admin_task_details_tabs_screen.dart';

class ValidationTaskItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String startedAgo;
  final String image;
  final String? validationId;

  const ValidationTaskItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.startedAgo,
    required this.image,
    this.validationId,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      border: Border(
        bottom: BorderSide(color: bordercol, width: 1),
        right: BorderSide(color: bordercol, width: 1),
        left: BorderSide(color: bordercol, width: 1),
      ),
      conColor: whiteColor,
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.25),
          blurRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔵 TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TEXT (Expanded to push image to the right)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      price,
                      fontSize: 17,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 3),
                    CustomText(
                      startedAgo,
                      fontSize: 14,
                      color: timeColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// IMAGE
              CustomContainer(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: image.startsWith('http')
                      ? Image.network(
                          image,
                          width: 105,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            "assets/images/Rectangle 34625307.png",
                            width: 105,
                            height: 105,
                            fit: BoxFit.cover,
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 105,
                              height: 105,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: redColor,
                                ),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          image.isNotEmpty ? image : "assets/images/Rectangle 34625307.png",
                          width: 105,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            "assets/images/Rectangle 34625307.png",
                            width: 105,
                            height: 105,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// 🔴 BOTTOM ROW
          Row(
            children: [
              /// BADGE
              CustomContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                borderRadius: BorderRadius.circular(30),
                conColor: conBgColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                child: const CustomText(
                  "Validation in progress",
                  fontSize: 12,
                  color: blackColor,
                ),
              ),

              const Spacer(),

              /// VIEW DETAILS BUTTON
              SizedBox(
                height: 40,
                width: 115,
                child: CustomButton(
                  label: "View Details",
                  textColor: whiteColor,
                  fontSize: 14,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {
                    Get.to(
                      () => AdminTaskDetailsTabsScreen(
                        validationId: validationId,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
