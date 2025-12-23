import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final String userUid;
  
  UserProfileController({required this.userUid});

  var feedbacks = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var averageRating = 0.0.obs;
  var totalReviews = 0.obs;
  var tasksCompleted = 0.obs;
  var tasksRequested = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    try {
      isLoading.value = true;
      List<Map<String, dynamic>> allFeedbacks = [];

      // 1. Fetch feedbacks where user was a Helper (Requester left feedback)
      final helperTasks = await FirebaseFirestore.instance
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: userUid)
          .where('status', isEqualTo: 'completed')
          .get();

      for (var doc in helperTasks.docs) {
        final data = doc.data();
        if (data['requesterFeedback'] != null) {
          final feedback = Map<String, dynamic>.from(data['requesterFeedback']);
          feedback['taskTitle'] = data['title'] ?? 'Task';
          feedback['role'] = 'Helper';
          
          // Fetch requester name for the feedback
          final requesterUid = data['uid'];
          feedback['reviewerName'] = await _getUserName(requesterUid);
          
          allFeedbacks.add(feedback);
        }
      }

      // 2. Fetch feedbacks where user was a Requester (Helper left feedback)
      final requesterTasks = await FirebaseFirestore.instance
          .collection('tasks')
          .where('uid', isEqualTo: userUid)
          .where('status', isEqualTo: 'completed')
          .get();

      for (var doc in requesterTasks.docs) {
        final data = doc.data();
        if (data['helperFeedback'] != null) {
          final feedback = Map<String, dynamic>.from(data['helperFeedback']);
          feedback['taskTitle'] = data['title'] ?? 'Task';
          feedback['role'] = 'Requester';
          
          // Fetch helper name for the feedback
          final helperUid = data['acceptedOfferUid'];
          feedback['reviewerName'] = await _getUserName(helperUid);
          
          allFeedbacks.add(feedback);
        }
      }

      // Sort by date newest first
      allFeedbacks.sort((a, b) {
        final dateA = _parseDate(a['createdAt']);
        final dateB = _parseDate(b['createdAt']);
        return dateB.compareTo(dateA);
      });

      feedbacks.value = allFeedbacks;
      totalReviews.value = allFeedbacks.length;

      if (allFeedbacks.isNotEmpty) {
        double sum = 0;
        for (var f in allFeedbacks) {
          sum += (f['rating'] ?? 0).toDouble();
        }
        averageRating.value = sum / allFeedbacks.length;
      }
      
      // 3. Fetch general stats (counts)
      // Tasks completed (as helper)
      tasksCompleted.value = helperTasks.docs.length;
      
      // Tasks requested (all tasks posted by this user)
      final allRequested = await FirebaseFirestore.instance
          .collection('tasks')
          .where('uid', isEqualTo: userUid)
          .get();
      tasksRequested.value = allRequested.docs.length;

    } catch (e) {
      print("Error fetching feedbacks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _getUserName(String? uid) async {
    if (uid == null || uid.isEmpty) return 'Unknown';
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        return userDoc.data()?['displayName'] ?? userDoc.data()?['name'] ?? 'User';
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
    return 'User';
  }

  DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
