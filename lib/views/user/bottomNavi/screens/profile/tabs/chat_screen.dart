import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../widgets/TaskHeaderCard1.dart';
import '../widgets/chatinputbar.dart';
import '../widgets/receiverbubble.dart';
import '../widgets/senderbubble.dart';
import 'controller/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar1(title: 'Messages', showRightImage: false),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }

                return ListView(
                  controller: controller.scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  children: [
                    // Task Header
                    TaskHeaderCard(
                      taskTitle: controller.taskTitle,
                      taskPrice: 'View Task', // Could be dynamic
                      timeAgo: 'Active',
                    ),

                    const SizedBox(height: 20),

                    // Date Divider
                    Center(
                      child: CustomContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        borderRadius: BorderRadius.circular(20),
                        conColor: walletCardBorderColor,
                        child: CustomText(
                          "Today",
                          fontSize: 12,
                          color: grey1Color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Messages List
                    ...controller.messages.map((message) {
                      final isMyMessage = controller.isMyMessage(message);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: isMyMessage
                            ? SenderBubble(
                                text: message.message,
                                time: controller
                                    .getTimeAgo(message.timestamp.toDate()),
                              )
                            : ReceiverBubble(
                                text: message.message,
                                time: controller
                                    .getTimeAgo(message.timestamp.toDate()),
                              ),
                      );
                    }).toList(),

                    // Show empty state if no messages
                    if (controller.messages.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 60,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              CustomText(
                                'Start the conversation',
                                fontSize: 16,
                                color: Colors.grey[500]!,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),

            ChatInputBar(
              controller: controller.messageController,
              onSend: controller.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
