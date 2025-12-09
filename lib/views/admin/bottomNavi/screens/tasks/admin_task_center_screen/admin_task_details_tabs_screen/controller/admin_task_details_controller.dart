import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTaskDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var isLoading = true.obs;
  var taskTitle = ''.obs;
  var rejectionReason = ''.obs;
  var completedTime = ''.obs;
  var taskCreatorUserId = ''.obs;
  var taskCreatorName = ''.obs;
  var taskCreatorImage = ''.obs;
  
  var helperUserId = ''.obs;
  var helperName = ''.obs;
  var helperImage = ''.obs;
  var helperTasksCount = 0.obs;
  var helperRating = 0.0.obs;
  var helperResponseTime = ''.obs;
  
  var beforePhotoUrl = ''.obs;
  var afterPhotoUrl = ''.obs;
  
  var supportRequesterVotes = 0.obs;
  var supportHelperVotes = 0.obs;
  var totalVotes = 0.obs;

  /// Fetch all task details
  Future<void> fetchTaskDetails(String validationId) async {
    try {
      isLoading.value = true;
      print('🔍 Fetching task details for validation: $validationId');

      // 1. Fetch validation document
      final validationDoc = await _firestore.collection('validations').doc(validationId).get();
      
      if (!validationDoc.exists) {
        print('❌ Validation not found');
        isLoading.value = false;
        return;
      }

      final validationData = validationDoc.data()!;
      final taskId = validationData['taskId'];
      final proofId = validationData['proofId'];
      final rejectedBy = validationData['rejectedBy']; // Task creator UID
      
      rejectionReason.value = validationData['rejectionReason'] ?? 'No reason provided';
      beforePhotoUrl.value = validationData['beforePhotoUrl'] ?? '';
      afterPhotoUrl.value = validationData['afterPhotoUrl'] ?? '';
      
      // Calculate completed time
      if (validationData['rejectedAt'] != null) {
        DateTime rejectedAt;
        if (validationData['rejectedAt'] is String) {
          rejectedAt = DateTime.parse(validationData['rejectedAt']);
        } else {
          rejectedAt = (validationData['rejectedAt'] as Timestamp).toDate();
        }
        completedTime.value = _getTimeAgo(rejectedAt);
      }

      // 2. Fetch task details
      if (taskId != null) {
        final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
        if (taskDoc.exists) {
          final taskData = taskDoc.data()!;
          taskTitle.value = taskData['title'] ?? 'No Title';
        }
      }

      // 3. Fetch task creator (rejectedBy) details
      if (rejectedBy != null) {
        await _fetchUserDetails(rejectedBy, isHelper: false);
      }

      // 4. Fetch helper (proof submitter) details
      if (proofId != null) {
        final proofDoc = await _firestore.collection('task_proofs').doc(proofId).get();
        if (proofDoc.exists) {
          final proofData = proofDoc.data()!;
          final helperUid = proofData['userId']; // Helper's UID
          if (helperUid != null) {
            await _fetchUserDetails(helperUid, isHelper: true);
          }
        }
      }

      // 5. Fetch voting data
      if (taskId != null) {
        await _fetchVotingData(taskId);
      }

      isLoading.value = false;
      print('✅ Task details loaded successfully');
    } catch (e) {
      print('❌ Error fetching task details: $e');
      isLoading.value = false;
    }
  }

  /// Fetch user details from users collection
  Future<void> _fetchUserDetails(String uid, {required bool isHelper}) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final userId = userData['userId'] ?? 'RB-00000';
        final name = userData['name'] ?? 'Unknown User';
        final image = userData['profileImage'] ?? '';
        
        if (isHelper) {
          helperUserId.value = userId;
          helperName.value = name;
          helperImage.value = image;
          
          // Fetch helper stats
          helperTasksCount.value = userData['completedTasks'] ?? 0;
          helperRating.value = (userData['rating'] ?? 0.0).toDouble();
          helperResponseTime.value = _calculateResponseTime(userData['averageResponseTime']);
        } else {
          taskCreatorUserId.value = userId;
          taskCreatorName.value = name;
          taskCreatorImage.value = image;
        }
      }
    } catch (e) {
      print('❌ Error fetching user details: $e');
    }
  }

  /// Fetch voting data
  Future<void> _fetchVotingData(String taskId) async {
    try {
      final votingDoc = await _firestore.collection('voting').doc(taskId).get();
      
      if (votingDoc.exists) {
        final votingData = votingDoc.data()!;
        final voters = List<Map<String, dynamic>>.from(votingData['voters'] ?? []);
        
        supportHelperVotes.value = voters.where((v) => v['voteType'] == 'helper').length;
        supportRequesterVotes.value = voters.where((v) => v['voteType'] == 'requester').length;
        totalVotes.value = voters.length;
        
        print('📊 Votes - Helper: ${supportHelperVotes.value}, Requester: ${supportRequesterVotes.value}');
      }
    } catch (e) {
      print('❌ Error fetching voting data: $e');
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Completed ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return 'Completed ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return 'Completed ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Completed just now';
    }
  }

  String _calculateResponseTime(dynamic avgResponseTime) {
    if (avgResponseTime == null) return '5 min';
    
    if (avgResponseTime is int) {
      if (avgResponseTime < 60) {
        return '$avgResponseTime min';
      } else {
        final hours = avgResponseTime ~/ 60;
        return '$hours hr${hours > 1 ? 's' : ''}';
      }
    }
    
    return '5 min';
  }
}
