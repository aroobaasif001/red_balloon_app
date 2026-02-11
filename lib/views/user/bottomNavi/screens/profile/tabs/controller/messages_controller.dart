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
  final RxMap<String, bool> userSuspensionStatus = <String, bool>{}.obs; // 🔥 Track suspension status

  StreamSubscription? _conversationsSubscription;
  final Map<String, StreamSubscription> _suspensionSubscriptions = {}; // 🔥 Track real-time listeners

  @override
  void onInit() {
    super.onInit();
    print('🚀 MessagesController: onInit - Starting stream');
    
    // 🔥 Worker to recalculate unread count whenever conversations list is modified
    ever(conversations, (_) {
      print('🔄 MessagesController: Conversations changed, recalculating...');
      _calculateTotalUnread();
    });
    
    _streamConversations();
  }

  @override
  void onClose() {
    print('🛑 MessagesController: onClose - Disposing controller');
    _conversationsSubscription?.cancel();
    for (var sub in _suspensionSubscriptions.values) {
      sub.cancel();
    }
    _suspensionSubscriptions.clear();
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
        // 🔥 Using assignAll to ensure RxList notifies its observers correctly
        conversations.assignAll(conversationsList);
        
        _listenToSuspensionStatuses(conversationsList);
        _applySearchFilter();
        isLoading.value = false;
      },
      onError: (error) {
        print('❌ MessagesController: Error streaming conversations: $error');
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
    final nonEmptyConversations = conversations.toList();

    if (searchQuery.value.isEmpty) {
      filteredConversations.assignAll(nonEmptyConversations);
    } else {
      final results = chatService.searchConversations(
        nonEmptyConversations.obs, 
        searchQuery.value,
      );
      filteredConversations.assignAll(results);
    }
  }

  void _calculateTotalUnread() {
    final uid = chatService.currentUserId;
    if (uid == null) {
      print('⚠️ MessagesController: No UID found while calculating unread count');
      totalUnreadCount.value = 0;
      return;
    }

    int total = 0;
    int unreadConvCount = 0;

    for (var conversation in conversations) {
      final unread = conversation.getUnreadCountForUser(uid);
      if (unread > 0) {
        unreadConvCount++;
      }
      total += unread;
    }

    if (total != totalUnreadCount.value) {
      print('📊 MessagesController: Total Unread Count Updating: ${totalUnreadCount.value} -> $total');
      totalUnreadCount.value = total;
    } else {
      print('📊 MessagesController: Total Unread Count remains: $total');
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

  /// 🔥 Listen to suspension status for all "other" participants in real-time
  void _listenToSuspensionStatuses(List<ConversationModel> list) {
    final currentUid = chatService.currentUserId;
    if (currentUid == null) return;

    for (var conversation in list) {
      final otherParticipant = conversation.getOtherParticipant(currentUid);
      final otherUid = otherParticipant['uid'];

      if (otherUid != null && !_suspensionSubscriptions.containsKey(otherUid)) {
        print('📡 MessagesController: Starting suspension listener for $otherUid');
        
        _suspensionSubscriptions[otherUid] = chatService.firestore
            .collection('users')
            .doc(otherUid)
            .snapshots()
            .listen((doc) {
          if (doc.exists) {
            final isSuspended = doc.data()?['willLogin'] == false;
            userSuspensionStatus[otherUid] = isSuspended;
            print('🔄 MessagesController: Real-time update for $otherUid: Suspended=$isSuspended');
          }
        });
      }
    }
  }

  /// 🔥 Public getter for suspension status
  bool isUserSuspended(String uid) {
    return userSuspensionStatus[uid] ?? false;
  }
}
