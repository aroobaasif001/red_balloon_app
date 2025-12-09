import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DisputeDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var isLoading = false.obs;
  
  // Task Info
  var taskTitle = ''.obs;
  var taskId = ''.obs;
  var submittedTime = ''.obs;
  
  // Requester Info
  var requesterName = ''.obs;
  var requesterUserId = ''.obs;
  var requesterCity = ''.obs;
  var requesterImage = ''.obs;
  var requesterUid = ''.obs;
  
  // Helper Info
  var helperName = ''.obs;
  var helperUserId = ''.obs;
  var helperRating = 0.0.obs;
  var helperTasksCompleted = 0.obs;
  var helperImage = ''.obs;
  var helperUid = ''.obs;
  
  // Reports
  var requesterReport = ''.obs;
  var helperReport = ''.obs;
  
  /// Fetch all dispute details
  Future<void> fetchDisputeDetails(String taskId) async {
    try {
      isLoading.value = true;
      print('🔍 Fetching dispute details for task: $taskId');
      
      // 1. Fetch task document
      final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
      
      if (!taskDoc.exists) {
        print('❌ Task not found');
        isLoading.value = false;
        return;
      }
      
      final taskData = taskDoc.data()!;
      
      // Task basic info
      this.taskId.value = taskId;
      taskTitle.value = taskData['title'] ?? 'No Title';
      requesterReport.value = taskData['requesterHelpDetails'] ?? 
                              taskData['requesterHelpReason'] ?? 
                              'No report provided';
      helperReport.value = taskData['helperHelpDetails'] ?? 
                          taskData['helperHelpReason'] ?? 
                          'No report provided';
      
      // Calculate submitted time
      if (taskData['disputedStartTime'] != null) {
        try {
          DateTime disputedTime;
          if (taskData['disputedStartTime'] is String) {
            disputedTime = DateTime.parse(taskData['disputedStartTime']);
          } else {
            disputedTime = (taskData['disputedStartTime'] as Timestamp).toDate();
          }
          submittedTime.value = _getTimeAgo(disputedTime);
        } catch (e) {
          print('❌ Error parsing disputed time: $e');
          submittedTime.value = 'Recently';
        }
      } else {
        submittedTime.value = 'Recently';
      }
      
      print('✅ Task info loaded: ${taskTitle.value}');
      
      // 2. Fetch Requester details (using task.uid)
      final requesterUidValue = taskData['uid'];
      if (requesterUidValue != null) {
        requesterUid.value = requesterUidValue;
        await _fetchRequesterDetails(requesterUidValue);
      }
      
      // 3. Fetch Helper details (using acceptedOfferUid)
      final helperUidValue = taskData['acceptedOfferUid'];
      if (helperUidValue != null) {
        helperUid.value = helperUidValue;
        await _fetchHelperDetails(helperUidValue);
      }
      
      isLoading.value = false;
      print('✅ Dispute details loaded successfully');
    } catch (e) {
      print('❌ Error fetching dispute details: $e');
      isLoading.value = false;
    }
  }
  
  /// Fetch requester user details
  Future<void> _fetchRequesterDetails(String uid) async {
    try {
      print('👤 Fetching requester details for UID: $uid');
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        requesterName.value = userData['username'] ?? 
                             userData['displayName'] ?? 
                             userData['name'] ?? 
                             'Unknown User';
        requesterUserId.value = userData['userId'] ?? 'RB-00000';
        requesterCity.value = userData['city'] ?? 
                             userData['location'] ?? 
                             'Unknown';
        requesterImage.value = userData['photoURL'] ?? 
                              userData['profileImage'] ?? 
                              '';
        
        print('✅ Requester: ${requesterName.value} (${requesterUserId.value})');
      } else {
        print('❌ Requester user not found');
      }
    } catch (e) {
      print('❌ Error fetching requester details: $e');
    }
  }
  
  /// Fetch helper user details
  Future<void> _fetchHelperDetails(String uid) async {
    try {
      print('👷 Fetching helper details for UID: $uid');
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        helperName.value = userData['username'] ?? 
                          userData['displayName'] ?? 
                          userData['name'] ?? 
                          'Unknown User';
        helperUserId.value = userData['userId'] ?? 'RB-00000';
        helperRating.value = (userData['rating'] ?? 0.0).toDouble();
        helperTasksCompleted.value = userData['completedTasks'] ?? 0;
        helperImage.value = userData['photoURL'] ?? 
                           userData['profileImage'] ?? 
                           '';
        
        print('✅ Helper: ${helperName.value} (${helperUserId.value})');
        print('📊 Helper stats - Rating: ${helperRating.value}, Tasks: ${helperTasksCompleted.value}');
      } else {
        print('❌ Helper user not found');
      }
    } catch (e) {
      print('❌ Error fetching helper details: $e');
    }
  }
  
  /// Calculate time ago
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
