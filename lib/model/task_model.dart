import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String uid;
  final String? userId; // User's custom ID (RB-XXXXX)
  final String taskType;
  final String title;
  final String description;
  final double budget;
  final String? location;
  final String? imageUrl;
  final DateTime createdAt;
  final String status;
  final String? acceptedOfferUid;
  final String? requesterHelpReason;
  final String? requesterHelpDetails;
  final bool? requesterHelpRequested;
  final String? helperHelpReason;
  final String? helperHelpDetails;
  final bool? helperHelpRequested;
  final String? disputedStartTime;
  final double? latitude;
  final double? longitude;
  final DateTime? completedAt;

  TaskModel({
    this.id,
    required this.uid,
    this.userId,
    required this.taskType,
    required this.title,
    required this.description,
    required this.budget,
    this.location,
    this.imageUrl,
    required this.createdAt,
    this.status = 'active',
    this.acceptedOfferUid,
    this.requesterHelpReason,
    this.requesterHelpDetails,
    this.requesterHelpRequested,
    this.helperHelpReason,
    this.helperHelpDetails,
    this.helperHelpRequested,
    this.disputedStartTime,
    this.latitude,
    this.longitude,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'taskType': taskType,
      'title': title,
      'description': description,
      'budget': budget,
      'location': location,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'acceptedOfferUid': acceptedOfferUid,
      'requesterHelpReason': requesterHelpReason,
      'requesterHelpDetails': requesterHelpDetails,
      'requesterHelpRequested': requesterHelpRequested,
      'helperHelpReason': helperHelpReason,
      'helperHelpDetails': helperHelpDetails,
      'helperHelpRequested': helperHelpRequested,
      'disputedStartTime': disputedStartTime,
      'latitude': latitude,
      'longitude': longitude,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    DateTime? parseOptionalDate(dynamic date) {
      if (date == null) return null;
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date);
      return null;
    }

    return TaskModel(
      id: docId,
      uid: json['uid'] ?? '',
      userId: json['userId'],
      taskType: json['taskType'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      budget: (json['budget'] ?? 0).toDouble(),
      location: json['location'],
      imageUrl: json['imageUrl'],
      createdAt: parseDate(json['createdAt']),
      status: json['status'] ?? 'active',
      acceptedOfferUid: json['acceptedOfferUid'],
      requesterHelpReason: json['requesterHelpReason'],
      requesterHelpDetails: json['requesterHelpDetails'],
      requesterHelpRequested: json['requesterHelpRequested'],
      helperHelpReason: json['helperHelpReason'],
      helperHelpDetails: json['helperHelpDetails'],
      helperHelpRequested: json['helperHelpRequested'],
      disputedStartTime: json['disputedStartTime'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      completedAt: parseOptionalDate(json['completedAt']),
    );
  }

  factory TaskModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    DateTime? parseOptionalDate(dynamic date) {
      if (date == null) return null;
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date);
      return null;
    }

    return TaskModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      userId: data['userId'],
      taskType: data['taskType'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      budget: (data['budget'] ?? 0).toDouble(),
      location: data['location'],
      imageUrl: data['imageUrl'],
      createdAt: parseDate(data['createdAt']),
      status: data['status'] ?? 'active',
      acceptedOfferUid: data['acceptedOfferUid'],
      requesterHelpReason: data['requesterHelpReason'],
      requesterHelpDetails: data['requesterHelpDetails'],
      requesterHelpRequested: data['requesterHelpRequested'],
      helperHelpReason: data['helperHelpReason'],
      helperHelpDetails: data['helperHelpDetails'],
      helperHelpRequested: data['helperHelpRequested'],
      disputedStartTime: data['disputedStartTime'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      completedAt: parseOptionalDate(data['completedAt']),
    );
  }
}
