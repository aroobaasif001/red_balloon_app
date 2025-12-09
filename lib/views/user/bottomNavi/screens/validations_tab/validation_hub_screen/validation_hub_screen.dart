import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../validation_history_screen/validation_history_screen.dart';
import '../validation_screen/validation_screen.dart';
import '../widgets/validationemptywidget.dart';

class ValidationHubScreen extends StatefulWidget {
  const ValidationHubScreen({super.key});

  @override
  State<ValidationHubScreen> createState() => _ValidationHubScreenState();
}

class _ValidationHubScreenState extends State<ValidationHubScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Lottie.asset(
                'assets/animation/loader.json',
                width: 250,
                height: 250,
              ),
            )
          : SingleChildScrollView(
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
                      return FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        delay: Duration(milliseconds: index * 700),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CustomContainer(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(20),
                            conColor: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: blackColor.withOpacity(0.20),
                                blurRadius: 3,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TITLE + BADGE
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  ],
                                ),

                                const SizedBox(height: 15),

                                /// TIMER + BUTTON
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        // horizontal: 8,
                                        // vertical: 9,
                                      ),
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(
                                          7,
                                        ), // FULL ROUND
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          CustomText(
                                            "15 min left to validate",
                                            fontSize: 12,
                                            fontWeight: FontVariant.regular,
                                            color: txColor,
                                          ),
                                          SizedBox(height: 7),
                                          CustomText(
                                            "Started at 09:15 PM",
                                            fontSize: 12,
                                            fontWeight: FontVariant.regular,
                                            color: txColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 50),

                                    Expanded(
                                      child: CustomButton(
                                        label: "Review Proof",
                                        trailing: Icon(
                                          Icons.arrow_right_alt_sharp,
                                          color: redColor,
                                        ),
                                        onPressed: () {
                                          Get.to(() => ValidationScreen());
                                        },
                                        height: 40,
                                        width: 80,
                                        fontSize: 14,
                                        fontWeight: FontVariant.bold,
                                        borderRadius: BorderRadius.circular(14),
                                        bgColor: whiteColor,
                                        textColor: redColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
