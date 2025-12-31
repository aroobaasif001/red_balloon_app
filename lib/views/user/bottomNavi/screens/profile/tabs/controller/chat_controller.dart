import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:red_balloon_app/model/message_model.dart';
import 'package:red_balloon_app/services/chat_service.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

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
  
  // 🔥 Static variable to track the open conversation across the app
  static final RxnString activeConversationId = RxnString();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isUploading = false.obs; // 🔥 Added for attachment loading
  final RxString conversationId = ''.obs;
  StreamSubscription? _taskSubscription;
  StreamSubscription? _suspensionSubscription;
  StreamSubscription? _messagesSubscription; // 🔥 Track message stream

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
        // 🔥 Set as active conversation to suppress push notifications for this chat
        activeConversationId.value = convId;
        print('   ✅ ConversationID set: $convId (Active)');
        _streamMessages();
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
    _messagesSubscription?.cancel();
    _messagesSubscription = _chatService
        .streamMessages(conversationId.value)
        .listen(
          (messagesList) {
            messages.value = messagesList;
            isLoading.value = false;

            // 🔥 Only mark as read if the messagesList actually has unread messages for US
            final hasUnread = messagesList.any(
              (m) => m.receiverId == _chatService.currentUserId && !m.isRead,
            );
            if (hasUnread) {
              print('📖 ChatController: New unread messages detected while chat is open, marking as read');
              markMessagesAsRead();
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

  /// Show options for Camera/Gallery
  void showAttachmentOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            CustomText(
              "Select Image Source",
              fontSize: 18,
              fontWeight: FontVariant.bold,
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Icons.camera_alt_rounded,
                  label: "Camera",
                  onTap: () {
                    Get.back();
                    pickAndSendImage(ImageSource.camera);
                  },
                ),
                _buildOption(
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  onTap: () {
                    Get.back();
                    pickAndSendImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: redColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: redColor, size: 30),
          ),
          const SizedBox(height: 8),
          CustomText(
            label,
            fontSize: 14,
            fontWeight: FontVariant.semiBold,
          ),
        ],
      ),
    );
  }

  /// Pick and send an image attachment
  Future<void> pickAndSendImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
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
  Future<void> markMessagesAsRead() async {
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
    print('📱 ChatController: onClose - Cancelling all subscriptions');
    // 🔥 Clear active conversation ID
    if (activeConversationId.value == conversationId.value) {
      activeConversationId.value = null;
    }
    
    _taskSubscription?.cancel();
    _suspensionSubscription?.cancel();
    _messagesSubscription?.cancel(); // 🔥 CRITICAL: Cancel message stream
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
