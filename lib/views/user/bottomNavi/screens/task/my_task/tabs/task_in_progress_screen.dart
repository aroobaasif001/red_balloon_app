import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_review_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../custom_widgets/custom_button.dart';
import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customappbar.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/dialog_helpers.dart';
import '../../../profile/tabs/chat_screen.dart';
import '../../../profile/tabs/controller/chat_controller.dart';
import '../controller/task_in_progress_controller.dart'; // 🔥 Import controller

class TaskInProgressScreen extends StatelessWidget {
  final String? taskId; // 🔥 Optional task ID

  const TaskInProgressScreen({super.key, this.taskId});

  @override
  Widget build(BuildContext context) {
    // 🔥 Initialize GetX controller with taskId
    final controller = Get.put(TaskInProgressController(taskId: taskId));

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Obx(() {
          // 🔥 Show loading indicator
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: redColor));
          }

          // 🔥 Show message if no task found
          if (controller.task.value == null) {
            return Center(
              child: CustomText(
                'No in-progress tasks found',
                fontSize: 16,
                color: timeColor,
              ),
            );
          }

          final task = controller.task.value!;
          final offer = controller.acceptedOffer.value;
          final helper = controller.helperUser.value;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ------------------ APP BAR ------------------
                CustomAppBar1(title: 'Task InProgress', showRightImage: false),

                SizedBox(height: 15),

                /// ------------------ TOP IMAGES SECTION ------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          borderRadius: BorderRadius.circular(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child:
                                task.imageUrl != null &&
                                    task.imageUrl!.isNotEmpty
                                ? Image.network(
                                    task.imageUrl!,
                                    height: 155,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 155,
                                        color: bordercolor1,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(redColor),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      print('❌ Error loading task image: $error');
                                      return Image.asset(
                                        "assets/images/sofa.png",
                                        height: 155,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    "assets/images/sofa.png",
                                    height: 155,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomContainer(
                          borderRadius: BorderRadius.circular(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              "assets/images/map.png",
                              height: 155,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// ------------------ STATUS TEXT ------------------
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Helper is on the way ",
                      style: const TextStyle(fontSize: 14, color: timeColor),
                      children: [
                        TextSpan(
                          text:
                              "(3.2 km away)", // TODO: Calculate real distance
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// ------------------ PROGRESS BAR ------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomContainer(
                    height: 4,
                    conColor: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomContainer(
                        width: 120,
                        height: 4,
                        conColor: redColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ------------------ HELPER CARD ------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: BorderRadius.circular(16),
                    conColor: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 3,
                        offset: Offset(0, 4),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: rdLight100Color,
                              child: helper!.photoURL!.isEmpty
                                  ? CustomText(
                                      controller.getInitials(
                                        helper?.displayName ??
                                            offer?.offeringUserName,
                                      ), // 🔥 Real initials
                                      fontWeight: FontVariant.bold,
                                      color: redColor,
                                      fontSize: 18,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        helper!.photoURL.toString(),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  helper?.displayName ??
                                      offer?.offeringUserName ??
                                      'Unknown', // 🔥 Real name
                                  fontSize: 16,
                                  fontWeight: FontVariant.semiBold,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: orangecolor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      "${controller.helperStats['rating']?.toStringAsFixed(1) ?? '0.0'} (${controller.helperStats['tasksCompleted'] ?? 0} tasks completed)", // 🔥 Real stats
                                      fontSize: 13,
                                      color: lastTextColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            /// CHAT BUTTON — CLICKABLE
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to chat with helper
                                  final helperUid =
                                      offer?.offeringUserUid ??
                                      task.acceptedOfferUid;
                                  final helperName =
                                      helper?.displayName ??
                                      offer?.offeringUserName ??
                                      'Helper';
                                  final helperPhoto =
                                      helper?.photoURL ??
                                      offer?.offeringUserPhoto;

                                  if (helperUid != null) {
                                    // Delete old controller if exists
                                    if (Get.isRegistered<ChatController>()) {
                                      Get.delete<ChatController>();
                                    }

                                    Get.put(
                                      ChatController(
                                        taskId: task.id!,
                                        taskTitle: task.title,
                                        taskOwnerId: helperUid,
                                        taskOwnerName: helperName,
                                        taskOwnerPhoto: helperPhoto,
                                      ),
                                    );
                                    Get.to(() => const ChatScreen());
                                  }
                                },
                                child: CustomContainer(
                                  height: 45,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: redColor,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                            'assets/icons/Mask group (2).png',
                                          ),
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 6),
                                        CustomText(
                                          "Chat",
                                          fontWeight: FontVariant.semiBold,
                                          color: redColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            /// CALL BUTTON — CLICKABLE
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // Get helper's phone number
                                  final helperPhone = helper?.phoneNumber;
                                  print(helperPhone);

                                  if (helperPhone != null &&
                                      helperPhone.isNotEmpty) {
                                    // Launch phone dialer
                                    final Uri phoneUri = Uri(
                                      scheme: 'tel',
                                      path: helperPhone,
                                    );

                                    if (await canLaunchUrl(phoneUri)) {
                                      await launchUrl(phoneUri);
                                    } else {
                                      // Show error snackbar
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          message:
                                              'Could not launch phone dialer',
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
                                        message:
                                            "Helper's phone number doesn't exist",
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
                                  height: 45,
                                  borderRadius: BorderRadius.circular(30),
                                  conColor: redColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.call,
                                          color: whiteColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 6),
                                        CustomText(
                                          "Call",
                                          fontWeight: FontVariant.semiBold,
                                          color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ------------------ TASK DETAILS CARD ------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomContainer(
                    padding: const EdgeInsets.all(18),
                    borderRadius: BorderRadius.circular(16),
                    conColor: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 3,
                        offset: Offset(0, 4),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ----------------- TOP ROW -----------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "Task:",
                                    fontWeight: FontVariant.bold,
                                    color: blackColor,
                                  ),
                                  SizedBox(width: 3),
                                  Expanded(
                                    child: CustomText(
                                      task.title, // 🔥 Real task title
                                      fontWeight: FontVariant.regular,
                                      fontSize: 14,
                                      color: timeColor,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            CustomContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              conColor: proBgColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              child: CustomText(
                                "In Progress",
                                fontWeight: FontVariant.bold,
                                fontSize: 12,
                                color: redColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        /// ----------------- AMOUNT / STARTED -----------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  "Amount:",
                                  fontWeight: FontVariant.bold,
                                  fontSize: 14,
                                ),
                                SizedBox(width: 4),
                                CustomText(
                                  controller.formatBudget(
                                    task.budget,
                                  ), // 🔥 Real budget
                                  fontSize: 14,
                                  color: timeColor,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomText(
                                  "Started:",
                                  fontWeight: FontVariant.bold,
                                  fontSize: 13,
                                ),
                                SizedBox(width: 4),
                                CustomText(
                                  controller.getTimeAgo(
                                    task.createdAt,
                                  ), // 🔥 Real time
                                  fontSize: 13,
                                  color: timeColor,
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        /// ----------------- LOCATION / POSTED -----------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: timeColor,
                                ),
                                SizedBox(width: 4),
                                CustomText(
                                  task.location ??
                                      'Online Task', // 🔥 Real location
                                  fontSize: 13,
                                  color: timeColor,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                CustomText(
                                  "Posted:",
                                  fontWeight: FontVariant.bold,
                                  fontSize: 14,
                                ),
                                SizedBox(width: 4),
                                CustomText(
                                  controller.getTimeAgo(
                                    task.createdAt,
                                  ), // 🔥 Real time
                                  fontSize: 14,
                                  color: timeColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ------------------ INFO BOX ------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomContainer(
                    padding: const EdgeInsets.all(18),
                    borderRadius: BorderRadius.circular(14),
                    conColor: rbcolor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                    child: CustomText(
                      "Once the helper marks this task as completed, you'll be asked to review and confirm within 2 minutes.",
                      fontSize: 14,
                      color: blackColor,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ------------------ REVIEW PROOF BUTTON ------------------
                /// ------------------ REVIEW PROOF BUTTON ------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomButton(
                    label: (controller.requesterHelpRequested.value || controller.helperHelpRequested.value) 
                        ? "Dispute in Progress" 
                        : "Review Proof",
                    onPressed: (controller.hasProof.value && 
                                !controller.requesterHelpRequested.value && 
                                !controller.helperHelpRequested.value)
                        ? () {
                            Get.to(
                              () => TaskReviewScreen(
                                taskId: controller.task.value?.id,
                                proofId: controller.proofId.value,
                              ),
                            );
                          }
                        : null,
                    bgColor: (controller.hasProof.value && 
                              !controller.requesterHelpRequested.value && 
                              !controller.helperHelpRequested.value)
                        ? redColor
                        : Colors.grey,
                    textColor: whiteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                const SizedBox(height: 20),

                /// ------------------ REQUEST HELP BUTTON ------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomButton(
                    label: controller.requesterHelpRequested.value 
                        ? "Help Requested" 
                        : "Request Help",
                    onPressed: controller.requesterHelpRequested.value 
                        ? null 
                        : () {
                            DialogHelpers().showSupportHelpSheet(
                              context,
                              onSubmit: (reason, details) {
                                controller.submitHelpRequest(reason, details);
                              },
                            );
                          },
                    bgColor: controller.requesterHelpRequested.value ? Colors.grey : redColor,
                    textColor: whiteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                const SizedBox(height: 20),

                /// ------------------ ETA FOOTER ------------------
                Center(
                  child: Column(
                    children: [
                      Container(height: 1, color: greyLiteColor),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: "Helper en route — ",
                          style: const TextStyle(
                            color: timeColor,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: "ETA: 10 mins", // TODO: Calculate real ETA
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
