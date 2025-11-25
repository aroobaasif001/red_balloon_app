import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../custom_widgets/custom_button.dart';
import '../views/bottomNavi/screens/task/my_task/tabs/task_in_progress_screen.dart';
import '../views/bottomNavi/screens/task/my_task/widgets/send_offer_bottom_sheet.dart';
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
                conColor: const Color(0xFFF7FFF7),
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
                    CustomText(
                      "Due to no vote, the task has\nbeen moved to Validation Hub",
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              Positioned(
                top: -80,
                child: Image.asset(
                  "assets/icons/Group 1686555644.png",
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
                conColor: Colors.white,
                borderRadius: BorderRadius.circular(22),
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
                            color: Colors.white,
                            fontWeight: FontVariant.semiBold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// GO BACK BUTTON
                    CustomContainer(
                      height: 48,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black87, width: 1.3),
                      conColor: Colors.white,
                      child: Center(
                        child: CustomText(
                          "Go Back",
                          fontSize: 15,
                          fontWeight: FontVariant.medium,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: -80,
                child: Image.asset(
                  "assets/icons/check.png",
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

  void showRejectStep2Dialog(BuildContext context) {
    int selected = 0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                  conColor: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
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
                                vertical: 14, horizontal: 12),
                            margin: const EdgeInsets.only(bottom: 12),
                            borderRadius: BorderRadius.circular(12),
                            conColor: active ? redColor : Colors.white,
                            border: Border.all(
                              color: active ? redColor : Colors.black26,
                              width: 1.3,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  active ? Icons.check_circle : Icons.circle_outlined,
                                  color: active ? Colors.white : Colors.black,
                                ),
                                const SizedBox(width: 10),
                                CustomText(
                                  reasons[i],
                                  color: active ? Colors.white : Colors.black,
                                  fontWeight: FontVariant.medium,
                                  fontSize: 15,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 5),

                      CustomContainer(
                        height: 48,
                        width: 150,
                        borderRadius: BorderRadius.circular(12),
                        conColor: redColor,
                        child: Center(
                          child: CustomText(
                            "Submit Rejection",
                            fontSize: 15,
                            fontWeight: FontVariant.semiBold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: -80,
                  child: Image.asset(
                    "assets/icons/Group 1686555649.png",
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
          );
        });
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
                    top: 80, left: 25, right: 25, bottom: 20),
                conColor: const Color(0xFFF7FFF7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "Task Completed!",
                      fontSize: 20,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      "Task is marked as completed. Payment\nwill be released within 48 hours",
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),

              Positioned(
                top: -80,
                child: Image.asset(
                  "assets/icons/check.png",
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
                conColor: const Color(0xFFF7FFF7),
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
                top: -80,
                child: Image.asset(
                  "assets/icons/check.png",
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
                conColor: const Color(0xFFF7FFF7),
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
                      fontSize: 16,
                      fontWeight: FontVariant.semiBold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    /// SUBTEXT
                    CustomText(
                      "By approving this proof, the task will be\nmarked as Completed",
                      fontSize: 12,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 22),

                    /// ================= CONFIRM BUTTON =================
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // Your Confirm Action Here
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
                            color: Colors.white,
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
                        border: Border.all(color: Colors.black, width: 1.5),
                        conColor: Colors.white,
                        child: Center(
                          child: CustomText(
                            "Go Back",
                            fontSize: 16,
                            fontWeight: FontVariant.medium,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ================= TOP RED CHECK ICON =================
              Positioned(
                top: -80,
                child: Image.asset(
                  "assets/icons/check.png",
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



  void showSupportHelpSheet(BuildContext context) {
    int selectedIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
                    width:114,
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
                              horizontal: 10, vertical: 14),
                          margin: const EdgeInsets.only(bottom: 12),
                          borderRadius: BorderRadius.circular(12),
                          conColor: selected ? redColor : Colors.white,
                          border: Border.all(
                            color: selected ? redColor : Colors.black,
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
                                color:
                                selected ? Colors.white : Colors.black,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  reasons[index],
                                  fontSize: 15,
                                  fontWeight: FontVariant.semiBold,
                                  color: selected
                                      ? Colors.white
                                      : Colors.black,
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
                    textColor: Colors.white,
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
      backgroundColor: Colors.white,
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
                width:114,
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
                conColor: Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.all(12),
                height: 266,
                width: double.infinity,
                child: TextField(
                  controller: msgController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type your message...",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
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
                textColor: Colors.white,
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
            conColor: Colors.white,
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
                  bottom: showButton ? 25 : 10, // adjust padding
                ),
                conColor: const Color(0xFFF7FFF7),
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
                      color: Colors.black87,
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
                conColor: const Color(0xFFF7FFF7), // same mint/white tone
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
                      fontSize: 20,
                      fontWeight: FontVariant.semiBold,
                      textAlign: TextAlign.center,
                      color: Colors.black,
                    ),

                    const SizedBox(height: 3),
                    /// SUBTEXT
                    CustomText(
                      "Our Support Team will look into it,\nYou will be notified shortly!",
                      fontSize: 14,
                      fontWeight: FontVariant.medium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              /// ================= RED CHECK ICON =================
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
                conColor: const Color(0xFFF7FFF7),
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
                      color: Colors.black87,
                    ),

                    const SizedBox(height: 10),

                    // ================= CONTINUE BUTTON =================
                    CustomButton(
                      label: buttonText,
                      onPressed: () {
                        Get.to(()=>TaskInProgressScreen());
                      },
                      height: 52,
                      width: 190,
                      bgColor: const Color(0xFFE53935),
                      textColor: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      fontSize: 18,
                      fontWeight: FontVariant.semiBold,
                    ),
                  ],
                ),
              ),

              // ================= RED CHECK ICON =================
              Positioned(
                top: -80,
                child: Image.asset(
                  'assets/icons/check.png', // SAME AS YOUR CHECK ICON
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
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
                          Icon(Icons.flag_outlined, color: redColor, size: 22),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: walletTextGreyColor,
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
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: redColor,
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              "A",
                              fontSize: 40,
                              fontWeight: FontVariant.bold,
                              color: Colors.white,
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
                              border: Border.all(color: Colors.white, width: 1),
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
                        conColor: Colors.red.shade50,
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
                        conColor: Colors.grey.shade100,
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
                              "Validation Accuracy",
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
                        conColor: Colors.grey.shade100,
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
      conColor: Colors.grey.shade100,
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
    conColor: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Column(
      children: [
        Icon(icon, color: redColor, size: 26),
        const SizedBox(height: 8),
        CustomText(title, fontSize: 13, color: Colors.grey),
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
