import 'dart:async';

import 'package:get/get.dart';
import 'package:red_balloon_app/model/conversation_model.dart';
import 'package:red_balloon_app/services/chat_service.dart';

class MessagesController extends GetxController {
  final ChatService chatService = ChatService();

  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;
  final RxList<ConversationModel> filteredConversations =
      <ConversationModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxInt totalUnreadCount = 0.obs;

  StreamSubscription? _conversationsSubscription;

  @override
  void onInit() {
    super.onInit();
    print('🚀 MessagesController: onInit - Starting stream');
    _streamConversations();
  }

  @override
  void onClose() {
    print('🛑 MessagesController: onClose - Disposing controller');
    _conversationsSubscription?.cancel();
    super.onClose();
  }

  /// Stream user's conversations
  void _streamConversations() {
    _conversationsSubscription?.cancel();
    print('📬 MessagesController: Starting stream listener...');

    _conversationsSubscription = chatService.streamUserConversations().listen(
      (conversationsList) {
        print(
          '📬 MessagesController: Stream data received. List size: ${conversationsList.length}',
        );
        conversations.value = conversationsList;
        _applySearchFilter();
        _calculateTotalUnread();
        isLoading.value = false;
      },
      onError: (error) {
        print('Error streaming conversations: $error');
        isLoading.value = false;
      },
    );
  }

  /// Update search query and filter
  void updateSearch(String query) {
    searchQuery.value = query;
    _applySearchFilter();
  }

  /// Apply search filter to conversations
  void _applySearchFilter() {
    // 🔥 Filter out empty conversations (no messages)
    final nonEmptyConversations = conversations.where((c) => c.lastMessage.trim().isNotEmpty).toList();

    if (searchQuery.value.isEmpty) {
      filteredConversations.assignAll(nonEmptyConversations);
    } else {
      final results = chatService.searchConversations(
        nonEmptyConversations.obs, // Pass the already filtered list
        searchQuery.value,
      );
      filteredConversations.assignAll(results);
    }
  }

  void _calculateTotalUnread() {
    final uid = chatService.currentUserId;
    if (uid == null) {
      print(
        '⚠️ MessagesController: No UID found while calculating unread count',
      );
      totalUnreadCount.value = 0;
      return;
    }

    int total = 0;
    int unreadConvCount = 0;

    for (var conversation in conversations) {
      final unread = conversation.getUnreadCountForUser(uid);
      if (unread > 0) {
        unreadConvCount++;
        print(
          '💬 MessagesController: Conversation ${conversation.conversationId} has $unread unread messages for user $uid',
        );
      }
      total += unread;
    }

    if (total != totalUnreadCount.value) {
      totalUnreadCount.value = total;
      print(
        '📊 MessagesController: Total Unread Count Updated -> $total (across $unreadConvCount conversations)',
      );
    }
  }

  /// Get time ago string from timestamp
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  /// Hide conversation
  Future<void> hideConversation(String conversationId) async {
    // 🔥 Optimistic UI update: Remove from local lists immediately
    conversations.removeWhere((c) => c.conversationId == conversationId);
    filteredConversations.removeWhere(
      (c) => c.conversationId == conversationId,
    );

    // Update backend
    await chatService.hideConversation(conversationId);
  }

  /// Mark all conversations as read
  Future<void> markAllAsRead() async {
    final uid = chatService.currentUserId;
    if (uid == null) return;

    final batch = chatService.firestore.batch();
    bool hasUpdates = false;

    for (var conversation in conversations) {
      if (conversation.getUnreadCountForUser(uid) > 0) {
        final docRef = chatService.firestore
            .collection('conversations')
            .doc(conversation.conversationId);
        batch.update(docRef, {'unreadCount.$uid': 0});
        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      await batch.commit();
    }
  }
}
