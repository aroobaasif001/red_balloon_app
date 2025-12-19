import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../views/user/bottomNavi/screens/task/my_task/tabs/task_in_progress_screen.dart';
import '../views/user/bottomNavi/screens/task/my_task/widgets/send_offer_bottom_sheet.dart';
import 'colors.dart';

class DialogHelpers {
  // Add Funds Dialog Methods
  static void showAddFundsError(String message) {
    Get.snackbar('Error', message);
  }

  static void showAddFundsSuccess(String amount, String paymentMethod) {
    Get.snackbar(
      'Success',
      'Processing payment of SAR $amount via $paymentMethod',
    );
  }

  static void handleWithdrawalRequest() {
    // Handle withdrawal request logic here
    Get.snackbar('Success', 'Withdrawal request submitted');
  }

  void showNoVoteDialog({
    required BuildContext context,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "Due to no vote, the task has been moved to Validation Hub",
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                      color: blackColor,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              Positioned(
                top: -74,
                child: Image.asset(
                  "assets/icons/Group 1686555644.png",
                  width: 135,
                  height: 135,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showRejectStep1Dialog(
    BuildContext context, {
    dynamic controller,
    String? taskId,
    String? proofId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "Reject This Submission?",
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      "Please tell us why you're rejecting this proof. This helps us keep your task accurate",
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.medium,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 22),

                    /// NEXT BUTTON
                    InkWell(
                      onTap: () {
                        DialogHelpers().showRejectStep2Dialog(
                          context,
                          controller: controller,
                          taskId: taskId,
                          proofId: proofId,
                        );
                      },
                      child: CustomContainer(
                        height: 48,
                        borderRadius: BorderRadius.circular(12),
                        conColor: redColor,
                        child: Center(
                          child: CustomText(
                            "Next",
                            fontSize: 16,
                            color: whiteColor,
                            fontWeight: FontVariant.semiBold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// GO BACK BUTTON
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: CustomContainer(
                        height: 48,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: blackColor, width: 1.3),
                        conColor: whiteColor,
                        child: Center(
                          child: CustomText(
                            "Go Back",
                            fontSize: 15,
                            fontWeight: FontVariant.medium,
                            color: blackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: -75,
                child: Image.asset(
                  "assets/icons/Group 1686555649.png",
                  width: 135,
                  height: 135,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showRejectStep2Dialog(
    BuildContext context, {
    dynamic controller,
    String? taskId,
    String? proofId,
  }) {
    int selected = 0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final reasons = [
              "Work not completed",
              "Communication issue",
              "Task was ignored",
              "Others", // 🔥 Added 4th option
            ];

            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  CustomContainer(
                    padding: const EdgeInsets.only(
                      top: 80,
                      left: 20,
                      right: 20,
                      bottom: 25,
                    ),
                    conColor: whiteColor,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.15),
                        blurRadius: 10,
                      ),
                    ],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(reasons.length, (i) {
                          bool active = i == selected;

                          return GestureDetector(
                            onTap: () => setState(() => selected = i),
                            child: CustomContainer(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              borderRadius: BorderRadius.circular(12),
                              conColor: active ? redColor : whiteColor,
                              border: Border.all(
                                color: active ? redColor : totaTextColor,
                                width: 1.3,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    active
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: active ? whiteColor : blackColor,
                                  ),
                                  const SizedBox(width: 10),
                                  CustomText(
                                    reasons[i],
                                    color: active ? whiteColor : blackColor,
                                    fontWeight: FontVariant.medium,
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 5),

                        CustomButton(
                          width: 150,
                          fontSize: 14,
                          label: 'Submit Rejection',
                          onPressed: () async {
                            final selectedReason = reasons[selected];

                            // 🔥 If "Others" selected, show bottom sheet
                            if (selectedReason == "Others") {
                              Get.back(); // Close step2 dialog
                              DialogHelpers().showRejectionReasonSheet(
                                context,
                                controller: controller,
                                taskId: taskId ?? '',
                                proofId: proofId ?? '',
                              );
                            } else {
                              // 🔥 Submit directly with selected reason
                              if (controller != null) {
                                controller.selectedRejectionReason.value =
                                    selectedReason;

                                // Close dialogs
                                Navigator.of(
                                  context,
                                ).pop(); // Close step2 dialog
                                Navigator.of(
                                  context,
                                ).pop(); // Close step1 dialog

                                // Submit (navigation handled by callback)
                                await controller.submitRejection(
                                  taskId: taskId ?? '',
                                  proofId: proofId ?? '',
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: -74,
                    child: Image.asset(
                      "assets/icons/Group 1686555649.png",
                      width: 135,
                      height: 135,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showTaskCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 20,
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "Task Completed!",
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      "Task is marked as completed. Payment will be released within 48 hours",
                      fontSize: 12,
                      textAlign: TextAlign.center,
                      color: blackColor,
                    ),
                  ],
                ),
              ),

              Positioned(
                top: -75,
                child: Image.asset(
                  "assets/icons/check.png",
                  width: 135,
                  height: 135,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showsavechangeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // MAIN WHITE CARD
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 90,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TEXT
                    CustomText(
                      "Are You Sure you want to Save Profile",
                      fontSize: 16,
                      color: blackColor,
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.semiBold,
                    ),

                    const SizedBox(height: 25),

                    // BUTTONS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // NO BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: fundCardBorderColor,
                                width: 2,
                              ),
                              conColor: hColor.withOpacity(0.10),
                              child: const CustomText(
                                "No",
                                fontSize: 12,
                                color: redColor,
                                fontWeight: FontVariant.regular,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // YES BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Add Buy function here
                            },
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              color: redColor, // redColor
                              child: const CustomText(
                                "Yes",
                                fontSize: 14,
                                color: whiteColor,
                                fontWeight: FontVariant.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔴 TOP CIRCLE WITH WHITE BORDER + ICON
              Positioned(
                top: -70,
                child: CustomContainer(
                  width: 140,
                  height: 140,

                  conColor: redColor,
                  shape: BoxShape.circle,

                  child: Center(
                    child: Center(
                      child: Image.asset(
                        "assets/icons/savechange.png", // YOUR ICON
                        width: 55,
                        height: 55,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showBuyBadgeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // MAIN WHITE CARD
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 90,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TEXT
                    CustomText(
                      "Are You Sure you want to buy this badge",
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.semiBold,
                    ),

                    const SizedBox(height: 25),

                    // BUTTONS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // NO BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: fundCardBorderColor,
                                width: 2,
                              ),
                              conColor: bColor.withOpacity(0.10),
                              child: const CustomText(
                                "No",
                                fontSize: 12,
                                color: redColor,
                                fontWeight: FontVariant.regular,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // YES BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Add Buy function here
                            },
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              conColor: redColor, // redColor
                              child: const CustomText(
                                "Yes",
                                fontSize: 14,
                                color: whiteColor,
                                fontWeight: FontVariant.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔴 TOP CIRCLE WITH WHITE BORDER + ICON
              Positioned(
                top: -70,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: redColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Center(
                      child: Image.asset(
                        "assets/icons/questionmark5.png", // YOUR ICON
                        width: 55,
                        height: 55,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showFeedbackSubmittedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "Your Feedback was submitted successfully!",
                      fontSize: 16,
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.medium,
                    ),
                  ],
                ),
              ),

              Positioned(
                top: -74,
                child: Image.asset(
                  "assets/icons/check.png",
                  width: 135,
                  height: 135,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showApproveCompletionDialog({
    required BuildContext context,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              /// ================= WHITE CARD =================
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    CustomText(
                      "Approve Completion?",
                      fontSize: 17,
                      fontWeight: FontVariant.semiBold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    /// SUBTEXT
                    CustomText(
                      "By approving this proof, the task will be marked as Completed",
                      fontSize: 13,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 22),

                    /// ================= CONFIRM BUTTON =================
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        DialogHelpers().showTaskCompletedDialog(context);
                      },
                      child: CustomContainer(
                        height: 48,
                        borderRadius: BorderRadius.circular(14),
                        conColor: redColor,
                        child: Center(
                          child: CustomText(
                            "Confirm Approval",
                            fontSize: 16,
                            fontWeight: FontVariant.semiBold,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ================= GO BACK BUTTON =================
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: CustomContainer(
                        height: 48,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: blackColor, width: 1.5),
                        conColor: whiteColor,
                        child: Center(
                          child: CustomText(
                            "Go Back",
                            fontSize: 16,
                            fontWeight: FontVariant.medium,
                            color: blackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ================= TOP RED CHECK ICON =================
              Positioned(
                top: -73,
                child: Image.asset(
                  "assets/icons/check.png",
                  width: 135,
                  height: 135,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showLogoutDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // MAIN WHITE CARD
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 90,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TEXT
                    CustomText(
                      "Are You Sure you want to Logout",
                      fontSize: 16,
                      color: blackColor,
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.semiBold,
                    ),

                    const SizedBox(height: 25),

                    // BUTTONS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // NO BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: fundCardBorderColor,
                                width: 2,
                              ),
                              conColor: hColor.withOpacity(0.10),
                              child: const CustomText(
                                "No",
                                fontSize: 12,
                                color: redColor,
                                fontWeight: FontVariant.regular,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // YES BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              onConfirm();
                            },
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              conColor: redColor,
                              child: const CustomText(
                                "Yes",
                                fontSize: 14,
                                color: whiteColor,
                                fontWeight: FontVariant.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔴 TOP CIRCLE WITH LOGOUT ICON
              Positioned(
                top: -70,
                child: CustomContainer(
                  width: 140,
                  height: 140,
                  conColor: redColor,
                  shape: BoxShape.circle,
                  child: Center(
                    child: Image.asset(
                      "assets/icons/logout.png",
                      width: 55,
                      height: 55,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showReportUserSheet(BuildContext context) {
    int selectedIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            /// 🔥 UPDATED REASONS EXACTLY LIKE SCREENSHOT
            final List<String> reasons = [
              "Fake Profile",
              "Rude Communication",
              "Fraudulent Activity",
              "Suspicious Task Activity",
              "Other",
            ];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// -------- TOP RED QUESTION ICON --------
                  Image.asset(
                    "assets/icons/Group 1686555533.png",
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 15),

                  /// 🔥 UPDATED TITLE (MATCH SCREENSHOT)
                  CustomText(
                    "Report User",
                    fontWeight: FontVariant.semiBold,
                    fontSize: 20,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  /// 🔥 UPDATED SUBTITLE (MATCH SCREENSHOT)
                  CustomText(
                    "Tell us why you want to report this user",
                    fontSize: 16,
                    fontWeight: FontVariant.medium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  /// -------- REASONS LIST --------
                  Column(
                    children: List.generate(reasons.length, (index) {
                      bool selected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: CustomContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          borderRadius: BorderRadius.circular(12),
                          conColor: selected ? redColor : whiteColor,
                          border: Border.all(
                            color: selected ? redColor : blackColor,
                            width: 1.5,
                          ),

                          /// SAME SHADOW AS ORIGINAL
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],

                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: selected ? whiteColor : blackColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  reasons[index],
                                  fontSize: 15,
                                  fontWeight: FontVariant.semiBold,
                                  color: selected ? whiteColor : blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 5),

                  /// -------- ADDITIONAL DETAILS TITLE --------
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      "Add additional details (optional)",
                      fontWeight: FontVariant.medium,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 NEW TEXTFIELD + SHADOW ADDED (MATCHING SCREENSHOT STYLE)
                  CustomContainer(
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    conColor: white2Color,
                    height: 105,

                    /// SHADOW ADDED EXACTLY LIKE YOUR OPTION BOXES
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.20),
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],

                    child: const TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "e.g. Provide context",
                        hintStyle: TextStyle(color: taskstatus3, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// -------- CONTINUE BUTTON --------
                  CustomButton(
                    label: "Continue",
                    onPressed: () {
                      Get.back();
                      DialogHelpers.showReportSubmittedDialog(context: context);
                    },
                    bgColor: redColor,
                    textColor: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    height: 51,
                    fontSize: 17,
                    width: 233,
                    fontWeight: FontVariant.semiBold,
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showSupportHelpSheet(
    BuildContext context, {
    String? firstOptionText,
    String? lastOptionText,
    Function(String reason, String details)? onSubmit,
  }) {
    int selectedIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final List<String> reasons = [
              firstOptionText ?? "Helper is not responding",
              "Task is taking longer than expected",
              "Task details are unclear or incorrect",
              "Safety or comfort concern",
              lastOptionText ?? "Helper unresponsive",
              "Others", // 🔥 Added "Others" at the end
            ];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/icons/Group 1686555533.png",
                    height: 114,
                    width: 114,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 18),

                  CustomText(
                    "Need Help With This Task?",
                    fontWeight: FontVariant.semiBold,
                    fontSize: 20,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  CustomText(
                    "Tell us what went wrong, our support team will assist you shortly",
                    fontSize: 16,
                    fontWeight: FontVariant.medium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),

                  /// -------- REASONS LIST --------
                  Column(
                    children: List.generate(reasons.length, (index) {
                      bool selected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: CustomContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          borderRadius: BorderRadius.circular(12),
                          conColor: selected ? redColor : whiteColor,
                          border: Border.all(
                            color: selected ? redColor : blackColor,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: selected ? whiteColor : blackColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  reasons[index],
                                  fontSize: 15,
                                  fontWeight: FontVariant.semiBold,
                                  color: selected ? whiteColor : blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  /// -------- CONTINUE BUTTON --------
                  CustomButton(
                    label: "Continue",
                    onPressed: () {
                      final selectedReason = reasons[selectedIndex];

                      if (selectedReason == "Others") {
                        // 🔥 If "Others", show description sheet
                        DialogHelpers().showDescribeProblemSheet(
                          context,
                          selectedReason: selectedReason,
                          onSubmit: onSubmit,
                        );
                      } else {
                        // 🔥 If Predefined Option, submit immediately
                        if (onSubmit != null) {
                          // Pass selected reason, empty details (as per "eik jae" request)
                          onSubmit(selectedReason, "");
                        }
                        Get.back(); // Close sheet
                        DialogHelpers.showReportSubmittedDialog(
                          context: context,
                        );
                      }
                    },
                    bgColor: redColor,
                    textColor: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    height: 51,
                    fontSize: 17,
                    width: 233,
                    fontWeight: FontVariant.semiBold,
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showDescribeProblemSheet(
    BuildContext context, {
    String? selectedReason,
    Function(String reason, String details)? onSubmit,
  }) {
    TextEditingController msgController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// -------- TOP ICON --------
              Image.asset(
                "assets/icons/Group 1686555533.png",
                height: 114,
                width: 114,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              /// -------- TITLE --------
              CustomText(
                "Describe Your Problem",
                fontSize: 20,
                fontWeight: FontVariant.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              /// -------- SUBTITLE --------
              CustomText(
                "Please, Elaborate your problem, or what went wrong. Thanks!",
                fontSize: 16,
                fontWeight: FontVariant.medium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              /// -------- MESSAGE BOX --------
              CustomContainer(
                conColor: dialog1,
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.all(12),
                height: 266,
                width: double.infinity,
                child: TextField(
                  controller: msgController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontSize: 15, color: blackColor),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type your message...",
                    hintStyle: TextStyle(color: greyColor, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// -------- BUTTON --------
              CustomButton(
                label: "Continue",
                onPressed: () {
                  // 🔥 Call submit callback if provided
                  if (onSubmit != null) {
                    // 🔥 Pass usage typed text as the REASON, empty details (as per "user ke andr wala reason daal dena")
                    onSubmit(msgController.text, "");
                  }

                  Get.back(); // Close description sheet
                  Get.back(); // Close reason sheet
                  DialogHelpers.showReportSubmittedDialog(context: context);
                },
                height: 51,
                width: 233,
                bgColor: redColor,
                textColor: whiteColor,
                borderRadius: BorderRadius.circular(15),
                fontSize: 17,
                fontWeight: FontVariant.semiBold,
              ),

              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }

  void showRejectionReasonSheet(
    BuildContext context, {
    dynamic controller,
    String? taskId,
    String? proofId,
  }) {
    TextEditingController msgController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.50,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 25,
                bottom: MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: Column(
                children: [
                  /// -------- TOP ICON --------
                  Image.asset(
                    "assets/icons/Group 1686555649.png",
                    height: 114,
                    width: 114,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 20),

                  /// -------- TITLE --------
                  CustomText(
                    "Rejection Reason",
                    fontSize: 20,
                    fontWeight: FontVariant.bold,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  /// -------- SUBTITLE --------
                  CustomText(
                    "Please, Elaborate your problem, or what went wrong. Thanks!",
                    fontSize: 16,
                    fontWeight: FontVariant.medium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  /// -------- MESSAGE BOX --------
                  CustomContainer(
                    conColor: dialog1,
                    borderRadius: BorderRadius.circular(30),
                    padding: const EdgeInsets.all(12),
                    height: 266,
                    width: double.infinity,
                    child: TextField(
                      controller: msgController,
                      maxLength: 150, // 🔥 150 character limit
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(fontSize: 15, color: blackColor),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: greyColor, fontSize: 14),
                        counterText: "", // Hide counter
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// -------- BUTTON --------
                  CustomButton(
                    label: "Continue",
                    onPressed: () async {
                      if (msgController.text.trim().isEmpty) {
                        Get.snackbar('Error', 'Please enter a reason');
                        return;
                      }

                      // 🔥 Save custom reason to controller
                      if (controller != null) {
                        controller.selectedRejectionReason.value = 'Others';
                        controller.customRejectionReason.value = msgController
                            .text
                            .trim();

                        // Close dialogs
                        Navigator.of(context).pop(); // Close step2 dialog
                        Navigator.of(context).pop(); // Close step1 dialog

                        // Submit (navigation handled by callback)
                        await controller.submitRejection(
                          taskId: taskId ?? '',
                          proofId: proofId ?? '',
                        );
                      }
                    },
                    height: 51,
                    width: 233,
                    bgColor: redColor,
                    textColor: whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    fontSize: 17,
                    fontWeight: FontVariant.semiBold,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Escrow Detail Dialog Methods
  static void showTaskDetailsInfo() {
    Get.snackbar('Task Details', 'Navigating to task details...');
  }

  // Wallet Controller Dialog Methods
  static void showFundReleaseInfo() {
    Get.snackbar('Info', 'Funds are auto-released after successful validation');
  }

  static void showPriceInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: CustomContainer(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 25),
            conColor: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            child: CustomText(
              "🎈 Minimum Price, SAR 15 • Every task needs at least this starting amount",
              fontWeight: FontVariant.semiBold,
              textAlign: TextAlign.center,
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }

  static void showPaymentSuccessDialog({
    required BuildContext context,

    // OPTIONAL CUSTOM MESSAGE
    String message = "Thank you! Your vote has been submitted",
    // OPTIONAL BUTTON VISIBILITY
    bool showButton = true,
    void Function()? onButtonTap,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // ================= WHITE CARD =================
              CustomContainer(
                padding: EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: showButton ? 50 : 10, // adjust padding
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MAIN TEXT
                    CustomText(
                      message,
                      fontSize: 18,
                      fontWeight: FontVariant.semiBold,
                      textAlign: TextAlign.center,
                      color: blackColor,
                    ),

                    if (showButton) ...[
                      SizedBox(height: 25),

                      CustomButton(label: 'OK', onPressed: onButtonTap),
                    ],
                    if (showButton == false) SizedBox(height: 41.5),
                  ],
                ),
              ),

              // ================= RED CHECK ICON =================
              Positioned(
                top: -80,
                child: Image.asset(
                  'assets/icons/check.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showReportSubmittedDialog({
    required BuildContext context,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              /// ================= WHITE CARD =================
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// MAIN TITLE
                    CustomText(
                      "Report Submitted!",
                      fontSize: 18,
                      fontWeight: FontVariant.semiBold,
                      textAlign: TextAlign.center,
                      color: blackColor,
                    ),

                    const SizedBox(height: 3),

                    /// SUBTEXT
                    CustomText(
                      "Our Support Team will look into it, You will be notified shortly!",
                      fontSize: 13,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              /// ================= RED CHECK ICON =================
              Positioned(
                top: -74,
                child: Image.asset(
                  'assets/icons/check.png',
                  width: 135,
                  height: 135,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ===================================================
  /// SHOW OFFER CONFIRMATION DIALOG (Before Accept)
  /// ===================================================
  static void showOfferConfirmationDialog({
    required BuildContext context,
    required String offerId,
    required String taskId, // 🔥 Added taskId parameter
    required VoidCallback onAccepted,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // ================= WHITE CARD =================
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CONFIRMATION TEXT
                    const CustomText(
                      "Are you sure you want to accept this offer",
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                      color: blackColor,
                    ),

                    const SizedBox(height: 20),

                    // ================= BUTTONS ROW =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CANCEL BUTTON
                        CustomButton(
                          label: "Cancel",
                          onPressed: () {
                            Get.back(); // Just close dialog
                          },
                          height: 52,
                          width: 120,
                          bgColor: whiteColor,
                          textColor: redColor,
                          borderRadius: BorderRadius.circular(14),
                          fontSize: 16,
                          fontWeight: FontVariant.semiBold,
                          border: Border.all(color: redColor, width: 2),
                        ),

                        const SizedBox(width: 15),

                        // CONTINUE BUTTON
                        CustomButton(
                          label: "Continue",
                          onPressed: () async {
                            Get.back(); // Close confirmation dialog

                            // Update offer status to 'accepted' in Firestore
                            try {
                              // 🔥 First, fetch the offer to get offeringUserUid
                              final offerDoc = await FirebaseFirestore.instance
                                  .collection('offers')
                                  .doc(offerId)
                                  .get();

                              final offeringUserUid =
                                  offerDoc.data()?['offeringUserUid'] ?? '';

                              // Update offer status
                              await FirebaseFirestore.instance
                                  .collection('offers')
                                  .doc(offerId)
                                  .update({'status': 'accepted'});

                              print(
                                '✅ Offer $offerId status updated to accepted',
                              );

                              // 🔥 Update task status to 'in progress' and store offeringUserUid
                              await FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(taskId)
                                  .update({
                                    'status': 'in progress',
                                    'acceptedOfferUid':
                                        offeringUserUid, // 🔥 Store helper's UID
                                  });

                              print(
                                '✅ Task $taskId status updated to in progress with acceptedOfferUid: $offeringUserUid',
                              );

                              // Call the callback
                              onAccepted();

                              // 🔥 Close confirmation dialog first
                              Get.back();

                              // Close task details screen and navigate
                              Get.back(); // Close task details screen

                              // 🔥 Navigate to TaskInProgressScreen with specific taskId
                              Get.to(
                                () => TaskInProgressScreen(taskId: taskId),
                              );

                              // Show snackbar
                              Get.snackbar(
                                "Success",
                                "Offer accepted successfully!",
                              );
                            } catch (e) {
                              print('❌ Error updating offer/task status: $e');
                            }
                          },
                          height: 52,
                          width: 120,
                          bgColor: redColor,
                          textColor: whiteColor,
                          borderRadius: BorderRadius.circular(14),
                          fontSize: 16,
                          fontWeight: FontVariant.semiBold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ================= RED CHECK ICON ================= //
              Positioned(
                top: -60,
                child: Image.asset(
                  'assets/icons/check.png',
                  width: 130,
                  height: 130,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showOfferAcceptedDialog({
    required BuildContext context,
    String message = "Offer accepted successfully",
    String buttonText = "Continue",
    void Function()? onButtonTap,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // ================= WHITE CARD =================
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: taskstatus2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MAIN TEXT
                    CustomText(
                      message,
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                      color: blackColor,
                    ),

                    const SizedBox(height: 10),

                    // ================= CONTINUE BUTTON ================= //
                    CustomButton(
                      label: buttonText,
                      onPressed: () {
                        Get.to(() => TaskInProgressScreen());
                      },
                      height: 52,
                      width: 190,
                      bgColor: redColor,
                      textColor: whiteColor,
                      borderRadius: BorderRadius.circular(14),
                      fontSize: 16,
                      fontWeight: FontVariant.semiBold,
                    ),
                  ],
                ),
              ),

              // ================= RED CHECK ICON =================
              Positioned(
                top: -60,
                child: Image.asset(
                  'assets/icons/check.png', // SAME AS YOUR CHECK ICON
                  width: 130,
                  height: 130,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ===================================================
  /// SHOW HELPER PROFILE DIALOG
  /// ===================================================
  static void showHelperProfileDialog(
    BuildContext context,
    String name,
    String image,
    String id,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// BACK ARROW + TITLE
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: whiteColor,
                            size: 24,
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: CustomText(
                              "User Profile",
                              fontSize: 18,
                              fontWeight: FontVariant.bold,
                              color: whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),

                  /// MAIN PROFILE CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomContainer(
                      conColor: whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// RED AVATAR WITH BADGE
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomContainer(
                                  height: 100,
                                  width: 100,
                                  shape: BoxShape.circle,
                                  conColor: redColor,
                                  alignment: Alignment.center,
                                  child: image == ''
                                      ? CustomText(
                                          "A",
                                          fontSize: 45,
                                          fontWeight: FontVariant.bold,
                                          color: whiteColor,
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          child: Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CustomContainer(
                                    height: 24,
                                    width: 24,
                                    conColor: redColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: whiteColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            /// NAME
                            CustomText(
                              name == '' ? "Anton Furnitures" : name,
                              fontSize: 22,
                              fontWeight: FontVariant.bold,
                            ),
                            const SizedBox(height: 12),

                            /// BADGES ROW
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// RB TAG
                                CustomContainer(
                                  conColor: lightredcolor2,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  child: CustomText(
                                    id == '' ? "RB-452" : id,
                                    fontSize: 11,
                                    color: redColor,
                                    fontWeight: FontVariant.semiBold,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                /// VERIFIED BADGE
                                CustomContainer(
                                  conColor: greenBg,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: redColor,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        "Verified",
                                        fontSize: 11,
                                        color: walletSuccessColor,
                                        fontWeight: FontVariant.semiBold,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                /// ELITE TASKER BADGE
                                CustomContainer(
                                  conColor: const Color(0xFFFFF3E0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/icons/star.png",
                                        height: 14,
                                        width: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        "Elite Tasker",
                                        fontSize: 11,
                                        color: Color(0xFFF57C00),
                                        fontWeight: FontVariant.semiBold,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            /// USER RATING CARD
                            CustomContainer(
                              conColor: white2Color,
                              borderRadius: BorderRadius.circular(14),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                    "User's Rating",
                                    fontSize: 14,
                                    color: textcolord,
                                    fontWeight: FontVariant.medium,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: redColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      const CustomText(
                                        "4.9",
                                        fontSize: 18,
                                        fontWeight: FontVariant.bold,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// STATS CARD (RED BACKGROUND)
                            CustomContainer(
                              conColor: redColor,
                              borderRadius: BorderRadius.circular(16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CustomText(
                                                "Total Tasks Completed",
                                                fontSize: 13,
                                                color: whiteColor,
                                                fontWeight: FontVariant.medium,
                                              ),
                                              const SizedBox(height: 8),
                                              const CustomText(
                                                "08",
                                                fontSize: 28,
                                                fontWeight: FontVariant.bold,
                                                color: whiteColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CustomText(
                                                "Total Tasks Requested",
                                                fontSize: 13,
                                                color: whiteColor,
                                                fontWeight: FontVariant.medium,
                                              ),
                                              const SizedBox(height: 8),
                                              const CustomText(
                                                "15",
                                                fontSize: 28,
                                                fontWeight: FontVariant.bold,
                                                color: whiteColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Image.asset(
                                      "assets/icons/white_balloon.png",
                                      height: 90,
                                      width: 90,
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// USER RATING BREAKDOWN
                            CustomContainer(
                              conColor: redColor,
                              borderRadius: BorderRadius.circular(16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              child: Column(
                                children: [
                                  CustomContainer(
                                    conColor: redColor,
                                    borderRadius: BorderRadius.circular(16),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          "User Rating",
                                          fontSize: 16,
                                          fontWeight: FontVariant.bold,
                                          color: whiteColor,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                const CustomText(
                                                  "4.8",
                                                  fontSize: 28,
                                                  fontWeight: FontVariant.bold,
                                                  color: whiteColor,
                                                ),
                                                const SizedBox(height: 2),

                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: yellow,
                                                      size: 24,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: yellow,
                                                      size: 24,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: yellow,
                                                      size: 24,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: yellow,
                                                      size: 24,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: yellow,
                                                      size: 24,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),

                                                const CustomText(
                                                  "234 reviews",
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight:
                                                      FontVariant.medium,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  _ratingBar("5 ★", 0.75),
                                                  const SizedBox(height: 8),
                                                  _ratingBar("4 ★", 0.15),
                                                  const SizedBox(height: 8),
                                                  _ratingBar("3 ★", 0.07),
                                                  const SizedBox(height: 8),
                                                  _ratingBar("2 ★", 0.02),
                                                  const SizedBox(height: 8),
                                                  _ratingBar("1 ★", 0.01),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  /// REVIEWS SECTION
                                  CustomContainer(
                                    conColor: redColor,
                                    borderRadius: BorderRadius.circular(16),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    child: Column(
                                      children: [
                                        /// REVIEW 1
                                        CustomContainer(
                                          conColor: whiteColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CustomText(
                                                    "Michael Chen",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontVariant.bold,
                                                  ),
                                                  const CustomText(
                                                    "2 weeks ago",
                                                    fontSize: 11,
                                                    color: timeColor,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      (index) => Icon(
                                                        Icons.star,
                                                        color: yellow,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              const CustomText(
                                                "Absolutely stunning paint! They arrived healthy and vibrant. The colors are even better in person. The seller packaged them perfectly with the pots and the fish adapted quickly to my tank. Highly recommended!",
                                                fontSize: 12,
                                                color: textcolord,
                                                fontWeight: FontVariant.regular,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        /// REVIEW 2
                                        CustomContainer(
                                          conColor: whiteColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CustomText(
                                                    "Sarah Johnson",
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontVariant.bold,
                                                  ),
                                                  const CustomText(
                                                    "1 month ago",
                                                    fontSize: 11,
                                                    color: timeColor,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      (index) => Icon(
                                                        Icons.star,
                                                        color: yellow,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              const CustomText(
                                                "Beautiful discus pair. Arrived on time and in perfect condition. They're eating well and have great temperament. The seller was very responsive to questions.",
                                                fontSize: 12,
                                                color: textcolord,
                                                fontWeight: FontVariant.regular,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        /// READ ALL REVIEWS BUTTON
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const CustomText(
                                                "Read All 234 Reviews",
                                                fontSize: 13,
                                                color: whiteColor,
                                                fontWeight:
                                                    FontVariant.semiBold,
                                              ),
                                              const SizedBox(width: 6),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: whiteColor,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ===================================================
  /// RATING BAR HELPER
  /// ===================================================
  static Widget _ratingBar(String label, double percentage) {
    return Row(
      children: [
        CustomText(
          label,
          fontSize: 11,
          color: whiteColor,
          fontWeight: FontVariant.medium,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
              backgroundColor: whiteColor,
              valueColor: const AlwaysStoppedAnimation<Color>(yellow),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CustomText(
          "${(percentage * 100).toStringAsFixed(0)}%",
          fontSize: 11,
          color: whiteColor,
          fontWeight: FontVariant.medium,
        ),
      ],
    );
  }

  /// ================================
  /// STAT BOX BUILDER
  /// ================================
  static Widget _statBox(String title, String value, String imagePath) {
    return CustomContainer(
      conColor: white2Color,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Image.asset(imagePath, height: 24, width: 24, fit: BoxFit.contain),
          const SizedBox(height: 8),

          CustomText(title, fontSize: 12, color: timeColor),

          const SizedBox(height: 4),

          CustomText(
            value,
            fontSize: 20,
            fontWeight: FontVariant.bold,
            color: redColor,
          ),
        ],
      ),
    );
  }

  /// ===================================================
  /// SHOW SEND OFFER BOTTOM SHEET
  /// ===================================================
  static void showSendOfferBottomSheet(
    BuildContext context, {
    String? taskId,
    String? taskTitle,
    String? taskDescription,
    String? taskTimeAgo,
    String? taskType,
    String? taskImage,
    String? location,
    String? taskOwnerUid,
    String? taskOwnerName,
    String? taskOwnerPhoto,
    double? taskBudget,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SendOfferBottomSheet(
          taskId: taskId,
          taskTitle: taskTitle,
          taskDescription: taskDescription,
          taskTimeAgo: taskTimeAgo,
          taskType: taskType,
          taskImage: taskImage,
          location: location,
          taskOwnerUid: taskOwnerUid,
          taskOwnerName: taskOwnerName,
          taskOwnerPhoto: taskOwnerPhoto,
          taskBudget: taskBudget,
        );
      },
    );
  }

  /// ===================================================
  /// SHOW VOTE CONFIRMATION DIALOG
  /// ===================================================
  static void showVoteConfirmationDialog({
    required BuildContext context,
    required String voteType, // 'helper' or 'requester'
    required Future<void> Function() onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // MAIN WHITE CARD
              CustomContainer(
                padding: const EdgeInsets.only(
                  top: 90,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TITLE
                    const CustomText(
                      "Confirm Vote",
                      fontSize: 20,
                      color: blackColor,
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.bold,
                    ),

                    const SizedBox(height: 12),

                    // MESSAGE
                    CustomText(
                      "Are you sure you want to\nvote for ${voteType == 'helper' ? 'Helper' : 'Requester'}?",
                      fontSize: 16,
                      color: grey5Color,
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.regular,
                    ),

                    const SizedBox(height: 25),

                    // BUTTONS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CANCEL BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: fundCardBorderColor,
                                width: 2,
                              ),
                              conColor: hColor.withOpacity(0.10),
                              child: const CustomText(
                                "Cancel",
                                fontSize: 14,
                                color: redColor,
                                fontWeight: FontVariant.semiBold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // YES BUTTON
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              await onConfirm();
                            },
                            child: CustomContainer(
                              height: 48,
                              alignment: Alignment.center,
                              borderRadius: BorderRadius.circular(10),
                              conColor: redColor,
                              child: const CustomText(
                                "Yes",
                                fontSize: 14,
                                color: whiteColor,
                                fontWeight: FontVariant.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔴 TOP CIRCLE WITH VOTE ICON
              Positioned(
                top: -70,
                child: CustomContainer(
                  width: 140,
                  height: 140,
                  conColor: redColor,
                  shape: BoxShape.circle,
                  child: const Center(
                    child: Icon(Icons.how_to_vote, size: 60, color: whiteColor),
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
