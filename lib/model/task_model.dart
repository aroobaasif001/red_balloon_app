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
  final String? acceptedOfferUid; // 🔥 Track which user's offer was accepted

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
    this.acceptedOfferUid, // 🔥 Optional field
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
      'acceptedOfferUid': acceptedOfferUid, // 🔥 Include in JSON
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json, String docId) {
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
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      status: json['status'] ?? 'active',
      acceptedOfferUid: json['acceptedOfferUid'], // 🔥 Parse from JSON
    );
  }

  factory TaskModel.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Handle createdAt - can be either String or Timestamp
    DateTime createdAtValue = DateTime.now();
    if (data['createdAt'] != null) {
      if (data['createdAt'] is String) {
        // Parse ISO 8601 string
        try {
          createdAtValue = DateTime.parse(data['createdAt']);
        } catch (e) {
          print('Error parsing createdAt string: $e');
          createdAtValue = DateTime.now();
        }
      } else {
        // Firestore Timestamp
        try {
          createdAtValue = (data['createdAt'] as dynamic).toDate();
        } catch (e) {
          print('Error converting createdAt timestamp: $e');
          createdAtValue = DateTime.now();
        }
      }
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
      createdAt: createdAtValue,
      status: data['status'] ?? 'active',
      acceptedOfferUid: data['acceptedOfferUid'],
    );
  }
}
