import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
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
            
            // 🔥 Fixed Task Header
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: TaskHeaderCard(
                taskTitle: controller.taskTitle,
                taskPrice: '', // 🔥 Removed "View Task"
                timeAgo: controller.taskStatus.value, // 🔥 Dynamic status
                taskImage: controller.taskImage.value,
              ),
            )),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  reverse: true, // 🔥 Starts at bottom, no animation needed
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    final isMyMessage = controller.isMyMessage(message);

                    // Determine if we should show a date divider above this message
                    bool showDateDivider = false;
                    if (index == controller.messages.length - 1) {
                      // It's the absolute oldest message
                      showDateDivider = true;
                    } else {
                      // Compare with the next (chronologically older) message
                      final previousMessage = controller.messages[index + 1];
                      if (!controller.isSameDay(
                        message.timestamp.toDate(),
                        previousMessage.timestamp.toDate(),
                      )) {
                        showDateDivider = true;
                      }
                    }

                    return Column(
                      children: [
                        if (showDateDivider) ...[
                          const SizedBox(height: 20),
                          Center(
                            child: CustomContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              conColor: walletCardBorderColor,
                              child: CustomText(
                                controller.getGroupDate(
                                  message.timestamp.toDate(),
                                ),
                                fontSize: 12,
                                color: grey1Color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: isMyMessage
                              ? SenderBubble(
                                  text: message.message,
                                  time: controller.getTimeAgo(
                                    message.timestamp.toDate(),
                                  ),
                                  imageUrl: message.imageUrl,
                                  onTapImage: () {
                                    if (message.imageUrl != null) {
                                      _showImageFullscreen(
                                        context,
                                        message.imageUrl!,
                                      );
                                    }
                                  },
                                )
                              : ReceiverBubble(
                                  text: message.message,
                                  time: controller.getTimeAgo(
                                    message.timestamp.toDate(),
                                  ),
                                  profilePhoto: controller.taskOwnerPhoto,
                                  userName: controller.taskOwnerName,
                                  imageUrl: message.imageUrl,
                                  onTapImage: () {
                                    if (message.imageUrl != null) {
                                      _showImageFullscreen(
                                        context,
                                        message.imageUrl!,
                                      );
                                    }
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            Obx(
              () => controller.isUploading.value
                  ? const LinearProgressIndicator(
                      color: redColor,
                      backgroundColor: Colors.transparent,
                    )
                  : const SizedBox.shrink(),
            ),

            ChatInputBar(
              controller: controller.messageController,
              onSend: controller.sendMessage,
              onAttach: controller.pickAndSendImage, // 🔥 Hook up attachment
            ),
          ],
        ),
      ),
    );
  }

  void _showImageFullscreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: blackColor,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: redColor),
                    );
                  },
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.close, color: whiteColor, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
