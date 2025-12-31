import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:red_balloon_app/model/conversation_model.dart';
import 'package:red_balloon_app/model/message_model.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'dart:io';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseFirestore get firestore => _firestore;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get or create conversation for a task between two users
  Future<String?> getOrCreateConversation({
    required String taskId,
    required String taskTitle,
    required String otherUserId,
    required String otherUserName,
    String? otherUserPhoto,
    String? taskImage,
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
          taskImage: taskImage,
          participant1Uid: sortedUids[0],
          participant2Uid: sortedUids[1],
          participants: sortedUids,
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

  /// Upload image to Firebase Storage for chat
  Future<String?> uploadChatImage(File imageFile, String conversationId) async {
    try {
      final senderId = currentUserId;
      if (senderId == null) return null;

      final fileName = 'chat_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('chats/$conversationId/$fileName');

      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading chat image: $e');
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

      // Update conversation's last message and remove both participants from hiddenBy
      // so the chat reappears if it was hidden by either
      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': imageUrl != null ? '📷 Image' : message,
        'lastMessageTime': newMessage.timestamp,
        'unreadCount.$receiverId': FieldValue.increment(1),
        'hiddenBy': FieldValue.arrayRemove([senderId, receiverId]), // 🔥 Re-show for both
      });

      // 🔥 Send push notification to receiver
      _sendNotification(
        conversationId,
        senderId,
        receiverId,
        imageUrl != null ? '📷 Image' : message,
      );

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  /// Helper to send chat notification
  Future<void> _sendNotification(
    String conversationId,
    String senderId,
    String receiverId,
    String message,
  ) async {
    try {
      // 1) Fetch conversation to get task title and names
      final convDoc = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .get();

      if (!convDoc.exists) return;

      final data = convDoc.data();
      if (data == null) return;

      final taskTitle = data['taskTitle'] ?? 'Chat';
      final taskId = data['taskId'] ?? '';
      final taskImage = data['taskImage'];

      // Determine sender's name
      String senderName = 'Someone';
      String? senderPhoto;
      if (data['participant1Uid'] == senderId) {
        senderName = data['participant1Name'] ?? 'User';
        senderPhoto = data['participant1Photo'];
      } else {
        senderName = data['participant2Name'] ?? 'User';
        senderPhoto = data['participant2Photo'];
      }

      // 2) Trigger Notification Service
      await NotificationService.instance.notifyChatMessage(
        receiverId: receiverId,
        senderId: senderId,
        senderName: senderName,
        message: message,
        conversationId: conversationId,
        taskId: taskId,
        taskTitle: taskTitle,
        senderPhoto: senderPhoto,
        taskImage: taskImage,
      );
    } catch (e) {
      print('Error in chat service notification: $e');
    }
  }

  /// Stream messages for a conversation
  Stream<List<MessageModel>> streamMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
    });
  }

  /// Hide a conversation for the current user
  Future<void> hideConversation(String conversationId) async {
    try {
      final userId = currentUserId;
      if (userId == null) return;

      await _firestore.collection('conversations').doc(conversationId).update({
        'hiddenBy': FieldValue.arrayUnion([userId]),
      });
      print('✅ Conversation $conversationId hidden for user $userId');
    } catch (e) {
      print('Error hiding conversation: $e');
    }
  }

  /// Stream all conversations for current user
  Stream<List<ConversationModel>> streamUserConversations() {
    final userId = currentUserId;
    if (userId == null) {
      print('❌ ChatService: No user logged in, returning empty stream');
      return Stream.value([]);
    }

    print('📡 ChatService: Starting conversation stream for $userId');
    
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      print('📥 ChatService: Received ${snapshot.docs.length} conversation documents for $userId');
      final list = snapshot.docs
          .map((doc) => ConversationModel.fromJson(doc.data()))
          .where((conv) => !conv.hiddenBy.contains(userId))
          .toList();
      
      // Sort by last message time descending
      list.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      
      print('📥 ChatService: Emitting ${list.length} non-hidden conversations for $userId');
      return list;
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
