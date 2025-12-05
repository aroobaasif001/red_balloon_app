import 'package:cloud_firestore/cloud_firestore.dart';

class TaskProofModel {
  final String? id;
  final String taskId;
  final String userId;
  final String username;
  final String? userPhotoUrl;
  final String? beforePhotoUrl;
  final String? afterPhotoUrl;
  final String? note;
  final DateTime submittedAt;
  final String taskTitle;
  final String taskPrice;

  TaskProofModel({
    this.id,
    required this.taskId,
    required this.userId,
    required this.username,
    this.userPhotoUrl,
    this.beforePhotoUrl,
    this.afterPhotoUrl,
    this.note,
    required this.submittedAt,
    required this.taskTitle,
    required this.taskPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'beforePhotoUrl': beforePhotoUrl,
      'afterPhotoUrl': afterPhotoUrl,
      'note': note,
      'submittedAt': submittedAt.toIso8601String(),
      'taskTitle': taskTitle,
      'taskPrice': taskPrice,
    };
  }

  factory TaskProofModel.fromJson(Map<String, dynamic> json, String docId) {
    return TaskProofModel(
      id: docId,
      taskId: json['taskId'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      userPhotoUrl: json['userPhotoUrl'],
      beforePhotoUrl: json['beforePhotoUrl'],
      afterPhotoUrl: json['afterPhotoUrl'],
      note: json['note'],
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : DateTime.now(),
      taskTitle: json['taskTitle'] ?? '',
      taskPrice: json['taskPrice'] ?? '',
    );
  }
}
