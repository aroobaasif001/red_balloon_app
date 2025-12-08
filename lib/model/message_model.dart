import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String? imageUrl;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.imageUrl,
    this.isRead = false,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'isRead': isRead,
    };
  }

  // Create from Firestore document
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? Timestamp.now(),
      imageUrl: json['imageUrl'],
      isRead: json['isRead'] ?? false,
    );
  }

  // Copy with method for updates
  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? message,
    Timestamp? timestamp,
    String? imageUrl,
    bool? isRead,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
    );
  }
}
