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
      final completedSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();
      
      final tasksCompleted = completedSnapshot.docs.length;

      // Get tasks requested by this user (as task owner)
      final tasksSnapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();
      
      final tasksRequested = tasksSnapshot.docs.length;

      double sum = 0;
      int count = 0;

      // 1. Fetch ratings where user was a Helper (Requester left feedback)
      final helperTasks = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();

      for (var doc in helperTasks.docs) {
        final data = doc.data();
        if (data['requesterFeedback'] != null) {
          sum += (data['requesterFeedback']['rating'] ?? 0).toDouble();
          count++;
        }
      }

      // 2. Fetch ratings where user was a Requester (Helper left feedback)
      final requesterTasks = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();

      for (var doc in requesterTasks.docs) {
        final data = doc.data();
        if (data['helperFeedback'] != null) {
          sum += (data['helperFeedback']['rating'] ?? 0).toDouble();
          count++;
        }
      }

      final rating = count > 0 ? (sum / count) : 0.0;
      final totalReviews = count;

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

  /// Get all users from Firestore
  Future<List<UserModel>> getAllUsers() async {
    try {
      print('🔍 UserService: Fetching all users...');
      
      final snapshot = await usersCollection.get();
      
      print('📊 UserService: Found ${snapshot.docs.length} users');
      
      final List<UserModel> users = [];
      
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          data['uid'] = doc.id; // Ensure uid is set
          
          final user = UserModel.fromJson(data);
          users.add(user);
        } catch (e) {
          print('❌ UserService: Error parsing user ${doc.id}: $e');
        }
      }
      
      print('✅ UserService: Loaded ${users.length} users');
      return users;
    } catch (e) {
      print('❌ UserService Error getting all users: $e');
      return [];
    }
  }

  /// Get user task statistics (tasks posted, completed, earnings)
  Future<Map<String, dynamic>> getUserTaskStats(String uid) async {
    try {
      // Count tasks posted by user
      final tasksPosted = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();
      
      // Count tasks completed by user (as helper)
      final tasksCompleted = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'Completed')
          .get();
      
      // Calculate total earnings
      int totalEarnings = 0;
      for (var task in tasksCompleted.docs) {
        totalEarnings += (task.data()['budget'] ?? 0) as int;
      }
      
      return {
        'tasksPosted': tasksPosted.docs.length,
        'tasksCompleted': tasksCompleted.docs.length,
        'totalEarnings': totalEarnings,
      };
    } catch (e) {
      print('❌ UserService Error getting task stats: $e');
      return {
        'tasksPosted': 0,
        'tasksCompleted': 0,
        'totalEarnings': 0,
      };
    }
  }
}
