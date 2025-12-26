import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/leave_feedback_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/tasks_controller.dart'; // To access formatters if needed

class LeaveFeedbackScreen extends StatelessWidget {
  final Map<String, dynamic> taskInfo;
  final Map<String, dynamic> otherUserData;
  final bool isRequester;

  const LeaveFeedbackScreen({
    super.key,
    required this.taskInfo,
    required this.otherUserData,
    required this.isRequester,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(
      LeaveFeedbackController(
        taskId: taskInfo['taskId'],
        isRequester: isRequester,
        taskInfo: taskInfo,
        otherUserData: otherUserData,
      ),
    );

    // Access generic tasks controller for helpers like getTimeAgo if needed,
    // but we can just use the provided function logic.
    // Assuming simple time ago logic or passed string.
    // Let's use get.find if available or a local helper.
    // Actually, taskInfo['completedAt'] is likely a Timestamp.

    String getFormattedTime() {
      if (taskInfo['completedAt'] != null) {
        // Use the TasksController logic or standard
        // Since we don't have direct access without importing, let's try finding existing TasksController
        try {
          final tasksCtrl = Get.find<TasksController>();
          return "Completed ${tasksCtrl.getTimeAgo(taskInfo['completedAt'])}";
        } catch (e) {
          return "Completed recently";
        }
      }
      return "Completed recently";
    }

    final String otherUserName = otherUserData['name'] ?? 'Unknown User';
    final String otherUserId = otherUserData['userId'] ?? 'RB-0000';
    final String? otherUserPhoto = otherUserData['photoUrl'];
    final String roleLabel = isRequester ? "Helper" : "Requester";

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,

        /// -------------- OVERFLOW FIX --------------
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 25),

          child: Column(
            children: [
              const SizedBox(height: 80),

              /// ------------------ TOP LOGO ------------------
              Image.asset(
                "assets/appLogo/White Minimalist Jumma Mubarak Instagram Post (2) 1.png",
                height: 95,
              ),

              const SizedBox(height: 15),

              /// ------------------ TITLE ------------------
              const CustomText(
                "Leave Feedback",
                fontSize: 20,
                fontWeight: FontVariant.bold,
              ),

              const SizedBox(height: 6),

              CustomText(
                "Your feedback helps build a trusted community.",
                fontSize: 13,
                color: walletTextGreyColor,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              /// ------------------ TASK CARD ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  conColor: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  child: Row(
                    children: [
                      /// USER IMAGE / INITIAL
                      CustomContainer(
                        height: 38,
                        width: 38,
                        borderRadius: BorderRadius.circular(100),
                        conColor: redColor.withOpacity(0.15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child:
                              otherUserPhoto != null &&
                                  otherUserPhoto.isNotEmpty
                              ? Image.network(
                                  otherUserPhoto,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: CustomText(
                                        otherUserName.isNotEmpty
                                            ? otherUserName[0].toUpperCase()
                                            : "?",
                                        fontSize: 14,
                                        fontWeight: FontVariant.bold,
                                        color: redColor,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: CustomText(
                                    otherUserName.isNotEmpty
                                        ? otherUserName[0].toUpperCase()
                                        : "?",
                                    fontSize: 14,
                                    fontWeight: FontVariant.bold,
                                    color: redColor,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// TEXT BLOCK
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              taskInfo['title'] ?? "Task Title",
                              fontWeight: FontVariant.semiBold,
                              fontSize: 14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 3),

                            CustomText(
                              "$roleLabel: $otherUserName",
                              fontSize: 12,
                              color: timeColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 2),

                            CustomText(
                              "$roleLabel ID: $otherUserId",
                              fontSize: 12,
                              color: timeColor,
                            ),

                            const SizedBox(height: 2),

                            CustomText(
                              getFormattedTime(),
                              fontSize: 10,
                              color: walletTextGreyColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// ------------------ EXPERIENCE TITLE ------------------
              const CustomText(
                "How was your experience?",
                fontWeight: FontVariant.semiBold,
                fontSize: 16,
              ),

              const SizedBox(height: 25),

              /// ------------------ STAR RATING ------------------
              Obx(
                () => RatingBar.builder(
                  initialRating: controller.rating.value,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 45,
                  unratedColor: Colors.grey[300],
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: yellow,
                  ),
                  onRatingUpdate: (rating) {
                    controller.setRating(rating);
                  },
                ),
              ),

              const SizedBox(height: 8),

              const CustomText("Tap to rate", fontSize: 13, color: blackColor),

              const SizedBox(height: 25),

              /// ------------------ REVIEW TEXT FIELD ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      "Write a short review (optional)",
                      fontSize: 14,
                      color: blackColor,
                    ),

                    const SizedBox(height: 10),

                    CustomContainer(
                      height: 145,
                      conColor: greyLiteColor,
                      borderRadius: BorderRadius.circular(14),
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: controller.reviewController,
                        maxLines: 6,
                        maxLength: 250, // 🔥 Limit to 250 characters
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null, // Hide default counter
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type your message...",
                          hintStyle: TextStyle(color: walletProgressBgColor),
                          counterText: "", // Hide default counter
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // character count reactive update
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() => CustomText(
                        "${controller.currentReviewLength.value}/250 characters",
                        fontSize: 12,
                        color: walletTransactionDescColor,
                      )),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ------------------ BOTTOM BUTTONS ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    /// SKIP
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!controller.isLoading.value) {
                            controller.skipFeedback();
                          }
                        },
                        child: CustomContainer(
                          height: 50,
                          borderRadius: BorderRadius.circular(30),
                          conColor: whiteColor,
                          border: Border.all(color: fundCardBorderColor),
                          child: const Center(
                            child: CustomText(
                              "Skip",
                              fontSize: 15,
                              fontWeight: FontVariant.semiBold,
                              color: lastTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// SUBMIT
                    Expanded(
                      child: Obx(
                        () => CustomButton(
                          label: controller.isLoading.value
                              ? 'Sending...'
                              : 'Submit Feedback',
                          borderRadius: BorderRadius.circular(30),
                          fontSize: 15,
                          onPressed: () {
                            if (!controller.isLoading.value) {
                              controller.submitFeedback();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
