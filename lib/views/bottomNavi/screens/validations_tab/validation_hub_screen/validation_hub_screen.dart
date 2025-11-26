import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/validation_screen/validation_screen.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/validations_tab/widgets/validationemptywidget.dart';

import '../validation_history_screen/validation_history_screen.dart';

class ValidationHubScreen extends StatelessWidget {
  const ValidationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar1(
              title: 'Validation Hub',
              showLeftImage: false,
              onRightPressed: () {
                Get.to(() => ValidationHistoryScreen());
              },
            ),

            const SizedBox(height: 25),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6, // 🔥 Replace with your real count
              itemBuilder: (_, index) {
                // ------------------------
                // SHOW EMPTY WIDGET IF NO DATA
                // ------------------------
                if (index == 0 && 5 == 0) {
                  // itemCount == 0
                  return const ValidationEmptyWidget();
                }

                // ------------------------
                // OTHERWISE SHOW YOUR CARD
                // ------------------------
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    borderRadius: BorderRadius.circular(20),
                    conColor: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 3,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// BEFORE & AFTER IMAGES
                        Row(
                          children: [
                            Expanded(
                              child: CustomContainer(
                                height: 120,
                                conColor: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(16),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.only(bottom: 8),
                                child: const CustomText(
                                  "BEFORE",
                                  fontWeight: FontVariant.semiBold,
                                  fontSize: 12,
                                  color: blackColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: CustomContainer(
                                height: 120,
                                conColor: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(16),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.only(bottom: 8),
                                child: const CustomText(
                                  "AFTER",
                                  fontWeight: FontVariant.semiBold,
                                  fontSize: 12,
                                  color: blackColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// TITLE + BADGE
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                CustomText(
                                  "RB - 402",
                                  fontSize: 18,
                                  fontWeight: FontVariant.bold,
                                  fontType: AppFont.montserrat,
                                  color: blackColor,
                                ),
                                CustomText(
                                  "Help Move Furniture",
                                  fontSize: 16,
                                  fontWeight: FontVariant.semiBold,
                                  fontType: AppFont.montserrat,
                                  color: blackColor,
                                ),
                              ],
                            ),
                            const Spacer(),
                            CustomContainer(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              conColor: whiteColor,
                              child: const CustomText(
                                "Offline Task",
                                fontSize: 12,
                                fontWeight: FontVariant.medium,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        /// TIMER + BUTTON
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(
                                  7,
                                ), // FULL ROUND
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Image(
                                    image: AssetImage(
                                      "assets/icons/timer99.png",
                                    ),
                                    height: 20,
                                  ),
                                  SizedBox(width: 8),
                                  CustomText(
                                    "15 min left to validate",
                                    fontSize: 12,
                                    fontWeight: FontVariant.medium,
                                    color: blackColor,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: CustomButton(
                                label: "Review Proof",
                                onPressed: () {
                                  Get.to(() => ValidationScreen());
                                },
                                height: 40,
                                width: 80,
                                fontSize: 14,
                                fontWeight: FontVariant.bold,
                                borderRadius: BorderRadius.circular(14),
                                bgColor: redColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}
