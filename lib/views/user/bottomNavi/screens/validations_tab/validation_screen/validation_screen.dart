import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/tabs/AfterTab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/tabs/BeforeTab.dart';

class ValidationScreen extends StatefulWidget {
  final bool isTask;
  const ValidationScreen({super.key, this.isTask = false});

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
              showRightImage: false,
            ),

            const SizedBox(height: 20),

            /// 🔴 TOP SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE + TITLE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage("assets/images/prof.png"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "Help Move Furniture",
                              fontSize: 18,
                              fontWeight: FontVariant.bold,
                              color: blackColor,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                CustomText(
                                  "RB - 402",
                                  fontSize: 13,
                                  fontWeight: FontVariant.medium,
                                  color: walletGrey600Color,
                                ),
                                const SizedBox(width: 6),
                                CustomText(
                                  "•",
                                  fontSize: 13,
                                  fontWeight: FontVariant.medium,
                                  color: walletGrey600Color,
                                ),
                                const SizedBox(width: 6),
                                CustomText(
                                  "Submitted 2m ago",
                                  fontSize: 13,
                                  fontWeight: FontVariant.medium,
                                  color: walletGrey600Color,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  CustomText(
                    "Need help moving furniture from my apartment to a new location. "
                    "Items include a sofa, dining table, and several boxes.",
                    fontSize: 14,
                    fontWeight: FontVariant.regular,
                    color: walletGrey600Color,
                  ),

                  const SizedBox(height: 20),

                  /// ⭐ VALIDATION STATISTICS
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    conColor: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                        const SizedBox(height: 24),

                        /// Votes Received Row
                        _buildStatRow("Votes Received", "03"),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: greyColor.withOpacity(0.2),
                            thickness: 1,
                            height: 1,
                          ),
                        ),

                        /// Votes Needed Row
                        _buildStatRow("Votes Needed", "09"),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: greyColor.withOpacity(0.2),
                            thickness: 1,
                            height: 1,
                          ),
                        ),

                        /// Time Left Row
                        _buildStatRow("Time Left", "14:56"),
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
                conColor: appbard,
                padding: const EdgeInsets.all(4),
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.15),
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
                                ? whiteColor
                                : walletGrey500Color,
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
                                ? whiteColor
                                : walletGrey500Color,
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
            selectedTab == 0
                ? BeforeTab(isTask: widget.isTask)
                : AfterTab(isTask: widget.isTask),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// Helper method to build each statistics row
  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: 16,
          fontWeight: FontVariant.medium,
          color: lastTextColor,
        ),
        CustomText(
          value,
          fontSize: 20,
          fontWeight: FontVariant.bold,
          color: redColor,
        ),
      ],
    );
  }
}
