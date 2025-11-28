import 'dart:ui';

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
                      "Due to no vote, the task has\nbeen moved to Validation Hub",
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

  void showRejectStep1Dialog(BuildContext context) {
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
                      "Please tell us why you're rejecting this proof\nThis helps us keep your task accurate",
                      textAlign: TextAlign.center,
                      fontWeight: FontVariant.medium,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 22),

                    /// NEXT BUTTON
                    InkWell(
                      onTap: () {
                        DialogHelpers().showRejectStep2Dialog(context);
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

  void showRejectStep2Dialog(BuildContext context) {
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
                          onPressed: () {
                            Get.back();
                            DialogHelpers().showRejectionReasonSheet(context);
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
                      "Task is marked as completed. Payment\nwill be released within 48 hours",
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
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TEXT
                    CustomText(
                      "Are You Sure you want\nto Save Profile",
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
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TEXT
                    CustomText(
                      "Are You Sure you want\nto buy this badge",
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
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "Your Feedback was submitted\nsuccessfully!",
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
                    color: Colors.black.withOpacity(0.15),
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
                      "By approving this proof, the task will be\nmarked as Completed",
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
                    "Tell us why you want to\nreport this user",
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
                              color: Colors.black.withOpacity(0.05),
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
                        color: Colors.black.withOpacity(0.20),
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

  void showSupportHelpSheet(BuildContext context) {
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
              "Helper is not responding",
              "Task is taking longer than expected",
              "Task details are unclear or incorrect",
              "Safety or comfort concern",
              "Helper unresponsive",
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
                    "Tell us what went wrong, our support\nteam will assist you shortly",
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
                              color: Colors.black.withOpacity(0.05),
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
                      DialogHelpers().showDescribeProblemSheet(context);
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

  void showDescribeProblemSheet(BuildContext context) {
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
                "Please, Elaborate your problem, or\nwhat went wrong. Thanks!",
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
                  Get.back();
                  Get.back();
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

  void showRejectionReasonSheet(BuildContext context) {
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
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
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
                    "Please, Elaborate your problem, or\nwhat went wrong. Thanks!",
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
                      Get.back();
                      Get.back();
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
                color: Colors.black.withOpacity(0.15),
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
    String message = "Thank you! Your vote has\nbeen submitted",
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
                    color: Colors.black.withOpacity(0.15),
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
                    color: Colors.black.withOpacity(0.15),
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
                      "Our Support Team will look into it,\nYou will be notified shortly!",
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
                    color: Colors.black.withOpacity(0.15),
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

                    // ================= CONTINUE BUTTON =================
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
  static void showHelperProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 35,
            ),
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CustomContainer(
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(30),

                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 25,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// FLAG + CLOSE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              DialogHelpers().showReportUserSheet(context);
                            },
                            child: Icon(
                              Icons.flag_outlined,
                              color: redColor,
                              size: 22,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: timeColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// RED AVATAR
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomContainer(
                            height: 90,
                            width: 90,

                            shape: BoxShape.circle,
                            conColor: redColor,

                            alignment: Alignment.center,
                            child: CustomText(
                              "A",
                              fontSize: 40,
                              fontWeight: FontVariant.bold,
                              color: whiteColor,
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: CustomContainer(
                              height: 18,
                              width: 18,
                              conColor: redColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: whiteColor, width: 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      /// NAME
                      CustomText(
                        "Anton Furnitures",
                        fontSize: 20,
                        fontWeight: FontVariant.bold,
                      ),
                      const SizedBox(height: 10),

                      /// RB TAG
                      CustomContainer(
                        conColor: lightredcolor2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        child: CustomText(
                          "RB-452",
                          fontSize: 12,
                          color: redColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      /// VERIFIED HELPER TAG
                      CustomContainer(
                        conColor: greenBg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: redColor),
                            const SizedBox(width: 6),
                            CustomText(
                              "Verified Helper",
                              fontSize: 13,
                              color: walletSuccessColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      /// STAR + RATING SECTION
                      CustomContainer(
                        conColor: lightgray3,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: redColor, size: 26),
                                const SizedBox(width: 8),
                                CustomText(
                                  "4.9",
                                  fontSize: 22,
                                  fontWeight: FontVariant.bold,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            CustomText(
                              "(25 tasks completed)",
                              fontSize: 13,
                              color: timeColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 2 × 2 STATS GRID
                      Row(
                        children: [
                          Expanded(
                            child: _statBox(
                              "Validation \nAccuracy",
                              "96%",
                              'assets/icons/streamline-color_target.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statBox(
                              "Response Time",
                              "< 5 min",
                              'assets/icons/material-symbols_avg-time-outline.png',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _statBox(
                              "Distance",
                              "3.2 km",
                              'assets/icons/duo-icons_location.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statBox(
                              "Completion Rate",
                              "98%",
                              'assets/icons/charm_circle-tick.png',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// DESCRIPTION BOX
                      CustomContainer(
                        conColor: white2Color,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/duo-icons_message-3.png", // 🔥 your image path here
                              height: 24,
                              width: 24,
                              color:
                                  redColor, // ⭐ keeps the same red tint/color
                            ),

                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomText(
                                "Reliable and quick worker from Riyadh. I have 3 years of experience helping with moving, delivery, and errands. Always on time and careful with belongings!",
                                fontSize: 14,
                                color: timeColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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

          CustomText(title, fontSize: 13, color: timeColor),

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
  static void showSendOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const SendOfferBottomSheet();
      },
    );
  }
}

/// =================================================================
/// SMALL STAT BOX WIDGET (Matches Screenshot Perfectly)
/// =================================================================
Widget _statBox(String title, String value, IconData icon) {
  return CustomContainer(
    conColor: beforecolor,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Column(
      children: [
        Icon(icon, color: redColor, size: 26),
        const SizedBox(height: 8),
        CustomText(title, fontSize: 13, color: greyColor),
        const SizedBox(height: 4),
        CustomText(
          value,
          fontSize: 18,
          fontWeight: FontVariant.bold,
          color: redColor,
        ),
      ],
    ),
  );
}
