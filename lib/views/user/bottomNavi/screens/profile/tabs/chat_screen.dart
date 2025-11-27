import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../widgets/TaskHeaderCard1.dart';
import '../widgets/chatinputbar.dart';
import '../widgets/receiverbubble.dart';
import '../widgets/receiverimagebubble.dart';
import '../widgets/senderbubble.dart';
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
            CustomAppBar1(title: 'Messages', showRightImage: false),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  const TaskHeaderCard(),

                  const SizedBox(height: 20),

                  Center(
                    child: CustomContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      borderRadius: BorderRadius.circular(20),
                      conColor: Colors.grey.shade200,
                      child: CustomText(
                        "Today",
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const ReceiverBubble(
                    text:
                    "Hi! I saw your furniture moving task. I have experience with this and can help you this weekend.",
                    time: "10:23 AM",
                  ),
                  const SizedBox(height: 15),
                  const SenderBubble(
                    text:
                    "Great! How much experience do you have with furniture moving?",
                    time: "10:25 AM",
                  ),
                  const SizedBox(height: 15),
                  const ReceiverBubble(
                    text:
                    "I've helped with 8 moving tasks on Red Balloon. I also have proper equipment and can bring help if needed.",
                    time: "10:27 AM",
                  ),
                  const SizedBox(height: 15),
                  const SenderBubble(
                    text: "Perfect! What time works best for you on Saturday?",
                    time: "10:28 AM",
                  ),

                  const SizedBox(height: 20),

                  const ReceiverImageBubble(
                    imgPath: "assets/images/homedetail.png",
                  ),
                ],
              ),
            ),
            const ChatInputBar(),
          ],
        ),
      ),
    );
  }
}
