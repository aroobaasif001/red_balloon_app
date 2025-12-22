import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/message_model.dart';
import 'package:red_balloon_app/services/chat_service.dart';

class ChatController extends GetxController {
  final String taskId;
  final String taskTitle;
  final String taskOwnerId;
  final String taskOwnerName;
  final String? taskOwnerPhoto;
  final RxnString taskImage = RxnString();

  final ChatService _chatService = ChatService();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString conversationId = ''.obs;

  ChatController({
    required this.taskId,
    required this.taskTitle,
    required this.taskOwnerId,
    required this.taskOwnerName,
    this.taskOwnerPhoto,
    String? taskImage,
  }) {
    this.taskImage.value = taskImage;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeConversation();
    _fetchTaskDetailsIfNeeded();
  }

  /// Fetch task details if image is missing
  Future<void> _fetchTaskDetailsIfNeeded() async {
    if (taskImage.value == null || taskImage.value!.isEmpty) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskId)
            .get();
        
        if (doc.exists) {
          final data = doc.data();
          if (data != null && data['imageUrl'] != null) {
            taskImage.value = data['imageUrl'];
            print('✅ Fetched missing task image: ${taskImage.value}');
          }
        }
      } catch (e) {
        print('Error fetching task details: $e');
      }
    }
  }

  /// Initialize or get existing conversation
  Future<void> _initializeConversation() async {
    try {
      print('📱 ChatController Initializing:');
      print('   TaskID: $taskId');
      print('   TaskTitle: $taskTitle');
      print('   TaskOwnerId: $taskOwnerId');
      print('   TaskOwnerName: $taskOwnerName');
      
      final convId = await _chatService.getOrCreateConversation(
        taskId: taskId,
        taskTitle: taskTitle,
        otherUserId: taskOwnerId,
        otherUserName: taskOwnerName,
        otherUserPhoto: taskOwnerPhoto,
        taskImage: taskImage.value,
      );
      
      if (convId != null) {
        conversationId.value = convId;
        print('   ✅ ConversationID set: $convId');
        _streamMessages();
        _markMessagesAsRead();
      } else {
        print('   ❌ Failed to get conversationId');
      }
    } catch (e) {
      print('❌ Error initializing conversation: $e');
      isLoading.value = false;
    }
  }

  /// Stream messages in real-time
  void _streamMessages() {
    _chatService.streamMessages(conversationId.value).listen(
      (messagesList) {
        messages.value = messagesList;
        isLoading.value = false;
        _scrollToBottom();

        // 🔥 If there are new unread messages from other user while chat is open, mark them as read
        final hasUnread = messagesList.any(
          (m) => m.receiverId == _chatService.currentUserId && !m.isRead,
        );
        if (hasUnread) {
          _markMessagesAsRead();
        }
      },
      onError: (error) {
        print('Error streaming messages: $error');
        isLoading.value = false;
      },
    );
  }

  /// Send a new message
  Future<void> sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;

    final success = await _chatService.sendMessage(
      conversationId: conversationId.value,
      receiverId: taskOwnerId,
      message: messageText,
    );

    if (success) {
      messageController.clear();
      _scrollToBottom();
    }
  }

  /// Mark messages as read when viewing
  Future<void> _markMessagesAsRead() async {
    await _chatService.markMessagesAsRead(conversationId.value);
  }

  /// Auto-scroll to bottom
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Check if message is from current user
  bool isMyMessage(MessageModel message) {
    return message.senderId == _chatService.currentUserId;
  }

  /// Get time ago string
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void onClose() {
    _markMessagesAsRead(); // 🔥 Final mark as read when leaving
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
