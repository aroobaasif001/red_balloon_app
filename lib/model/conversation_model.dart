import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  final String conversationId;
  final String taskId;
  final String taskTitle;
  final String? taskImage;
  final String participant1Uid;
  final String participant2Uid;
  final String participant1Name;
  final String participant2Name;
  final String? participant1Photo;
  final String? participant2Photo;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final Map<String, int> unreadCount;
  final List<String> hiddenBy; // 🔥 List of UIDs who have hidden/deleted this chat

  ConversationModel({
    required this.conversationId,
    required this.taskId,
    required this.taskTitle,
    this.taskImage,
    required this.participant1Uid,
    required this.participant2Uid,
    required this.participant1Name,
    required this.participant2Name,
    this.participant1Photo,
    this.participant2Photo,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.hiddenBy = const [],
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'taskId': taskId,
      'taskTitle': taskTitle,
      'taskImage': taskImage,
      'participant1Uid': participant1Uid,
      'participant2Uid': participant2Uid,
      'participant1Name': participant1Name,
      'participant2Name': participant2Name,
      'participant1Photo': participant1Photo,
      'participant2Photo': participant2Photo,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'hiddenBy': hiddenBy,
    };
  }

  // Create from Firestore document
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversationId'] ?? '',
      taskId: json['taskId'] ?? '',
      taskTitle: json['taskTitle'] ?? '',
      taskImage: json['taskImage'],
      participant1Uid: json['participant1Uid'] ?? '',
      participant2Uid: json['participant2Uid'] ?? '',
      participant1Name: json['participant1Name'] ?? '',
      participant2Name: json['participant2Name'] ?? '',
      participant1Photo: json['participant1Photo'],
      participant2Photo: json['participant2Photo'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] ?? Timestamp.now(),
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
      hiddenBy: List<String>.from(json['hiddenBy'] ?? []),
    );
  }

  // Get other participant's info
  Map<String, dynamic> getOtherParticipant(String currentUserId) {
    if (currentUserId == participant1Uid) {
      return {
        'uid': participant2Uid,
        'name': participant2Name,
        'photo': participant2Photo,
      };
    } else {
      return {
        'uid': participant1Uid,
        'name': participant1Name,
        'photo': participant1Photo,
      };
    }
  }

  // Get unread count for current user
  int getUnreadCountForUser(String userId) {
    return unreadCount[userId] ?? 0;
  }
}
