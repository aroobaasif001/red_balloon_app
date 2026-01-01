import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/formatted_text.dart';
import 'package:red_balloon_app/utils/colors.dart';

import 'package:url_launcher/url_launcher.dart';
import '../widgets/faqtile.dart';
import '../controllers/user_app_content_controller.dart'; // Keep original import for UserAppContentController
import 'contact_support.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  /// Track dropdown open/close states
  List<bool> isOpenList = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final contentController = Get.put(UserAppContentController());

    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar1(
                title: contentController.getTitle('help_center', 'Help Center'), 
                showRightImage: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final dynamicContent = contentController.getContent('help_center', '');
                      if (dynamicContent.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          FormattedText(
                            text: dynamicContent,
                            fontSize: 14,
                            color: blackColor.withOpacity(0.7),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 40),

                    /// COMMON TOPICS TITLE
                    CustomText(
                      'Common Topics',
                      fontSize: 16,
                      fontWeight: FontVariant.bold,
                      color: blackColor,
                    ),
                    const SizedBox(height: 15),

                    /// FAQ TILES
                    FaqTile(
                      index: 0,
                      question: "How to post a new task?",
                      isOpen: isOpenList[0],
                      answer: 
"To post a new task:\n\n"
"1. Go to the Create Task section.\n"
"2. Enter your task details (title, description, deadline, budget, etc.).\n"
"3. Upload any required files (optional).\n"
"4. Submit the task. Once submitted, your task becomes visible to validators who can review and accept it.",
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
                      answer: 
"When you post a task, the task amount is locked securely in escrow from your wallet.\n\n"
"This means:\n"
"• The money is not given to the helper immediately\n"
"• It stays safely held by the platform\n"
"• The helper only gets paid after the task is completed and approved by community validators\n\n"
"If the task is:\n"
"• Approved: Payment is released to the helper\n"
"• Rejected: The amount is refunded back to your wallet\n\n"
"This system ensures fairness and protection for both requesters and helpers.",
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
                      answer: 
"Withdrawal rules depend on your role:\n\n"
"Helpers:\n"
"• Can withdraw only after the task is approved\n"
"• Funds are released after a 48-hour holding period\n"
"• Minimum withdrawal amount: 100 SAR\n\n"
"Validators:\n"
"• Can withdraw once their balance reaches 100 SAR\n"
"• If balance goes negative due to wrong validations, withdrawal is blocked until it becomes positive\n\n"
"Requesters:\n"
"• Can withdraw unused or refunded balance anytime",
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
                      answer: 
"Validators are selected automatically and randomly by the system.\n\n"
"Key points:\n"
"• 9 validators are chosen for each task\n"
"• They can be from anywhere in Saudi Arabia\n"
"• Selection is based on:\n"
"   - Availability\n"
"   - Validation accuracy\n"
"   - No active suspension\n\n"
"To approve a task:\n"
"• At least 6 out of 9 validators must agree\n\n"
"This ensures unbiased and community-driven decisions.",
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
                      answer: 
"If a task is rejected by the validators:\n"
"• The helper does not receive payment\n"
"• The full task amount is refunded to your wallet\n"
"• You can:\n"
"   - Post the task again\n"
"   - Modify task details\n"
"   - Choose a different helper (if offers are still available)\n\n"
"Your money always remains protected under the escrow system.",
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
                      color: blackColor,
                    ),
                    const SizedBox(height: 15),

                    const SizedBox(height: 25),

                    /// CONTACT SUPPORT CARD
                    CustomContainer(
                      conColor: whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 16,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.20),
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      child: Column(
                        children: [
                          const Image(
                            image: AssetImage(
                              'assets/icons/Mask group (1).png',
                            ),
                            height: 28,
                            width: 28,
                          ),
                          const SizedBox(height: 10),
                          const CustomText(
                            'Still need help?',
                            fontSize: 16,
                            fontWeight: FontVariant.bold,
                            color: blackColor,
                          ),
                          const SizedBox(height: 15),
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
                              Get.to(() => const contactsupportScreen());
                            },
                            child: CustomContainer(
                              height: 48,
                              conColor: redColor,
                              borderRadius: BorderRadius.circular(20),
                              alignment: Alignment.center,
                              child: const CustomText(
                                "Contact Support",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                                color: whiteColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
