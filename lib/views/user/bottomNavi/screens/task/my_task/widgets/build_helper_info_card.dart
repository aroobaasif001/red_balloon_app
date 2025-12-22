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
import '../tabs/user_profile_screen.dart';
import '../controller/in_progress_task_controller.dart';

/// HELPER INFO CARD: initials avatar, name, rating, role, actions
Widget buildHelperInfoCard(
  InProgressTaskController controller,
  String? photoUrl,
  String userName,
  String userId, {
  String? helperUid, // 🔥 Added for DB queries
  String? taskId,
  String? taskTitle,
  String? phoneNumber,
  String? taskImage,
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
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.fitWidth,
                        height: 50,
                        width: 50,
                      ),
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
                  print(
                    '🔍 Chat Debug (buildHelperInfoCard): taskId=$taskId, userId=${userId}, userName=$userName',
                  );

                  if (taskId != null &&
                      taskId!.isNotEmpty &&
                      userId.isNotEmpty) {
                    print('✅ Opening chat with userId: ${userId}');
                    Get.to(
                      () => const ChatScreen(),
                      binding: BindingsBuilder(() {
                        Get.put(
                          ChatController(
                            taskId: taskId,
                            taskTitle: taskTitle ?? 'Task',
                            taskOwnerId: userId,
                            taskOwnerName: userName,
                            taskOwnerPhoto: photoUrl,
                            taskImage: taskImage,
                          ),
                        );
                      }),
                    );
                  } else {
                    print('❌ Chat failed: taskId=$taskId, userId=$userId');
                    Get.snackbar(
                      'Error',
                      'Cannot start chat: Missing task or user information',
                    );
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
                      Get.snackbar(
                        'Error',
                        'Could not launch phone dialer',
                      );
                    }
                  } else {
                    // Show snackbar if phone number doesn't exist
                    Get.snackbar(
                      'Error',
                      "Helper's phone number doesn't exist",
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
            Get.to(
              () => UserProfileScreen(
                userPhoto: photoUrl,
                userId: userId,
                userUid: helperUid,
                userName: userName,
                userInitials: controller.helperInitials.value,
                rating: controller.rating.value,
                tasksCompleted: 0,
                tasksRequested: 0,
              ),
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
