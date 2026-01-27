import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../../utils/dialog_helpers.dart';
import '../controller/task_review_controller.dart';
import '../controller/task_tabs_controller.dart';
import '../controller/tasks_controller.dart';
import '../my_task_screen.dart';

class TaskReviewScreen extends StatelessWidget {
  final String? taskId;
  final String? proofId;

  const TaskReviewScreen({super.key, this.taskId, this.proofId});

  @override
  Widget build(BuildContext context) {
    // 🔥 Use tag to persist controller per task
    final String controllerTag = 'task_review_${taskId ?? 'default'}';

    // Try to find existing controller, or create new one with permanent flag
    TaskReviewController controller;
    bool isNewController = false;

    if (Get.isRegistered<TaskReviewController>(tag: controllerTag)) {
      controller = Get.find<TaskReviewController>(tag: controllerTag);
      print('🔥 Reusing existing controller for $controllerTag');
    } else {
      controller = Get.put(
        TaskReviewController(),
        tag: controllerTag,
        permanent: true, // 🔥 Keep in memory even when screen disposed
      );
      isNewController = true;
      print('🔥 Created new controller for $controllerTag');
    }

    // 🔥 ALWAYS fetch data when screen opens (not just on first creation)
    if (taskId != null && proofId != null) {
      // Use WidgetsBinding to ensure this runs after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(
          '🔥 Fetching task and proof data for taskId: $taskId, proofId: $proofId',
        );
        controller.fetchTaskAndProofData(taskId: taskId!, proofId: proofId!);
      });
    }

    // 🔥 Set navigation callback
    controller.onSubmissionComplete = () {
      // Close all open dialogs/bottom sheets first
      while (Navigator.of(context).canPop() &&
          (Get.isDialogOpen == true || Get.isBottomSheetOpen == true)) {
        Navigator.of(context).pop();
      }

      // Refresh the tasks controller to update task list
      try {
        final tasksController = Get.find<TasksController>();
        tasksController.refreshTasks();
      } catch (e) {
        print('⚠️ Could not refresh tasks controller: $e');
      }

      // 🔥 Navigate to MyTaskScreen (All Task tab)
      Get.offAll(() => MyTaskScreen());
    };

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------------- APP BAR ----------------
                CustomAppBar1(title: 'Task Review', showRightImage: false),

                const SizedBox(height: 15),

                /// ---------------- TITLE ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => CustomText(
                      controller.taskTitle.value.isEmpty
                          ? "Loading..."
                          : controller.taskTitle.value,
                      fontWeight: FontVariant.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 13),

                /// ---------------- HELPER ROW ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// LEFT SIDE (Avatar + Name + Proof Badge)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// HELPER AVATAR (Photo or Initial)
                            Obx(() {
                              final hasPhoto =
                                  controller.helperPhotoUrl.value.isNotEmpty;

                              return CustomContainer(
                                height: 45,
                                width: 45,
                                borderRadius: BorderRadius.circular(100),
                                conColor: hasPhoto
                                    ? Colors.transparent
                                    : redColor.withOpacity(0.1),
                                child: hasPhoto
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: controller.helperPhotoUrl.value,
                                          height: 45,
                                          width: 45,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: redColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: const Center(
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(redColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) {
                                            // Show initial if image fails to load
                                            return Center(
                                              child: CustomText(
                                                controller.helperInitial.value.isEmpty
                                                    ? "?"
                                                    : controller.helperInitial.value,
                                                fontSize: 22,
                                                fontWeight: FontVariant.bold,
                                                color: redColor,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: CustomText(
                                          controller.helperInitial.value.isEmpty
                                              ? "?"
                                              : controller.helperInitial.value,
                                          fontSize: 22,
                                          fontWeight: FontVariant.bold,
                                          color: redColor,
                                        ),
                                      ),
                              );
                            }),

                            const SizedBox(width: 12),

                            /// NAME + PROOF BADGE
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => CustomText(
                                    controller.helperName.value.isEmpty
                                        ? "Loading..."
                                        : controller.helperName.value,
                                    fontSize: 16,
                                    fontWeight: FontVariant.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                CustomContainer(
                                  height: 26,
                                  borderRadius: BorderRadius.circular(20),
                                  conColor: walletCardBorderColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/icons/fas3.png",
                                        height: 10,
                                      ),
                                      const SizedBox(width: 6),
                                      CustomText(
                                        "Proof submitted",
                                        fontSize: 12,
                                        color: timeColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// TIMER — Now aligned perfectly
                      Obx(
                        () => CustomContainer(
                          height: 72,
                          width: 72,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(width: 3, color: redColor),
                          child: Center(
                            child: CustomText(
                              controller.formattedTime, // 🔥 Dynamic timer
                              fontSize: 18,
                              fontWeight: FontVariant.bold,
                              color: redColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                /// ---------------- LOCATION + SUBMITTED TIME ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: greyColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Obx(
                          () => CustomText(
                            controller.location.value.isEmpty
                                ? "Unknown"
                                : controller.location.value,
                            fontSize: 12,
                            fontWeight: FontVariant.regular,
                            color: timeColor,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.access_time, size: 18, color: greyColor),
                      const SizedBox(width: 4),
                      Obx(
                        () => CustomText(
                          controller.submittedTime.value.isEmpty
                              ? "Just now"
                              : "Submitted ${controller.submittedTime.value}",
                          fontSize: 12,
                          color: timeColor,
                          fontWeight: FontVariant.regular,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                /// ---------------- BEFORE & AFTER IMAGES ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      /// BEFORE
                      InkWell(
                        onTap: () {
                          if (controller.beforeImageUrl.value.isNotEmpty) {
                            _showImageFullscreen(
                              context,
                              controller.beforeImageUrl.value,
                            );
                          }
                        },
                        child: CustomContainer(
                          height: 150,
                          width:
                              (MediaQuery.of(context).size.width -
                                  15 * 2 -
                                  12) /
                              2,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: blackColor,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Obx(
                                  () => controller.beforeImageUrl.value.isEmpty
                                      ? Image.asset(
                                          "assets/images/homedetail.png",
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: controller.beforeImageUrl.value,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            height: 150,
                                            width: double.infinity,
                                            color: bordercolor1,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(redColor),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              "assets/images/homedetail.png",
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                ),
                              ),

                              /// BEFORE TAG
                              Positioned(
                                top: 8,
                                left: 8,
                                child: CustomContainer(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  conColor: blackColor.withOpacity(0.6),
                                  child: CustomText(
                                    "BEFORE",
                                    color: whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontVariant.semiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// MIDDLE SPACE
                      const SizedBox(width: 12),

                      /// AFTER
                      InkWell(
                        onTap: () {
                          if (controller.afterImageUrl.value.isNotEmpty) {
                            _showImageFullscreen(
                              context,
                              controller.afterImageUrl.value,
                            );
                          }
                        },
                        child: CustomContainer(
                          height: 150,
                          conColor: whiteColor,
                          width:
                              (MediaQuery.of(context).size.width -
                                  15 * 2 -
                                  12) /
                              2,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: blackColor,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Obx(
                                  () => controller.afterImageUrl.value.isEmpty
                                      ? Image.asset(
                                          "assets/images/homedetail.png",
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: controller.afterImageUrl.value,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            height: 150,
                                            width: double.infinity,
                                            color: bordercolor1,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(redColor),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              "assets/images/homedetail.png",
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                ),
                              ),

                              /// AFTER TAG
                              Positioned(
                                top: 8,
                                left: 8,
                                child: CustomContainer(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  conColor: blackColor.withOpacity(0.6),
                                  child: CustomText(
                                    "AFTER",
                                    color: whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontVariant.semiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                /// ---------------- DESCRIPTION BOX ---------------- ///
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 18,
                    ),
                    conColor: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: grey50Color),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Helper has marked this task as completed and uploaded proof. Please review within ",
                            style: const TextStyle(
                              fontSize: 14,
                              color: timeColor,
                            ),
                          ),
                          TextSpan(
                            text: "2 minutes",
                            style: const TextStyle(
                              fontSize: 14,
                              color: redColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ".",
                            style: const TextStyle(
                              fontSize: 13,
                              color: blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),

                /// ---------------- BOTTOM BUTTONS ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      /// Reject
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            /// 🔥 Show existing rejection dialog
                            DialogHelpers.showRejectStep1Dialog(
                              context,
                              controller: controller,
                              taskId: taskId,
                              proofId: proofId,
                            );
                          },
                          child: CustomContainer(
                            height: 52,
                            borderRadius: BorderRadius.circular(30),
                            conColor: redColor,
                            border: Border.all(color: redColor, width: 2),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.close,
                                    color: whiteColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  CustomText(
                                    "Reject Proof",
                                    fontWeight: FontVariant.semiBold,
                                    color: whiteColor,
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// Accept
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            /// 🔥 Accept proof (navigation handled by callback)
                            await controller.acceptProof(
                              taskId: taskId ?? '',
                              proofId: proofId ?? '',
                            );
                          },
                          child: CustomContainer(
                            height: 52,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: historyGreenColor,
                              width: 2,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: historyGreenColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  CustomText(
                                    "Accept Proof",
                                    fontWeight: FontVariant.semiBold,
                                    color: historyGreenColor,
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                /// ---------------- FOOTNOTE TEXT ----------------
                Center(
                  child: CustomText(
                    "If no action is taken, this task will move to community\nvalidation automatically.",
                    color: timeColor,
                    fontSize: 12,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),

            // 🔥 Loading overlay
            Obx(
              () => controller.isSubmitting.value
                  ? Container(
                      color: blackColor.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                whiteColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            // CustomText(
                            //   'Processing...',
                            //   color: whiteColor,
                            //   fontSize: 16,
                            //   fontWeight: FontVariant.semiBold,
                            // ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageFullscreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: blackColor,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/homedetail.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: blackLightColor,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close, color: whiteColor, size: 28),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
