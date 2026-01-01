import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../../../../../services/notification_services.dart';

class UserProfileDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Loading state
  var isLoading = true.obs;
  var isWarning = false.obs;
  var isSuspending = false.obs;

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
  var completionRate = '0%'.obs;
  var disputeRate = '0%'.obs;
  var violations = 0.obs;

  // Task Breakdown
  var totalTasks = 0.obs;
  var completedTasks = 0.obs;
  var disputedTasks = 0.obs;

  
  // Suspension state
  var isSuspended = false.obs;

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

  Future<void> fetchUserProfileData(String uid) async {
    _currentUserId = uid;
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
      
      // Suspension Status
      isSuspended.value = userData['willLogin'] == false;

      // Fetch all other data in parallel
      await Future.wait([
        _fetchUserProgress(uid),
        _fetchRatingAndCompletion(uid),
        _fetchStats(uid),
        _fetchTaskBreakdown(uid),

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
      requesterProgress.value = (tasksSnapshot.docs.length / 100).clamp(
        0.0,
        1.0,
      );
      helperProgress.value = (helperTasksSnapshot.docs.length / 100).clamp(
        0.0,
        1.0,
      );
      validatorProgress.value = (validationsSnapshot.docs.length / 100).clamp(
        0.0,
        1.0,
      );
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

      tasksCompleted.value =
          completedSnapshot.docs.length + helperCompletedSnapshot.docs.length;

      // Calculate average rating from feedbacks
      double totalRating = 0;
      int ratingCount = 0;

      for (var doc in completedSnapshot.docs) {
        final data = doc.data();
        if (data['helperFeedback'] != null &&
            data['helperFeedback']['rating'] != null) {
          totalRating += (data['helperFeedback']['rating'] as num).toDouble();
          ratingCount++;
        }
      }

      for (var doc in helperCompletedSnapshot.docs) {
        final data = doc.data();
        if (data['requesterFeedback'] != null &&
            data['requesterFeedback']['rating'] != null) {
          totalRating += (data['requesterFeedback']['rating'] as num)
              .toDouble();
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
        double accuracy =
            (approvedCount / validationsSnapshot.docs.length) * 100;
        validationAccuracy.value = '${accuracy.toStringAsFixed(0)}%';
      }

      // Completion Rate (already correctly calculated for Helper role)
      final allTasksAsHelperSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .get();

      final helperCompletedSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();

      if (allTasksAsHelperSnapshot.docs.isNotEmpty) {
        double completion =
            (helperCompletedSnapshot.docs.length / allTasksAsHelperSnapshot.docs.length) *
            100;
        completionRate.value = '${completion.toStringAsFixed(0)}%';
      }

      // Dispute Rate
      // Calculate based on all tasks where this user was a helper and status is 'Disputed'
      final helperDisputesSnapshot = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'Disputed')
          .get();

      final helperDisputesSnapshotLower = await _firestore
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'disputed')
          .get();

      int totalHelperDisputes = helperDisputesSnapshot.docs.length + 
                                helperDisputesSnapshotLower.docs.length;

      if (allTasksAsHelperSnapshot.docs.isNotEmpty) {
        double dispute = (totalHelperDisputes / allTasksAsHelperSnapshot.docs.length) * 100;
        disputeRate.value = '${dispute.toStringAsFixed(1)}%';
      }

      // Violations
      // Count notifications with category 'admin_warning' or 'dispute_warning'
      final adminWarningsSnapshot = await _firestore
          .collection('notifications')
          .doc(uid)
          .collection('items')
          .where('category', isEqualTo: 'admin_warning')
          .get();

      final disputeWarningsSnapshot = await _firestore
          .collection('notifications')
          .doc(uid)
          .collection('items')
          .where('category', isEqualTo: 'dispute_warning')
          .get();

      violations.value = adminWarningsSnapshot.docs.length + disputeWarningsSnapshot.docs.length;
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

      totalTasks.value =
          requesterTasksSnapshot.docs.length + helperTasksSnapshot.docs.length;

      // Completed
      // Completed and Disputed counts
      int completed = 0;
      int disputed = 0;

      for (var doc in [
        ...requesterTasksSnapshot.docs,
        ...helperTasksSnapshot.docs,
      ]) {
        final status = doc.data()['status']?.toString().toLowerCase() ?? '';

        if (status == 'completed') {
          completed++;
        } else if (status == 'disputed') {
          disputed++;
        }
      }

      completedTasks.value = completed;
      disputedTasks.value = disputed;
    } catch (e) {
      print('❌ Error fetching task breakdown: $e');
    }
  }



  /// Warn user action with push notification
  void warnUser() async {
    if (_currentUserId == null) return;
    if (isWarning.value) return; // Prevent double-tap

    try {
      isWarning.value = true;
      
      // Send dynamic push notification
      await NotificationService.instance.notifyAdminWarning(
        userUid: _currentUserId!,
      );

      Get.snackbar(
        'Action Successful',
        'Professional warning has been issued to the user.',
      );
      
      // Navigate back after 1 second
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send warning: $e');
    } finally {
      isWarning.value = false;
    }
  }

  /// Toggle account suspension status
  void toggleAccountSuspension() async {
    if (_currentUserId == null) return;
    if (isSuspending.value) return; // Prevent double-tap
    
    try {
      isSuspending.value = true;
      final newSuspendedState = !isSuspended.value;
      final newWillLogin = !newSuspendedState; // willLogin = false if suspended
      
      // 1) Update Firestore
      await _firestore.collection('users').doc(_currentUserId).update({
        'willLogin': newWillLogin,
      });
      
      // 2) Update local state
      isSuspended.value = newSuspendedState;
      
      // 3) Push notification
      await NotificationService.instance.notifyAccountSuspension(
        userUid: _currentUserId!,
        isSuspended: newSuspendedState,
      );
      
      Get.snackbar(
        'Success', 
        newSuspendedState ? 'Account has been suspended.' : 'Account has been restored.',
      );
      
      // Navigate back after 1 second
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update account status: $e');
    } finally {
      isSuspending.value = false;
    }
  }

  /// Suspend account action (legacy - to be removed or replaced)
  void suspendAccount() {
    toggleAccountSuspension();
  }
}
