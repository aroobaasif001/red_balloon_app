import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TOP APP BAR (unchanged)
            CustomAppBar1(title: 'Messages', showRightImage: false),

            /// 🔹 CHAT CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                children: [
                  /// 🔥 TASK HEADER CARD
                  CustomContainer(
                    conColor: whiteColor,
                    padding: const EdgeInsets.all(12),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/sofa.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Help Move Furniture",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                                color: blackColor,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                "500 SAR",
                                fontSize: 14,
                                fontWeight: FontVariant.bold,
                                color: redColor,
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_rounded,
                              size: 14,
                              color: timeColor,
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              "2 min ago",
                              fontSize: 12,
                              color: timeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 TODAY LABEL
                  Center(
                    child: CustomContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      conColor: greyLiteColor,
                      child: CustomText(
                        "Today",
                        fontSize: 12,
                        color: grey2Color,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔸 RECEIVER BUBBLE
                  _receiverBubble(
                    text:
                        "Hi! I saw your furniture moving task. I have experience with this and can help you this weekend.",
                    time: "10:23 AM",
                  ),

                  const SizedBox(height: 15),

                  /// 🔸 SENDER BUBBLE
                  _senderBubble(
                    text:
                        "Great! How much experience do you have with furniture moving?",
                    time: "10:25 AM",
                  ),

                  const SizedBox(height: 15),

                  /// 🔸 RECEIVER BUBBLE
                  _receiverBubble(
                    text:
                        "I've helped with 8 moving tasks on Red Balloon. I also have proper equipment and can bring help if needed.",
                    time: "10:27 AM",
                  ),

                  const SizedBox(height: 15),

                  /// 🔸 SENDER BUBBLE
                  _senderBubble(
                    text: "Perfect! What time works best for you on Saturday?",
                    time: "10:28 AM",
                  ),

                  const SizedBox(height: 20),

                  /// 🔸 RECEIVER IMAGE BUBBLE
                  _receiverImageBubble(
                    imgPath: "assets/images/sample_image.png",
                  ),
                ],
              ),
            ),

            /// 🔥 MESSAGE INPUT BAR
            CustomContainer(
              conColor: whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.attach_file_rounded, size: 26, color: grey4Color),

                  const SizedBox(width: 10),

                  Expanded(
                    child: CustomTextField(hintText: "Message...", radius: 30),
                  ),

                  const SizedBox(width: 10),

                  Icon(Icons.send_rounded, size: 28, color: redColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 RECEIVER MESSAGE BUBBLE
  // ---------------------------------------------------------
  Widget _receiverBubble({required String text, required String time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "A",
          fontSize: 14,
          fontWeight: FontVariant.bold,
          color: redColor,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                conColor: greyLiteColor,
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(12),
                child: CustomText(text, fontSize: 14, color: grey50Color),
              ),
              const SizedBox(height: 6),
              CustomText(time, fontSize: 11, color: timeColor),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 🔥 SENDER MESSAGE BUBBLE (Overflow FIXED)
  // ---------------------------------------------------------
  Widget _senderBubble({required String text, required String time}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          // 🔥 overflow fix
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomContainer(
                conColor: redColor,
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(12),
                child: CustomText(text, fontSize: 14, color: whiteColor),
              ),
              const SizedBox(height: 6),
              CustomText(time, fontSize: 11, color: timeColor),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 🔥 RECEIVER IMAGE BUBBLE
  // ---------------------------------------------------------
  Widget _receiverImageBubble({required String imgPath}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "A",
          fontSize: 14,
          fontWeight: FontVariant.bold,
          color: redColor,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: CustomContainer(
            conColor: whiteColor,
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            child: Image.asset(
              imgPath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
