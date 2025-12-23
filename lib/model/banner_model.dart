import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final String cta;
  final bool isActive;
  final DateTime createdAt;
  final int index;

  BannerModel({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.cta = '',
    this.isActive = true,
    required this.createdAt,
    this.index = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'cta': cta,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'index': index,
    };
  }

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BannerModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      cta: data['cta'] ?? '',
      isActive: data['isActive'] ?? true,
      index: data['index'] ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is String 
              ? DateTime.parse(data['createdAt']) 
              : (data['createdAt'] as Timestamp).toDate())
          : DateTime.now(),
    );
  }

  BannerModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? cta,
    bool? isActive,
    DateTime? createdAt,
    int? index,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cta: cta ?? this.cta,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      index: index ?? this.index,
    );
  }
}
