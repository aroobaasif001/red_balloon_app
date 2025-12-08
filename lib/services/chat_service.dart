import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/model/conversation_model.dart';
import 'package:red_balloon_app/model/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get or create conversation for a task between two users
  Future<String?> getOrCreateConversation({
    required String taskId,
    required String taskTitle,
    required String otherUserId,
    required String otherUserName,
    String? otherUserPhoto,
  }) async {
    try {
      final currentUid = currentUserId;
      if (currentUid == null) return null;

      // Create a consistent conversation ID based on task and users
      // Sort UIDs to ensure same conversation regardless of who initiates
      final List<String> sortedUids = [currentUid, otherUserId]..sort();
      final conversationId = '${taskId}_${sortedUids[0]}_${sortedUids[1]}';

      print('🔍 Getting/Creating conversation:');
      print('   TaskID: $taskId');
      print('   Current User: $currentUid');
      print('   Other User: $otherUserId');
      print('   ConversationID: $conversationId');

      final conversationRef =
          _firestore.collection('conversations').doc(conversationId);
      final conversationDoc = await conversationRef.get();

      print('   Conversation exists: ${conversationDoc.exists}');

      if (!conversationDoc.exists) {
        print('   ✨ Creating new conversation...');
        
        // Get current user's info
        final currentUserDoc =
            await _firestore.collection('users').doc(currentUid).get();
        final currentUserName =
            currentUserDoc.data()?['displayName'] ?? 'Unknown';
        final currentUserPhoto = currentUserDoc.data()?['photoURL'];

        // Create new conversation
        final conversation = ConversationModel(
          conversationId: conversationId,
          taskId: taskId,
          taskTitle: taskTitle,
          participant1Uid: sortedUids[0],
          participant2Uid: sortedUids[1],
          participant1Name: sortedUids[0] == currentUid
              ? currentUserName
              : otherUserName,
          participant2Name: sortedUids[0] == currentUid
              ? otherUserName
              : currentUserName,
          participant1Photo: sortedUids[0] == currentUid
              ? currentUserPhoto
              : otherUserPhoto,
          participant2Photo: sortedUids[0] == currentUid
              ? otherUserPhoto
              : currentUserPhoto,
          lastMessage: 'Start chatting...',
          lastMessageTime: Timestamp.now(),
          unreadCount: {currentUid: 0, otherUserId: 0},
        );

        await conversationRef.set(conversation.toJson());
        print('   ✅ New conversation created!');
      } else {
        print('   ✅ Loading existing conversation!');
      }

      return conversationId;
    } catch (e) {
      print('❌ Error creating conversation: $e');
      return null;
    }
  }

  /// Send a message in a conversation
  Future<bool> sendMessage({
    required String conversationId,
    required String receiverId,
    required String message,
    String? imageUrl,
  }) async {
    try {
      final senderId = currentUserId;
      if (senderId == null) return false;

      final messageId = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc()
          .id;

      final newMessage = MessageModel(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: Timestamp.now(),
        imageUrl: imageUrl,
        isRead: false,
      );

      // Add message to subcollection
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toJson());

      // Update conversation's last message
      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': message,
        'lastMessageTime': newMessage.timestamp,
        'unreadCount.$receiverId': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  /// Stream messages for a conversation
  Stream<List<MessageModel>> streamMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
    });
  }

  /// Stream all conversations for current user
  Stream<List<ConversationModel>> streamUserConversations() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('conversations')
        .where('participant1Uid', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot1) async {
      // Also get conversations where user is participant2
      final snapshot2 = await _firestore
          .collection('conversations')
          .where('participant2Uid', isEqualTo: userId)
          .get();

      // Combine both results
      final allDocs = [...snapshot1.docs, ...snapshot2.docs];

      // Convert to models and sort by last message time
      final conversations = allDocs
          .map((doc) => ConversationModel.fromJson(doc.data()))
          .toList();

      conversations
          .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

      return conversations;
    });
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      final userId = currentUserId;
      if (userId == null) return;

      // Reset unread count for current user
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount.$userId': 0,
      });

      // Mark all unread messages as read
      final unreadMessages = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  /// Search conversations by task title or participant name
  List<ConversationModel> searchConversations(
    List<ConversationModel> conversations,
    String query,
  ) {
    if (query.isEmpty) return conversations;

    final lowerQuery = query.toLowerCase();
    return conversations.where((conversation) {
      final taskTitle = conversation.taskTitle.toLowerCase();
      final participant1 = conversation.participant1Name.toLowerCase();
      final participant2 = conversation.participant2Name.toLowerCase();

      return taskTitle.contains(lowerQuery) ||
          participant1.contains(lowerQuery) ||
          participant2.contains(lowerQuery);
    }).toList();
  }
}
