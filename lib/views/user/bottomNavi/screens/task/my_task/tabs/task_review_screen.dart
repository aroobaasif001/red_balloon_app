import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../../utils/dialog_helpers.dart';
import 'leave_feedback_screen.dart';

class TaskReviewScreen extends StatelessWidget {
  const TaskReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- APP BAR ----------------
            CustomAppBar1(title: 'Task Review', showRightImage: false),

            const SizedBox(height: 15),

            /// ---------------- TITLE ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                "Help Move Furniture",
                fontWeight: FontVariant.bold,
                fontSize: 18,
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
                        /// RED INITIAL AVATAR
                        CustomContainer(
                          height: 45,
                          width: 45,
                          borderRadius: BorderRadius.circular(100),
                          conColor: redColor.withOpacity(0.1),
                          child: Center(
                            child: CustomText(
                              "A",
                              fontSize: 22,
                              fontWeight: FontVariant.bold,
                              color: redColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// NAME + PROOF BADGE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "Ahmed Al-Rashid",
                              fontSize: 16,
                              fontWeight: FontVariant.bold,
                            ),
                            const SizedBox(height: 6),

                            CustomContainer(
                              height: 26,
                              borderRadius: BorderRadius.circular(20),
                              conColor: const Color(0xffF0F0F0),
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
                  CustomContainer(
                    height: 72,
                    width: 72,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 3, color: redColor),
                    child: Center(
                      child: CustomText(
                        "02:00",
                        fontSize: 18,
                        fontWeight: FontVariant.bold,
                        color: redColor,
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
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    "Riyadh",
                    fontSize: 12,
                    fontWeight: FontVariant.regular,
                    color: timeColor,
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  CustomText(
                    "Submitted 2 min ago",
                    fontSize: 12,
                    color: timeColor,
                    fontWeight: FontVariant.regular,
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
                      Get.to(() => LeaveFeedbackScreen());
                    },
                    child: CustomContainer(
                      height: 150,
                      width:
                          (MediaQuery.of(context).size.width - 15 * 2 - 12) / 2,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/homedetail.png",
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
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
                              conColor: Colors.black.withOpacity(0.6),
                              child: CustomText(
                                "BEFORE",
                                color: Colors.white,
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
                      /// REJECT → Support BottomSheet
                      DialogHelpers().showNoVoteDialog(context: context);
                    },
                    child: CustomContainer(
                      height: 150,
                      conColor: Colors.white,
                      width:
                          (MediaQuery.of(context).size.width - 15 * 2 - 12) / 2,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/homedetail.png",
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
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
                              conColor: Colors.black.withOpacity(0.6),
                              child: CustomText(
                                "AFTER",
                                color: Colors.white,
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

            /// ---------------- DESCRIPTION BOX ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 18,
                ),
                conColor: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Helper has marked this task as completed and uploaded proof. Please review within ",
                        style: const TextStyle(fontSize: 14, color: timeColor),
                      ),
                      TextSpan(
                        text: "2 minutes",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ".",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
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
                        /// REJECT → Support BottomSheet
                        DialogHelpers().showRejectStep1Dialog(context);
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
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                "Reject Proof",
                                fontWeight: FontVariant.semiBold,
                                color: Colors.white,
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
                      onTap: () {
                        DialogHelpers().showApproveCompletionDialog(
                          context: context,
                        );
                      },
                      child: CustomContainer(
                        height: 52,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: historyGreenColor, width: 2),
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
      ),
    );
  }
}
