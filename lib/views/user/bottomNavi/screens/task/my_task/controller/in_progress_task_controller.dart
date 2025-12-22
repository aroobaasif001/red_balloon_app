import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/services/task_service.dart';
import '../../../../../../../services/notification_services.dart';

class InProgressTaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString status = 'In Progress'.obs;
  RxString distance = '3.4 km away'.obs;
  RxString eta = 'ETA 10 mins'.obs;

  RxString taskTitle = 'Clean my Solar Panels'.obs;
  RxString taskPrice = '1000'.obs;
  RxString taskLocation = 'Riyadh'.obs;
  RxString postedAgo = '15 mins ago'.obs;

  RxString helperInitials = 'AH'.obs;
  RxString helperName = 'Ahmed Al Harbi'.obs;
  RxDouble rating = 4.9.obs;
  RxString role = 'Requester'.obs;

  // Track if proof has been uploaded
  RxBool hasProof = false.obs;
  RxBool isCheckingProof = true.obs;

  // Real-time proof listener
  StreamSubscription? _proofListener;
  StreamSubscription? _taskStatusListener;
  RxString proofId = ''.obs;
  String? taskOwnerId; // 🔥 To notify owner
  String? currentTaskTitle; // 🔥 For notification body

  /// Check if proof exists in task_proofs collection for given taskId
  Future<void> checkProofExists(String taskId) async {
    if (taskId.isEmpty) {
      isCheckingProof.value = false;
      return;
    }

    try {
      isCheckingProof.value = true;

      // Query task_proofs collection for this taskId
      final querySnapshot = await _firestore
          .collection('task_proofs')
          .where('taskId', isEqualTo: taskId)
          .limit(1)
          .get();

      // If any proof exists, set hasProof to true
      hasProof.value = querySnapshot.docs.isNotEmpty;

      // Setup real-time listener for proof updates
      setupProofListener(taskId);
    } catch (e) {
      print('Error checking proof: $e');
      hasProof.value = false;
    } finally {
      isCheckingProof.value = false;
    }
  }

  /// Setup real-time listener for proof changes
  void setupProofListener(String taskId) {
    _proofListener = _firestore
        .collection('task_proofs')
        .where('taskId', isEqualTo: taskId)
        .snapshots()
        .listen((snapshot) {
          hasProof.value = snapshot.docs.isNotEmpty;
          if (snapshot.docs.isNotEmpty) {
            proofId.value = snapshot.docs.first.id;
          }
          print(
            '✅ Real-time proof update: ${snapshot.docs.length} proofs found',
          );
        });
  }

  /// Start real-time listener for task status changes
  void startStatusListener(String taskId) {
    if (taskId.isEmpty) return;

    _taskStatusListener = _firestore
        .collection('tasks')
        .doc(taskId)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            final taskStatus = data?['status']?.toString().toLowerCase() ?? '';

            // If status changed from "in_progress" to something else (completed, cancelled, etc)
            if (taskStatus.isNotEmpty && taskStatus != 'in progress') {
              print('✅ Task status changed to: $taskStatus');

              // Navigate back
              if (Get.context != null) {
                Navigator.of(Get.context!).pop();
              }
            }
          }
        });
  }

  // Help Request Status for Helper view
  RxBool requesterHelpRequested = false.obs;
  RxBool helperHelpRequested = false.obs;
  RxString requesterHelpReason = ''.obs;
  RxString requesterHelpDetails = ''.obs;
  final TaskService _taskService = TaskService();

  /// Start real-time listener for task help requests
  void startTaskListener(String taskId) {
    if (taskId.isEmpty) return;

    _firestore.collection('tasks').doc(taskId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          requesterHelpRequested.value =
              data['requesterHelpRequested'] ?? false;
          helperHelpRequested.value = data['helperHelpRequested'] ?? false;
          requesterHelpReason.value = data['requesterHelpReason'] ?? '';
          requesterHelpDetails.value = data['requesterHelpDetails'] ?? '';
        }
      }
    });
  }

  /// Submit Help Request for Helper
  Future<void> submitHelpRequest(
    String taskId,
    String reason,
    String details,
  ) async {
    if (taskId.isEmpty) return;

    await _taskService.updateHelpRequest(
      taskId: taskId,
      role: 'helper',
      reason: reason,
      details: details,
    );

    // 🔥 Send Push Notification to owner
    if (taskOwnerId != null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      final senderName = currentUser?.displayName ?? 'Helper';
      
      NotificationService.instance.notifyHelpRequested(
        receiverId: taskOwnerId!,
        senderName: senderName,
        taskTitle: currentTaskTitle ?? 'Task',
        taskId: taskId,
      );
    }
  }

  @override
  void onClose() {
    _proofListener?.cancel();
    _taskStatusListener?.cancel();
    super.onClose();
  }
}
