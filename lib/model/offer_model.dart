class OfferModel {
  final String? id;
  final String offerId;
  final String offerPrice;
  final String offeringUserName;
  final String? offeringUserPhoto;
  final String offeringUserUid;
  final String status;
  final DateTime createdAt;
  
  // Task details (nested in the offer)
  final String taskId;
  final String taskTitle;
  final String? taskImage;
  final String taskType;
  final String taskDescription;
  final double taskBudget;
  final String taskOwnerName;
  final String? taskOwnerPhoto;
  final String taskOwnerUid;
  final String timeAgo;

  OfferModel({
    this.id,
    required this.offerId,
    required this.offerPrice,
    required this.offeringUserName,
    this.offeringUserPhoto,
    required this.offeringUserUid,
    required this.status,
    required this.createdAt,
    required this.taskId,
    required this.taskTitle,
    this.taskImage,
    required this.taskType,
    required this.taskDescription,
    required this.taskBudget,
    required this.taskOwnerName,
    this.taskOwnerPhoto,
    required this.taskOwnerUid,
    required this.timeAgo,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json, String docId) {
    final taskDetails = json['taskDetails'] as Map<String, dynamic>? ?? {};
    
    // Handle createdAt - could be Timestamp or String
    DateTime parsedCreatedAt;
    try {
      if (json['createdAt'] is String) {
        parsedCreatedAt = DateTime.parse(json['createdAt']);
      } else if (json['createdAt'] != null) {
        // Firestore Timestamp
        parsedCreatedAt = (json['createdAt'] as dynamic).toDate();
      } else {
        parsedCreatedAt = DateTime.now();
      }
    } catch (e) {
      print('⚠️ Error parsing createdAt: $e');
      parsedCreatedAt = DateTime.now();
    }
    
    return OfferModel(
      id: docId,
      offerId: json['offerId'] ?? '',
      offerPrice: json['offerPrice']?.toString() ?? '0',
      offeringUserName: json['offeringUserName'] ?? '',
      offeringUserPhoto: json['offeringUserPhoto'],
      offeringUserUid: json['offeringUserUid'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: parsedCreatedAt,
      taskId: json['taskId'] ?? taskDetails['taskId'] ?? '', // 🔥 Check root first
      taskTitle: taskDetails['title'] ?? '',
      taskImage: taskDetails['image'],
      taskType: taskDetails['taskType'] ?? '',
      taskDescription: taskDetails['description'] ?? '',
      taskBudget: (taskDetails['budget'] ?? 0).toDouble(),
      taskOwnerName: taskDetails['taskOwnerName'] ?? '',
      taskOwnerPhoto: taskDetails['taskOwnerPhoto'],
      taskOwnerUid: taskDetails['taskOwnerUid'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'offerPrice': offerPrice,
      'offeringUserName': offeringUserName,
      'offeringUserPhoto': offeringUserPhoto,
      'offeringUserUid': offeringUserUid,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'taskDetails': {
        'taskId': taskId,
        'title': taskTitle,
        'image': taskImage,
        'taskType': taskType,
        'description': taskDescription,
        'budget': taskBudget,
        'taskOwnerName': taskOwnerName,
        'taskOwnerPhoto': taskOwnerPhoto,
        'taskOwnerUid': taskOwnerUid,
      },
      'timeAgo': timeAgo,
    };
  }
}
