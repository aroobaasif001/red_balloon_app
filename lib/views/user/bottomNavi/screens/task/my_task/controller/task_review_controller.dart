import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TaskReviewController extends GetxController {
  // Timer
  var remainingSeconds = 120.obs; // 2 minutes = 120 seconds
  Timer? _timer;

  // Rejection options
  var selectedRejectionReason = ''.obs;
  var customRejectionReason = ''.obs;

  final List<String> rejectionOptions = [
    'Work not completed',
    'Communication issue',
    'Task was ignored',
    'Others',
  ];

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// 🔥 Start 2-minute countdown timer
  void startTimer() {
    // 🔥 Don't start if timer is already running
    if (_timer != null && _timer!.isActive) {
      print('⏰ Timer already running, skipping start');
      return;
    }
    
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        // Auto-move to validation if no action taken
        print('⏰ Timer expired - Auto validation');
      }
    });
    
    print('⏰ Timer started from ${formattedTime}');
  }

  /// Format timer display (MM:SS)
  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Select rejection reason
  void selectRejectionReason(String reason) {
    selectedRejectionReason.value = reason;
  }

  /// 🔥 Submit rejection to Firestore
  Future<void> submitRejection({
    required String taskId,
    required String proofId,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('❌ No user logged in');
        return;
      }

      // Determine final rejection reason
      String finalReason = selectedRejectionReason.value == 'Others'
          ? customRejectionReason.value
          : selectedRejectionReason.value;

      if (finalReason.isEmpty) {
        Get.snackbar('Error', 'Please select a rejection reason');
        return;
      }

      // 1. Add to validations collection
      await FirebaseFirestore.instance.collection('validations').add({
        'taskId': taskId,
        'proofId': proofId,
        'rejectionReason': finalReason,
        'rejectedBy': currentUser.uid,
        'rejectedAt': FieldValue.serverTimestamp(),
        'status': 'rejected',
      });

      print('✅ Added to validations collection');

      // 2. Update task status to rejected
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'status': 'rejected'});

      print('✅ Task status updated to rejected');

      // 3. Update proof status to rejected
      await FirebaseFirestore.instance
          .collection('task_proofs')
          .doc(proofId)
          .update({'status': 'rejected'});

      print('✅ Proof status updated to rejected');

      Get.snackbar(
        'Success',
        'Rejection submitted successfully',
        snackPosition: SnackPosition.TOP,
      );

      // Navigation handled by caller
    } catch (e) {
      print('❌ Error submitting rejection: $e');
      Get.snackbar('Error', 'Failed to submit rejection');
    }
  }

  /// 🔥 Accept proof
  Future<void> acceptProof({
    required String taskId,
    required String proofId,
  }) async {
    try {
      // Update task status to completed
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'status': 'completed'});

      // Update proof status to accepted
      await FirebaseFirestore.instance
          .collection('task_proofs')
          .doc(proofId)
          .update({'status': 'accepted'});

      print('✅ Proof accepted successfully');

      Get.snackbar(
        'Success',
        'Proof accepted successfully',
        snackPosition: SnackPosition.TOP,
      );

      // Navigation handled by caller
    } catch (e) {
      print('❌ Error accepting proof: $e');
      Get.snackbar('Error', 'Failed to accept proof');
    }
  }
}
