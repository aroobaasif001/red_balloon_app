import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_balloon_app/services/task_service.dart';

class ValidationScreenController extends GetxController {
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables for task data
  var isLoading = true.obs;
  var taskTitle = ''.obs;
  var taskId = ''.obs;
  var taskDescription = ''.obs;
  var userId = ''.obs;
  var beforePhotoUrl = ''.obs;
  var afterPhotoUrl = ''.obs;
  var submittedTime = ''.obs;
  var votesReceived = 0.obs;
  var votesNeeded = 0.obs;
  var isTaskOwner = false.obs; // 🔥 Check if current user owns the task
  var hasVoted = false.obs; // 🔥 Check if user already voted

  /// Fetch task details using taskId from validation
  Future<void> fetchTaskDetails({
    required String validationTaskId,
    required String validationUserId,
    required String validationBeforePhoto,
    required String validationAfterPhoto,
  }) async {
    try {
      isLoading.value = true;

      // Set validation data
      taskId.value = validationTaskId;
      userId.value = validationUserId;
      beforePhotoUrl.value = validationBeforePhoto;
      afterPhotoUrl.value = validationAfterPhoto;

      // Fetch task details from tasks collection
      final taskData = await _taskService.getTaskById(validationTaskId);

      if (taskData != null) {
        taskTitle.value = taskData['title'] ?? 'No Title';
        taskDescription.value = taskData['description'] ?? 'No description available';
        
        // 🔥 Check if current user owns this task
        final currentUserId = _auth.currentUser?.uid;
        final taskOwnerId = taskData['uid']; // Task creator's UID
        isTaskOwner.value = (currentUserId == taskOwnerId);
        
        print('🔍 Current User: $currentUserId');
        print('🔍 Task Owner: $taskOwnerId');
        print('🔍 Is Task Owner: ${isTaskOwner.value}');
        
        // 🔥 Fetch voting data from voting collection
        await _fetchVotingData(validationTaskId);
      }

      isLoading.value = false;
    } catch (e) {
      print('❌ Error fetching task details: $e');
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load task details');
    }
  }

  /// Fetch voting data from Firestore
  Future<void> _fetchVotingData(String taskId) async {
    try {
      final votingDoc = await _firestore.collection('voting').doc(taskId).get();
      
      if (votingDoc.exists) {
        final data = votingDoc.data()!;
        votesReceived.value = data['votesReceived'] ?? 0;
        votesNeeded.value = data['votesNeeded'] ?? 9;
        
        // Check if current user already voted
        final voters = List<Map<String, dynamic>>.from(data['voters'] ?? []);
        final currentUserId = _auth.currentUser?.uid;
        hasVoted.value = voters.any((voter) => voter['userId'] == currentUserId);
      } else {
        // Initialize voting document if it doesn't exist
        votesReceived.value = 0;
        votesNeeded.value = 9;
        hasVoted.value = false;
      }
    } catch (e) {
      print('❌ Error fetching voting data: $e');
    }
  }

  /// Submit vote to Firestore
  Future<void> submitVote(String voteType) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Check if user already voted
      if (hasVoted.value) {
        Get.snackbar('Already Voted', 'You have already voted on this task');
        return;
      }

      // Check if user is task owner
      if (isTaskOwner.value) {
        Get.snackbar('Not Allowed', 'You cannot vote on your own task');
        return;
      }

      final votingRef = _firestore.collection('voting').doc(taskId.value);
      final votingDoc = await votingRef.get();

      if (votingDoc.exists) {
        // Update existing voting document
        await votingRef.update({
          'votesReceived': FieldValue.increment(1),
          'voters': FieldValue.arrayUnion([
            {
              'userId': currentUserId,
              'voteType': voteType, // 'helper' or 'requester'
              'votedAt': DateTime.now().toIso8601String(), // Use DateTime instead of serverTimestamp
            }
          ]),
        });
      } else {
        // Create new voting document
        await votingRef.set({
          'taskId': taskId.value,
          'votesNeeded': 9,
          'votesReceived': 1,
          'voters': [
            {
              'userId': currentUserId,
              'voteType': voteType,
              'votedAt': DateTime.now().toIso8601String(), // Use DateTime instead of serverTimestamp
            }
          ],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Update local state
      votesReceived.value++;
      hasVoted.value = true;

      Get.snackbar(
        'Success',
        'Your vote has been recorded',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('✅ Vote submitted: $voteType');
    } catch (e) {
      print('❌ Error submitting vote: $e');
      Get.snackbar('Error', 'Failed to submit vote');
    }
  }
}
