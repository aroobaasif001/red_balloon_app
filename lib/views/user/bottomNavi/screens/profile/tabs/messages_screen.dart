import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/tabs/chat_screen.dart';

import '../../../../../../custom_widgets/custom_textfield.dart';
import '../../../../../../custom_widgets/customappbar.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../widgets/messagetile.dart';
import 'controller/chat_controller.dart';
import 'controller/messages_controller.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MessagesController>()
        ? Get.find<MessagesController>()
        : Get.put(MessagesController());

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar1(title: 'Messages', showRightImage: false),
            // 🔹 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomTextField(
                hintText: 'Search conversations',
                onChanged: (value) => controller.updateSearch(value),
                prefixWidget: const Image(
                  image: AssetImage('assets/icons/i (5).png'),
                  height: 25,
                  width: 25,
                ),
              ),
            ),

            // 🔹 MESSAGE LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }

                if (controller.filteredConversations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          controller.searchQuery.value.isEmpty
                              ? 'No conversations yet'
                              : 'No results found',
                          fontSize: 16,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          controller.searchQuery.value.isEmpty
                              ? 'Start chatting from task details'
                              : 'Try a different search term',
                          fontSize: 14,
                          color: Colors.grey[500]!,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: controller.filteredConversations.length,
                  itemBuilder: (context, index) {
                    final conversation =
                        controller.filteredConversations[index];
                    final otherParticipant = conversation.getOtherParticipant(
                      controller.chatService.currentUserId!,
                    );
                    final unreadCount = conversation.getUnreadCountForUser(
                      controller.chatService.currentUserId!,
                    );

                    return Dismissible(
                      key: Key(conversation.conversationId),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        color: redColor,
                        child: const Icon(
                          Icons.delete_outline,
                          color: whiteColor,
                        ),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: redColor,
                        child: const Icon(
                          Icons.delete_outline,
                          color: whiteColor,
                        ),
                      ),
                      onDismissed: (direction) {
                        controller.hideConversation(
                          conversation.conversationId,
                        );
                        Get.snackbar(
                          'Chat',
                          'Chat deleted successfully!',
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: MessageTile(
                        name: otherParticipant['name'] ?? 'Unknown',
                        subtitle: conversation.taskTitle,
                        message: conversation.lastMessage,
                        time: controller.getTimeAgo(
                          conversation.lastMessageTime.toDate(),
                        ),
                        image:
                            otherParticipant['photo'] ??
                            'assets/images/user1.png',
                        unreadCount: unreadCount,
                        onTap: () {
                          // Delete old controller if exists
                          if (Get.isRegistered<ChatController>()) {
                            Get.delete<ChatController>();
                          }

                          // Navigate to chat screen
                          Get.put(
                            ChatController(
                              taskId: conversation.taskId,
                              taskTitle: conversation.taskTitle,
                              taskOwnerId: otherParticipant['uid'],
                              taskOwnerName: otherParticipant['name'],
                              taskOwnerPhoto: otherParticipant['photo'],
                              taskImage: conversation.taskImage,
                            ),
                          );
                          Get.to(() => const ChatScreen());
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
