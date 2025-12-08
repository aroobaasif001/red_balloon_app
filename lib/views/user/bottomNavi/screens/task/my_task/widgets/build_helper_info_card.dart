import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/rating_row.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../../../../../../../utils/dialog_helpers.dart';
import '../../../profile/tabs/chat_screen.dart';
import '../../../profile/tabs/controller/chat_controller.dart';
import '../controller/in_progress_task_controller.dart';

/// HELPER INFO CARD: initials avatar, name, rating, role, actions
Widget buildHelperInfoCard(
  InProgressTaskController controller,
  String? photoUrl,
  String userName,
  String userId, {
  String? taskId,
  String? taskTitle,
  String? phoneNumber,
}) {
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
                      borderRadius: BorderRadius.circular(50),
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
                  // Navigate to chat with helper
                  if (taskId != null && userId.isNotEmpty) {
                    // Delete old controller if exists
                    if (Get.isRegistered<ChatController>()) {
                      Get.delete<ChatController>();
                    }

                    Get.put(
                      ChatController(
                        taskId: taskId,
                        taskTitle: taskTitle ?? 'Task',
                        taskOwnerId: userId,
                        taskOwnerName: userName,
                        taskOwnerPhoto: photoUrl,
                      ),
                    );
                    Get.to(() => const ChatScreen());
                  }
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
              child: InkWell(
                onTap: () async {
                  if (phoneNumber != null && phoneNumber.isNotEmpty) {
                    // Launch phone dialer
                    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      // Show error snackbar
                      Get.showSnackbar(
                        GetSnackBar(
                          message: 'Could not launch phone dialer',
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(10),
                          borderRadius: 8,
                        ),
                      );
                    }
                  } else {
                    // Show snackbar if phone number doesn't exist
                    Get.showSnackbar(
                      GetSnackBar(
                        message: "Helper's phone number doesn't exist",
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 2),
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.all(10),
                        borderRadius: 8,
                      ),
                    );
                  }
                },
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
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            DialogHelpers.showHelperProfileDialog(
              Get.context!,
              userName,
              photoUrl!,
              userId,
            );
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
