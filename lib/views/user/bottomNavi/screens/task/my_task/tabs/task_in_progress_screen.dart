import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/task_review_screen.dart';

import '../../../../../../../custom_widgets/custom_button.dart';
import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customappbar.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/dialog_helpers.dart';

class TaskInProgressScreen extends StatelessWidget {
  const TaskInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ------------------ APP BAR ------------------
              CustomAppBar1(title: 'Task InProgress', showRightImage: false),

              const SizedBox(height: 15),

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
                          child: Image.asset(
                            "assets/images/sofa.png",
                            height: 155,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                        text: "(3.2 km away)",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
                      conColor: Colors.red,
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
                  conColor: Colors.white,
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
                            backgroundColor: Colors.red.shade100,
                            child: CustomText(
                              "AR",
                              fontWeight: FontVariant.bold,
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Anton Furnitures",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    "4.9 (25 tasks completed)",
                                    fontSize: 13,
                                    color: Colors.grey,
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
                                print("Chat tapped");
                              },
                              child: CustomContainer(
                                height: 45,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.red,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              onTap: () {
                                Get.to(() => TaskReviewScreen());
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      CustomText(
                                        "Call",
                                        fontWeight: FontVariant.semiBold,
                                        color: Colors.white,
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
                  conColor: Colors.white,
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
                                  color: Colors.black,
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: CustomText(
                                    "Help Move Furniture",
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
                                "SAR 650",
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
                                "15 mins ago",
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
                                "Riyadh",
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
                                "1 hour ago",
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
                  conColor: const Color(0xffF7F7F7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                  child: CustomText(
                    "Once the helper marks this task as completed, you’ll be asked to review and confirm within 2 minutes.",
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ------------------ REQUEST HELP BUTTON ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomButton(
                  label: "Request Help",
                  onPressed: () {
                    DialogHelpers().showSupportHelpSheet(context);
                  },
                  bgColor: redColor,
                  textColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              const SizedBox(height: 20),

              /// ------------------ ETA FOOTER ------------------
              Center(
                child: Column(
                  children: [
                    Container(height: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: "Helper en route — ",
                        style: const TextStyle(color: timeColor, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "ETA: 10 mins",
                            style: TextStyle(
                              color: Colors.black,
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
        ),
      ),
    );
  }
}
