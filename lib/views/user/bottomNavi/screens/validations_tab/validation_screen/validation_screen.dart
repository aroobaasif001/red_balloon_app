import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/tabs/AfterTab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/tabs/BeforeTab.dart';

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
      body: SingleChildScrollView(
        // ✅ SCROLLABLE ADDED
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            CustomAppBar1(
              title: 'Validation',
              rightImagePath: 'assets/icons/button.png',
              rightImageHeight: 50,
              rightImageWidth: 20,
            ),

            const SizedBox(height: 20),

            /// 🔴 TOP SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE + TITLE + TIMER (RIGHT SIDE)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// LEFT — IMAGE + TEXT
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(
                              "assets/images/prof.png",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Help Move Furniture",
                                fontSize: 18,
                                fontWeight: FontVariant.bold,
                                color: blackColor,
                              ),
                              const SizedBox(height: 2),
                              CustomText(
                                "RB - 402",
                                fontSize: 14,
                                fontWeight: FontVariant.medium,
                                color: rbtxColor,
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// RIGHT — TIMER (EXACT LIKE YOUR IMAGE)
                      CustomContainer(
                        width: 55,
                        height: 55,
                        borderRadius: BorderRadius.circular(60),
                        conColor: whiteColor,
                        border: Border.all(color: redColor, width: 3),
                        alignment: Alignment.center,
                        child: CustomText(
                          "14:56",
                          fontSize: 16,
                          fontWeight: FontVariant.bold,
                          color: redColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  CustomText(
                    "DESCRIPTION",
                    fontSize: 14,
                    fontWeight: FontVariant.bold,
                    color: greyColor,
                  ),

                  const SizedBox(height: 10),

                  CustomText(
                    "Need help moving furniture from my apartment to a new location. "
                    "Items include a sofa, dining table, and several boxes. "
                    "Helper should have a truck or van. Estimated time: 3 hours.",
                    fontSize: 15,
                    fontWeight: FontVariant.regular,
                    color: blackColor,
                  ),

                  const SizedBox(height: 18),

                  /// SUBMITTED TIME ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/timer99.png", height: 18),
                      const SizedBox(width: 8),
                      CustomText(
                        "Submitted 2m ago",
                        fontSize: 14,
                        fontWeight: FontVariant.regular,
                        color: walletGrey600Color,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// ⭐ VALIDATION STATISTICS
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    conColor: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/statistics.png",
                              height: 21,
                            ),
                            const SizedBox(width: 8),
                            const CustomText(
                              "Validation Statistics",
                              fontSize: 18,
                              fontWeight: FontVariant.semiBold,
                              color: lastTextColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const CustomText(
                                  "03 Votes Received",
                                  fontSize: 14,
                                  fontWeight: FontVariant.bold,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const CustomText(
                                  "09 Votes Needed",
                                  fontSize: 14,
                                  fontWeight: FontVariant.bold,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                conColor: beforecolor,
                padding: const EdgeInsets.all(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
                child: Row(
                  children: [
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

            /// TAB CONTENT (NO EXPANDED INSIDE SCROLL)
            selectedTab == 0 ? const BeforeTab() : const AfterTab(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
