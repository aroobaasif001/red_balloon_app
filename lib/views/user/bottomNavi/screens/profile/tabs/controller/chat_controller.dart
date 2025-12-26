import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:red_balloon_app/model/message_model.dart';
import 'package:red_balloon_app/services/chat_service.dart';

class ChatController extends GetxController {
  final String taskId;
  final String taskTitle;
  final String taskOwnerId;
  final String taskOwnerName;
  final String? taskOwnerPhoto;
  final RxnString taskImage = RxnString();
  final RxString taskStatus = 'Active'.obs;
  final RxBool isOtherUserSuspended = false.obs; // 🔥 Added

  final ChatService _chatService = ChatService();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isUploading = false.obs; // 🔥 Added for attachment loading
  final RxString conversationId = ''.obs;
  StreamSubscription? _taskSubscription;
  StreamSubscription? _suspensionSubscription; // 🔥 Added

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
    _listenToTaskStatus();
    _listenToOtherUserSuspension(); // 🔥 Renamed and switched to listener
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
          if (data != null) {
            if (data['imageUrl'] != null) {
              taskImage.value = data['imageUrl'];
              print('✅ Fetched missing task image: ${taskImage.value}');
            }
            if (data['status'] != null) {
              taskStatus.value = _capitalize(data['status'].toString());
              print('✅ Fetched task status: ${taskStatus.value}');
            }
          }
        }
      } catch (e) {
        print('Error fetching task details: $e');
      }
    }
  }

  /// Listen to real-time status updates for the task
  void _listenToTaskStatus() {
    _taskSubscription = FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            final data = doc.data();
            if (data != null && data['status'] != null) {
              taskStatus.value = _capitalize(data['status'].toString());
            }
          }
        });
  }

  /// 🔥 Listen to real-time suspension status
  void _listenToOtherUserSuspension() {
    _suspensionSubscription?.cancel();
    _suspensionSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(taskOwnerId)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final data = doc.data();
        isOtherUserSuspended.value = data?['willLogin'] == false;
        print('🔄 Real-time suspension update for $taskOwnerId: ${isOtherUserSuspended.value}');
      }
    }, onError: (e) => print('Error listening to suspension: $e'));
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
    _chatService
        .streamMessages(conversationId.value)
        .listen(
          (messagesList) {
            messages.value = messagesList;
            isLoading.value = false;

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
    if (isOtherUserSuspended.value) {
      Get.snackbar('Action Blocked', 'You cannot message a suspended user.');
      return;
    }
    final messageText = messageController.text.trim();
    if (messageText.isEmpty) return;

    final success = await _chatService.sendMessage(
      conversationId: conversationId.value,
      receiverId: taskOwnerId,
      message: messageText,
    );

    if (success) {
      messageController.clear();
    }
  }

  /// Pick and send an image attachment
  Future<void> pickAndSendImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024, // Optimized for mobile viewing
        imageQuality: 70, // Good balance between speed and visibility
      );

      if (image == null) return;

      isUploading.value = true;
      final file = File(image.path);

      // 1) Upload image to storage
      final imageUrl = await _chatService.uploadChatImage(
        file,
        conversationId.value,
      );

      if (imageUrl != null) {
        // 2) Send message with imageUrl
        await _chatService.sendMessage(
          conversationId: conversationId.value,
          receiverId: taskOwnerId,
          message: '[Image]',
          imageUrl: imageUrl,
        );
      } else {
        Get.snackbar('Error', 'Failed to upload image');
      }
    } catch (e) {
      print('Error sending attachment: $e');
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isUploading.value = false;
    }
  }

  /// Mark messages as read when viewing
  Future<void> _markMessagesAsRead() async {
    await _chatService.markMessagesAsRead(conversationId.value);
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

  /// Format date for chat dividers (Today, Yesterday, Date)
  String getGroupDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (msgDate == today) {
      return 'Today';
    } else if (msgDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

  /// Check if two message timestamps are on the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void onClose() {
    _markMessagesAsRead(); // 🔥 Final mark as read when leaving
    _taskSubscription?.cancel();
    _suspensionSubscription?.cancel(); // 🔥 Added
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
