import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_balloon_app/model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get usersCollection => _firestore.collection('users');

  /// Get user by UID
  Future<UserModel?> getUserByUid(String uid) async {
    try {
      print('🔍 UserService: Fetching user with UID: $uid');
      
      final doc = await usersCollection.doc(uid).get();

      if (!doc.exists) {
        print('❌ UserService: User not found');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      print('✅ UserService: User found - ${data['displayName']}');
      
      return UserModel.fromJson(data);
    } catch (e) {
      print('❌ UserService Error getting user: $e');
      return null;
    }
  }

  /// Get user statistics (tasks completed, requested, rating)
  Future<Map<String, dynamic>> getUserStatistics(String uid) async {
    try {
      print('🔍 UserService: Fetching statistics for user: $uid');
      
      // Get tasks completed by this user (as helper)
      final offersSnapshot = await _firestore
          .collection('offers')
          .where('offeringUserUid', isEqualTo: uid)
          .where('status', isEqualTo: 'accepted')
          .get();
      
      final tasksCompleted = offersSnapshot.docs.length;

      // Get tasks requested by this user (as task owner)
      final tasksSnapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();
      
      final tasksRequested = tasksSnapshot.docs.length;

     // TODO: Implement actual rating calculation from reviews
      final rating = 4.9; // Placeholder
      final totalReviews = 234; // Placeholder

      print('✅ UserService: Stats - Completed: $tasksCompleted, Requested: $tasksRequested');

      return {
        'tasksCompleted': tasksCompleted,
        'tasksRequested': tasksRequested,
        'rating': rating,
        'totalReviews': totalReviews,
      };
    } catch (e) {
      print('❌ UserService Error getting statistics: $e');
      return {
        'tasksCompleted': 0,
        'tasksRequested': 0,
        'rating': 0.0,
        'totalReviews': 0,
      };
    }
  }
}
