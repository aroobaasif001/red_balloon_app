// lib/views/bottomNavi/screens/validations_tab/validation_screen/validation_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/validation_history_screen/validation_history_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/validation_screen/tabs/AfterTab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/validation_screen/tabs/BeforeTab.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  int selectedTab = 0; // 0 = BEFORE, 1 = AFTER

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          CustomAppBar1(
            title: 'Validation',
            rightImagePath: 'assets/icons/button.png',
            rightImageHeight: 50,
            rightImageWidth: 20,
            onRightPressed: () {
              Get.to(()=>ValidationHistoryScreen());
            },
          ),

          const SizedBox(height: 20),

          /// 🔴 TOP SECTION (MATCHING SCREENSHOT)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TIMER + TITLE
                Row(
                  children: [
                    CustomContainer(
                      height: 54,
                      width: 54,
                      shape: BoxShape.circle,
                      border: Border.all(color: redColor, width: 3.5),
                      alignment: Alignment.center,
                      child: CustomText(
                        "14:56",
                        fontSize: 14,
                        fontWeight: FontVariant.bold,
                        color: redColor,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Help Move Furniture",
                          fontSize: 20,
                          fontWeight: FontVariant.bold,
                          color: Colors.black87,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                              AssetImage("assets/images/prof.png"),
                            ),
                            const SizedBox(width: 10),
                            CustomText(
                              "RB - 402",
                              fontSize: 16,
                              fontWeight: FontVariant.medium,
                              color: rbtxColor,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 35),

                /// DESCRIPTION
                CustomText(
                  "DESCRIPTION",
                  fontSize: 14,
                  fontWeight: FontVariant.bold,
                  color: Colors.grey,
                ),

                const SizedBox(height: 10),

                CustomText(
                  "Need help moving furniture from my apartment to a new location. "
                      "Items include a sofa, dining table, and several boxes. "
                      "Helper should have a truck or van. Estimated time: 3 hours.",
                  fontSize: 15,
                  fontWeight: FontVariant.regular,
                  color: Colors.black87,
                ),

                const SizedBox(height: 18),

                /// SUBMITTED ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/timer-icon1.png",
                      height: 18,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      "Submitted 2m ago",
                      fontSize: 14,
                      fontWeight: FontVariant.regular,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),

          /// 🔵 MAIN TABS
          Center(
            child: CustomContainer(
              height: 44,
              width: 173,
              borderRadius: BorderRadius.circular(14),
              conColor: Colors.grey.shade200,
              padding: const EdgeInsets.all(4),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 1,
                  offset: const Offset(0, 5),
                )
              ],

              child: Row(
                children: [
                  /// BEFORE TAB
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 0),
                      child: CustomContainer(
                        height: 36,
                        borderRadius: BorderRadius.circular(10),
                        conColor: selectedTab == 0
                            ? redColor
                            : Colors.transparent,
                        alignment: Alignment.center,
                        child: CustomText(
                          "BEFORE",
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: selectedTab == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  /// AFTER TAB
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = 1),
                      child: CustomContainer(
                        height: 36,
                        borderRadius: BorderRadius.circular(10),
                        conColor: selectedTab == 1
                            ? redColor
                            : Colors.transparent,
                        alignment: Alignment.center,
                        child: CustomText(
                          "AFTER",
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: selectedTab == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// TAB CONTENT
          Expanded(
            child: selectedTab == 0
                ? const BeforeTab()
                : const AfterTab(),
          ),
        ],
      ),
    );
  }
}
