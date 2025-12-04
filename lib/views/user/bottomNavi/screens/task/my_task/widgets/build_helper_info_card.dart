import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/rating_row.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../../../../../../../utils/dialog_helpers.dart';
import '../../../profile/tabs/chat_screen.dart';
import '../controller/in_progress_task_controller.dart';

/// HELPER INFO CARD: initials avatar, name, rating, role, actions
Widget buildHelperInfoCard(
  InProgressTaskController controller,
  String? photoUrl,
  String userName,
) {
  return CustomContainer(
    conColor: white2Color,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomContainer(
              height: 44,
              width: 44,
              conColor: redColor,
              borderRadius: BorderRadius.circular(22),
              alignment: Alignment.center,
              child: photoUrl == null
                  ? CustomText(
                      controller.helperInitials.value,
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      color: whiteColor,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.network(photoUrl),
                    ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Name (currently static in RatingRow, could be extended)
                // We'll use controller for the main name text
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    userName,
                    fontSize: 15,
                    fontWeight: FontVariant.semiBold,
                    color: textcolord,
                  ),
                  const SizedBox(height: 4),
                  const RatingRow(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => ChatScreen());
                },
                child: CustomContainer(
                  height: 44,
                  conColor: whiteColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: redColor, width: 1.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: redColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      CustomText(
                        'Chat',
                        fontSize: 14,
                        fontWeight: FontVariant.semiBold,
                        color: redColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomContainer(
                height: 44,
                conColor: redColor,
                borderRadius: BorderRadius.circular(24),
                child: const Center(
                  child: CustomText(
                    'Call',
                    fontSize: 14,
                    fontWeight: FontVariant.semiBold,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            DialogHelpers.showHelperProfileDialog(Get.context!);
          },
          child: const Center(
            child: CustomText(
              'View Profile',
              fontSize: 13,
              fontWeight: FontVariant.semiBold,
              color: redColor,
            ),
          ),
        ),
      ],
    ),
  );
}
