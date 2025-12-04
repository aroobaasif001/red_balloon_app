class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? phoneNumber;
  final String? photoURL;
  final String? city;
  final String? country;
  final String? workExperience;
  final String? provider;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.phoneNumber,
    this.photoURL,
    this.city,
    this.country,
    this.workExperience,
    this.provider,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '', 
      phoneNumber: json['phoneNumber'],
      photoURL: json['photoURL'],
      city: json['city'],
      country: json['country'],
      workExperience: json['workExperience'],
      provider: json['provider'],
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is String
              ? DateTime.parse(json['updatedAt'])
              : (json['updatedAt'] as dynamic).toDate())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'city': city,
      'country': country,
      'workExperience': workExperience,
      'provider': provider,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Get first letter for avatar
  String get initials {
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }
}
