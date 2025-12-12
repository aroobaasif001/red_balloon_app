import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
  var isProofSubmitter =
      false.obs; // 🔥 Check if current user submitted the proof

  // 🔥 Timer observables
  var remainingTime = '15:00'.obs; // Display format MM:SS
  var remainingSeconds = 900.obs; // 15 minutes = 900 seconds
  Timer? _timer;

  // 🔥 Voting calculation
  var helperVotes = 0.obs;
  var requesterVotes = 0.obs;
  var validationId = ''.obs;
  var rejectedAt = Rx<DateTime?>(null);
  var completedAt = Rx<DateTime?>(null); // 🔥 For "Submitted time ago"

  // 🔥 Participant Names
  var requesterName = 'Requester'.obs;
  var helperName = 'Helper'.obs;
  
  // 🔥 Track Current User's Vote
  var myVote = ''.obs; // 'helper' or 'requester'

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Format time ago for "Submitted ... ago"
  String getSubmittedTimeAgo() {
    if (completedAt.value == null) return '';

    final now = DateTime.now();
    final difference = now.difference(completedAt.value!);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months m ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }

  /// Fetch task details using taskId from validation
  Future<void> fetchTaskDetails({
    required String validationTaskId,
    required String validationUserId,
    required String validationBeforePhoto,
    required String validationAfterPhoto,
    String? proofId, // 🔥 Added proofId parameter
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
        taskDescription.value =
            taskData['description'] ?? 'No description available';

        // 🔥 Check if current user owns this task
        final currentUserId = _auth.currentUser?.uid;
        final taskOwnerId = taskData['uid']; // Task creator's UID
        isTaskOwner.value = (currentUserId == taskOwnerId);

        print('🔍 Current User: $currentUserId');
        print('🔍 Task Owner: $taskOwnerId');
        print('🔍 Is Task Owner: ${isTaskOwner.value}');

        // 🔥 Fetch Requester Name
        if (taskOwnerId != null) {
          final userDoc = await _firestore
              .collection('users')
              .doc(taskOwnerId)
              .get();
          if (userDoc.exists) {
            requesterName.value = userDoc.data()?['displayName'] ?? 'Requester';
            print('🔍 Requester Name: ${requesterName.value}');
          }
        }

        // 🔥 Fetch proof submitter userId from task_proofs
        if (proofId != null && proofId.isNotEmpty) {
          await _fetchProofSubmitterUserId(proofId, currentUserId);
        }

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

  /// Fetch proof submitter's userId and Name from task_proofs collection
  Future<void> _fetchProofSubmitterUserId(
    String proofId,
    String? currentUserId,
  ) async {
    try {
      final proofDoc = await _firestore
          .collection('task_proofs')
          .doc(proofId)
          .get();

      if (proofDoc.exists) {
        final proofData = proofDoc.data()!;
        final proofSubmitterUserId =
            proofData['userId']; // UID of proof submitter

        // Check if current user is the proof submitter
        isProofSubmitter.value = (currentUserId == proofSubmitterUserId);

        print('🔍 Proof Submitter: $proofSubmitterUserId');
        print('🔍 Is Proof Submitter: ${isProofSubmitter.value}');

        // 🔥 Fetch Helper Name
        if (proofSubmitterUserId != null) {
          final userDoc = await _firestore
              .collection('users')
              .doc(proofSubmitterUserId)
              .get();
          if (userDoc.exists) {
            helperName.value = userDoc.data()?['displayName'] ?? 'Helper';
            print('🔍 Helper Name: ${helperName.value}');
          }
        }
      }
    } catch (e) {
      print('❌ Error fetching proof submitter data: $e');
    }
  }

  /// Fetch voting data from Firestore
  Future<void> _fetchVotingData(String taskId) async {
    try {
      // 🔥 Fetch validation document to get rejectedAt timestamp
      final validationSnapshot = await _firestore
          .collection('validations')
          .where('taskId', isEqualTo: taskId)
          .limit(1)
          .get();

      if (validationSnapshot.docs.isNotEmpty) {
        final validationDoc = validationSnapshot.docs.first;
        validationId.value = validationDoc.id;

        // Get rejectedAt timestamp
        final Timestamp? timestamp = validationDoc.data()['rejectedAt'];
        if (timestamp != null) {
          rejectedAt.value = timestamp.toDate();
          _startTimer(); // 🔥 Start 15-minute countdown
        }

        // 🔥 Get completedAt timestamp for "Submitted time ago"
        final Timestamp? completedTimestamp = validationDoc
            .data()['completedAt'];
        if (completedTimestamp != null) {
          completedAt.value = completedTimestamp.toDate();
        }
      }

      final votingDoc = await _firestore.collection('voting').doc(taskId).get();

      if (votingDoc.exists) {
        final data = votingDoc.data()!;
        votesReceived.value = data['votesReceived'] ?? 0;
        votesNeeded.value = data['votesNeeded'] ?? 9;

        // 🔥 Calculate helper vs requester votes
        final voters = List<Map<String, dynamic>>.from(data['voters'] ?? []);
        helperVotes.value = voters
            .where((v) => v['voteType'] == 'helper')
            .length;
        requesterVotes.value = voters
            .where((v) => v['voteType'] == 'requester')
            .length;

        // Check if current user already voted
        final currentUserId = _auth.currentUser?.uid;
        final myVoteData = voters.firstWhereOrNull(
          (voter) => voter['userId'] == currentUserId,
        );
        
        hasVoted.value = myVoteData != null;
        if (hasVoted.value) {
          myVote.value = myVoteData!['voteType'] ?? '';
        } else {
          myVote.value = '';
        }

        // 🔥 Check if voting should be completed
        _checkVotingCompletion();
      } else {
        // Initialize voting document if it doesn't exist
        votesReceived.value = 0;
        votesNeeded.value = 9;
        helperVotes.value = 0;
        requesterVotes.value = 0;
        hasVoted.value = false;
        myVote.value = '';
      }
    } catch (e) {
      print('❌ Error fetching voting data: $e');
    }
  }

  /// Start 15-minute countdown timer
  void _startTimer() {
    if (rejectedAt.value == null) return;

    _timer?.cancel(); // Cancel any existing timer

    // Calculate remaining time
    final now = DateTime.now();
    final endTime = rejectedAt.value!.add(Duration(minutes: 15));
    final difference = endTime.difference(now);

    if (difference.isNegative) {
      // Timer expired
      remainingTime.value = '00:00';
      remainingSeconds.value = 0;
      _handleTimerExpiry();
      return;
    }

    remainingSeconds.value = difference.inSeconds;
    _updateTimerDisplay();

    // Update timer every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        _updateTimerDisplay();
      } else {
        timer.cancel();
        _handleTimerExpiry();
      }
    });
  }

  /// Update timer display format (MM:SS)
  void _updateTimerDisplay() {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    remainingTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Handle timer expiry
  void _handleTimerExpiry() {
    print('⏰ Voting timer expired - Setting isVotingCompleted to true');
    _finalizeVoting();
  }

  /// Check if voting reached threshold (but don't set isVotingCompleted yet)
  Future<void> _checkVotingCompletion() async {
    // 🔥 Voting closes when either side gets 5 votes
    if (helperVotes.value >= 5 || requesterVotes.value >= 5) {
      final winner = helperVotes.value >= 5 ? 'helper' : 'requester';
      await _recordWinner(winner: winner);

      // 🔥 Stop accepting new votes but DON'T set isVotingCompleted
      // Timer keeps running until 15 minutes
      // Get.snackbar(
      //   'Voting Closed',
      //   'The $winner has won! Waiting for timer to complete.',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  /// Record winner but don't set isVotingCompleted
  Future<void> _recordWinner({required String winner}) async {
    try {
      await _firestore.collection('validations').doc(validationId.value).update(
        {
          'winner': winner,
          'helperVotes': helperVotes.value,
          'requesterVotes': requesterVotes.value,
          'votingClosedAt': FieldValue.serverTimestamp(),
          // 🔥 isVotingCompleted stays false until timer expires
        },
      );

      print('✅ Winner recorded: $winner (Timer still running)');
    } catch (e) {
      print('❌ Error recording winner: $e');
    }
  }

  /// Finalize voting when timer expires (ONLY place isVotingCompleted = true)
  Future<void> _finalizeVoting() async {
    try {
      // Determine winner if not already set
      String? winner;
      if (helperVotes.value >= 5 || requesterVotes.value >= 5) {
        winner = helperVotes.value >= 5 ? 'helper' : 'requester';
      } else if (helperVotes.value <= 4 && requesterVotes.value <= 4) {
        // Send to admin
        await _sendToAdmin();
        return;
      } else {
        winner = helperVotes.value > requesterVotes.value
            ? 'helper'
            : 'requester';
      }

      // 🔥 ONLY set isVotingCompleted when timer expires
      await _firestore.collection('validations').doc(validationId.value).update(
        {
          'isVotingCompleted': true, // 🔥 ONLY here!
          'winner': winner,
          'helperVotes': helperVotes.value,
          'requesterVotes': requesterVotes.value,
          'completedAt': FieldValue.serverTimestamp(),
        },
      );

      print('✅ Voting finalized. isVotingCompleted = true. Winner: $winner');

      Get.snackbar(
        'Validation Complete',
        'Timer expired. Final result: $winner wins!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Error finalizing voting: $e');
    }
  }

  /// Send to admin for manual review
  Future<void> _sendToAdmin() async {
    try {
      await _firestore
          .collection('validations')
          .doc(validationId.value)
          .update({
            'isVotingCompleted': true,
            'sentToAdmin': true,
            'helperVotes': helperVotes.value,
            'requesterVotes': requesterVotes.value,
            'completedAt': FieldValue.serverTimestamp(),
          });

      print('📤 Sent to admin for review');

      Get.snackbar(
        'Admin Review',
        'Votes are tied. Sent to admin for manual review.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Error sending to admin: $e');
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

      // 🔥 Check if user is proof submitter
      if (isProofSubmitter.value) {
        Get.snackbar('Not Allowed', 'You cannot vote on your own proof');
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
              'votedAt': DateTime.now()
                  .toIso8601String(), // Use DateTime instead of serverTimestamp
            },
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
              'votedAt': DateTime.now()
                  .toIso8601String(), // Use DateTime instead of serverTimestamp
            },
          ],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Update local state
      votesReceived.value++;
      hasVoted.value = true;
      myVote.value = voteType; // 🔥 Update local vote state
      
      // 🔥 Update helper/requester vote counts
      if (voteType == 'helper') {
        helperVotes.value++;
      } else {
        requesterVotes.value++;
      }

      Get.snackbar(
        'Success',
        'Your vote has been recorded',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('✅ Vote submitted: $voteType');
      print(
        '📊 Helper votes: ${helperVotes.value}, Requester votes: ${requesterVotes.value}',
      );

      // 🔥 Check if voting should be completed
      await _checkVotingCompletion();
    } catch (e) {
      print('❌ Error submitting vote: $e');
      Get.snackbar('Error', 'Failed to submit vote');
    }
  }
}
