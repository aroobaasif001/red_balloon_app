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

  @override
  void onInit() {
    super.onInit();
    _streamConversations();
  }

  /// Stream user's conversations
  void _streamConversations() {
    chatService.streamUserConversations().listen(
      (conversationsList) {
        conversations.value = conversationsList;
        _applySearchFilter();
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
    if (searchQuery.value.isEmpty) {
      filteredConversations.value = conversations;
    } else {
      filteredConversations.value = chatService.searchConversations(
        conversations,
        searchQuery.value,
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
}
