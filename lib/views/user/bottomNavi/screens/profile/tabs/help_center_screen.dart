import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../widgets/faqtile.dart';
import 'contact_support.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  /// Track dropdown open/close states
  List<bool> isOpenList = [false, false, false, false, false];

  /// One main answer for all FAQs
  String mainAnswer =
      "To post a new task:\n1. Go to the Create Task section.\n2. Enter your task details (title, description, deadline, budget, etc.).\n3. Upload any required files (optional).\n4. Submit the task. Once submitted, your task becomes visible to validators who can review and accept it.";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar1(title: 'Help Center', showRightImage: false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      /// COMMON TOPICS TITLE
                      CustomText(
                        'Common Topics',
                        fontSize: 16,
                        fontWeight: FontVariant.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 15),

                      /// FAQ TILES
                      FaqTile(
                        index: 0,
                        question: "How to post a new task?",
                        isOpen: isOpenList[0],
                        answer: mainAnswer,
                        onTap: () {
                          setState(() {
                            isOpenList[0] = !isOpenList[0];
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      FaqTile(
                        index: 1,
                        question: "How does escrow work?",
                        isOpen: isOpenList[1],
                        answer: mainAnswer,
                        onTap: () {
                          setState(() {
                            isOpenList[1] = !isOpenList[1];
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      FaqTile(
                        index: 2,
                        question: "When can I withdraw my balance?",
                        isOpen: isOpenList[2],
                        answer: mainAnswer,
                        onTap: () {
                          setState(() {
                            isOpenList[2] = !isOpenList[2];
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      FaqTile(
                        index: 3,
                        question: "How are validators chosen?",
                        isOpen: isOpenList[3],
                        answer: mainAnswer,
                        onTap: () {
                          setState(() {
                            isOpenList[3] = !isOpenList[3];
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      FaqTile(
                        index: 4,
                        question: "What if my task is rejected?",
                        isOpen: isOpenList[4],
                        answer: mainAnswer,
                        onTap: () {
                          setState(() {
                            isOpenList[4] = !isOpenList[4];
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      /// MORE OPTIONS TITLE
                      CustomText(
                        'More Options',
                        fontSize: 16,
                        fontWeight: FontVariant.bold,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 15),

                      /// CONTACT SUPPORT CARD
                      CustomContainer(
                        conColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 25,
                          horizontal: 16,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/icons/Mask group (1).png',
                              ),
                              height: 28,
                              width: 28,
                            ),
                            const SizedBox(height: 10),
                            CustomText(
                              'Still need help?',
                              fontSize: 16,
                              fontWeight: FontVariant.bold,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 20),
                            CustomText(
                              'Chat with our support team.',
                              fontSize: 14,
                              fontWeight: FontVariant.regular,
                              color: timeColor,
                            ),
                            const SizedBox(height: 10),

                            /// RED BUTTON
                            InkWell(
                              onTap: () {
                                Get.to(() => contactsupportScreen());
                              },
                              child: CustomContainer(
                                height: 48,
                                conColor: redColor,
                                borderRadius: BorderRadius.circular(20),
                                alignment: Alignment.center,
                                child: CustomText(
                                  "Contact Support",
                                  fontSize: 16,
                                  fontWeight: FontVariant.semiBold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: CustomText(
                          "Support available 24/7",
                          fontSize: 12,
                          color: walletTextGreyColor,
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
