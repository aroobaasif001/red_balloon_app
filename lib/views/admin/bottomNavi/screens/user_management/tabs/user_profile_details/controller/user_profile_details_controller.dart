import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserProfileDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Loading state
  var isLoading = true.obs;
  
  // User basic info
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userId = ''.obs; // Formatted ID like "RB-001"
  var userPhoto = ''.obs;
  var isVerified = false.obs;
  var city = ''.obs;
  
  // User Progress (percentages)
  var requesterProgress = 0.0.obs;
  var helperProgress = 0.0.obs;
  var validatorProgress = 0.0.obs;
  
  // Rating & Completion
  var rating = 0.0.obs;
  var tasksCompleted = 0.obs;
  
  // Stats
  var validationAccuracy = '0%'.obs;
  var responseTime = '0 min'.obs;
  var averageDistance = '0 km'.obs;
  var completionRate = '0%'.obs;
  var disputeRate = '0%'.obs;
  var violations = 0.obs;
  
  // Task Breakdown
  var totalTasks = 0.obs;
  var completedTasks = 0.obs;
  var cancelledByUser = 0.obs;
  var cancelledByHelper = 0.obs;
  var disputedTasks = 0.obs;
  
  // Wallet Overview
  var totalEarned = 0.0.obs;
  var currentBalance = 0.0.obs;
  var pendingWithdrawals = 0.0.obs;
  var penalties = 0.0.obs;
  
  String? _currentUserId;
  
  @override
  void onInit() {
    super.onInit();
    // Get userId from arguments
    _currentUserId = Get.arguments as String?;
    if (_currentUserId != null) {
      fetchUserProfileData(_currentUserId!);
    }
  }
  
  /// Fetch all user profile data
  Future<void> fetchUserProfileData(String uid) async {
    try {
      isLoading.value = true;
      
      // Fetch user document
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (!userDoc.exists) {
        print('❌ User not found: $uid');
        isLoading.value = false;
        return;
      }
      
      final userData = userDoc.data()!;
      
      // Basic Info
      userName.value = userData['displayName'] ?? userData['name'] ?? '';
      userEmail.value = userData['email'] ?? '';
      userId.value = userData['userId'] ?? '';
      userPhoto.value = userData['photoURL'] ?? userData['photoUrl'] ?? '';
      isVerified.value = userData['isVerified'] ?? false;
      city.value = userData['city'] ?? '';
      
      // Fetch all other data in parallel
      await Future.wait([
        _fetchUserProgress(uid),
        _fetchRatingAndCompletion(uid),
        _fetchStats(uid),
        _fetchTaskBreakdown(uid),
        _fetchWalletData(uid),
      ]);
      
      isLoading.value = false;
      print('✅ User profile data loaded successfully');
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      isLoading.value = false;
    }
  }
  
  /// Calculate user progress percentages
  Future<void> _fetchUserProgress(String uid) async {
    try {
      // Fetch all tasks
      final tasksSnapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();
      
      final helperTasksSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .get();
      
      final validationsSnapshot = await _firestore
          .collection('validations')
          .where('userId', isEqualTo: uid)
          .get();
      
      // Calculate percentages (example: based on count / 100)
      requesterProgress.value = (tasksSnapshot.docs.length / 100).clamp(0.0, 1.0);
      helperProgress.value = (helperTasksSnapshot.docs.length / 100).clamp(0.0, 1.0);
      validatorProgress.value = (validationsSnapshot.docs.length / 100).clamp(0.0, 1.0);
      
    } catch (e) {
      print('❌ Error fetching user progress: $e');
    }
  }
  
  /// Fetch rating and completed tasks
  Future<void> _fetchRatingAndCompletion(String uid) async {
    try {
      // Fetch completed tasks
      final completedSnapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();
      
      final helperCompletedSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();
      
      tasksCompleted.value = completedSnapshot.docs.length + helperCompletedSnapshot.docs.length;
      
      // Calculate average rating from feedbacks
      double totalRating = 0;
      int ratingCount = 0;
      
      for (var doc in completedSnapshot.docs) {
        final data = doc.data();
        if (data['helperFeedback'] != null && data['helperFeedback']['rating'] != null) {
          totalRating += (data['helperFeedback']['rating'] as num).toDouble();
          ratingCount++;
        }
      }
      
      for (var doc in helperCompletedSnapshot.docs) {
        final data = doc.data();
        if (data['requesterFeedback'] != null && data['requesterFeedback']['rating'] != null) {
          totalRating += (data['requesterFeedback']['rating'] as num).toDouble();
          ratingCount++;
        }
      }
      
      rating.value = ratingCount > 0 ? totalRating / ratingCount : 0.0;
      
    } catch (e) {
      print('❌ Error fetching rating: $e');
    }
  }
  
  /// Fetch user stats
  Future<void> _fetchStats(String uid) async {
    try {
      // Validation Accuracy
      final validationsSnapshot = await _firestore
          .collection('validations')
          .where('userId', isEqualTo: uid)
          .get();
      
      int approvedCount = 0;
      for (var doc in validationsSnapshot.docs) {
        if (doc.data()['status'] == 'approved') {
          approvedCount++;
        }
      }
      
      if (validationsSnapshot.docs.isNotEmpty) {
        double accuracy = (approvedCount / validationsSnapshot.docs.length) * 100;
        validationAccuracy.value = '${accuracy.toStringAsFixed(0)}%';
      }
      
      // Response Time (example - would need actual data)
      responseTime.value = '< 5 min';
      
      // Average Distance (example - would need actual data)
      averageDistance.value = '3.2 km';
      
      // Completion Rate
      final allTasksSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .get();
      
      final completedSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();
      
      if (allTasksSnapshot.docs.isNotEmpty) {
        double completion = (completedSnapshot.docs.length / allTasksSnapshot.docs.length) * 100;
        completionRate.value = '${completion.toStringAsFixed(0)}%';
      }
      
      // Dispute Rate
      final disputesSnapshot = await _firestore
          .collection('disputes')
          .where('taskData.acceptedOfferUid', isEqualTo: uid)
          .get();
      
      if (allTasksSnapshot.docs.isNotEmpty) {
        double dispute = (disputesSnapshot.docs.length / allTasksSnapshot.docs.length) * 100;
        disputeRate.value = '${dispute.toStringAsFixed(1)}%';
      }
      
      // Violations (example - would need actual violations collection)
      violations.value = 0;
      
    } catch (e) {
      print('❌ Error fetching stats: $e');
    }
  }
  
  /// Fetch task breakdown
  Future<void> _fetchTaskBreakdown(String uid) async {
    try {
      // Total tasks (as requester + helper)
      final requesterTasksSnapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();
      
      final helperTasksSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .get();
      
      totalTasks.value = requesterTasksSnapshot.docs.length + helperTasksSnapshot.docs.length;
      
      // Completed
      int completed = 0;
      int cancelledUser = 0;
      int cancelledHelper = 0;
      int disputed = 0;
      
      for (var doc in [...requesterTasksSnapshot.docs, ...helperTasksSnapshot.docs]) {
        final status = doc.data()['status']?.toString().toLowerCase() ?? '';
        
        if (status == 'completed') {
          completed++;
        } else if (status == 'cancelled') {
          // Check who cancelled
          final cancelledBy = doc.data()['cancelledBy'];
          if (cancelledBy == uid) {
            cancelledUser++;
          } else {
            cancelledHelper++;
          }
        } else if (status == 'disputed') {
          disputed++;
        }
      }
      
      completedTasks.value = completed;
      cancelledByUser.value = cancelledUser;
      cancelledByHelper.value = cancelledHelper;
      disputedTasks.value = disputed;
      
    } catch (e) {
      print('❌ Error fetching task breakdown: $e');
    }
  }
  
  /// Fetch wallet data
  Future<void> _fetchWalletData(String uid) async {
    try {
      final walletDoc = await _firestore.collection('wallets').doc(uid).get();
      
      if (walletDoc.exists) {
        final walletData = walletDoc.data()!;
        
        totalEarned.value = (walletData['totalEarned'] ?? 0).toDouble();
        currentBalance.value = (walletData['balance'] ?? 0).toDouble();
        pendingWithdrawals.value = (walletData['pendingWithdrawals'] ?? 0).toDouble();
        penalties.value = (walletData['penalties'] ?? 0).toDouble();
      }
      
    } catch (e) {
      print('❌ Error fetching wallet data: $e');
    }
  }
  
  /// Warn helper action
  void warnHelper() {
    // TODO: Implement warn helper functionality
    Get.snackbar('Warn Helper', 'Warning sent to helper');
  }
  
  /// Suspend account action
  void suspendAccount() {
    // TODO: Implement suspend account functionality
    Get.snackbar('Suspend Account', 'Account suspended');
  }
}
