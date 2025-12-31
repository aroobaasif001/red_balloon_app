import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/task_service.dart';
import 'package:red_balloon_app/services/user_service.dart';

import '../../../../../../../services/notification_services.dart';
import '../../../../bottom_navi_screen.dart';

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
  RxString helperUserId = ''.obs; // 🔥 Added to fetch custom ID (RB-001)
  RxString helperPhotoUrl = ''.obs;

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
              print('✅ Task status changed to: $taskStatus. Navigating back.');

              // Navigate back
              if (Get.isRegistered<InProgressTaskController>()) {
                Get.offAll(() => BottomNaviScreen(initialIndex: 1));
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
  final UserService _userService = UserService();

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

          // 🔥 Determine Role (Who is the counter-party?)
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            if (currentUser.uid == data['uid']) {
              // I am the Requester, the person in the card is the Helper
              role.value = 'Helper';
            } else {
              // I am the Helper, the person in the card is the Requester
              role.value = 'Requester';
            }
          }
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

    try {
      // 🔥 Check if task is already disputed
      final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
      if (taskDoc.exists) {
        final taskStatus = taskDoc.data()?['status']?.toString().toLowerCase();

        if (taskStatus == 'disputed') {
          Get.snackbar(
            'Already Disputed',
            'This task is already in dispute resolution',
          );
          return;
        }
      }

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
        final tTitle = currentTaskTitle ?? 'Task';

        // 1. Notify Requester
        NotificationService.instance.notifyHelpRequested(
          receiverId: taskOwnerId!,
          senderName: senderName,
          taskTitle: tTitle,
          taskId: taskId,
        );

        // 2. 🔥 If it became disputed, notify both + admin
        final updatedTask = await _firestore.collection('tasks').doc(taskId).get();
        if (updatedTask.data()?['status'] == 'Disputed') {
          NotificationService.instance.notifyDisputeStarted(
            requesterId: taskOwnerId!,
            helperId: currentUser?.uid ?? '',
            taskTitle: tTitle,
            taskId: taskId,
          );
        }
      }
    } catch (e) {
      print('Error submitting help request: $e');
      Get.snackbar('Error', 'Failed to submit help request');
    }
  }

  /// Fetch user data (name, photo, userId) from Firestore via helperUid
  Future<void> fetchUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          helperName.value = data['displayName'] ?? data['name'] ?? 'Helper';
          helperPhotoUrl.value = data['photoURL'] ?? data['photoUrl'] ?? '';
          helperUserId.value =
              data['userId'] ?? ''; // 🔥 Fetch custom ID (RB-001)

          // Generate initials
          if (helperName.value.isNotEmpty) {
            helperInitials.value = helperName.value[0].toUpperCase();
          }

          // 🔥 Fetch dynamic rating and stats
          final stats = await _userService.getUserStatistics(uid);
          rating.value = (stats['rating'] ?? 5.0).toDouble();
        }
      }
    } catch (e) {
      print('Error fetching helper user data: $e');
    }
  }

  // 🔥 Accepted Offer Price
  RxString acceptedOfferPrice = ''.obs;

  Future<void> fetchAcceptedOfferPrice(String taskId) async {
    try {
      final query = await _firestore
          .collection('offers')
          .where('taskId', isEqualTo: taskId)
          .where('status', isEqualTo: 'accepted')
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final price = query.docs.first.data()['offerPrice']?.toString();
        if (price != null && price.isNotEmpty) {
          acceptedOfferPrice.value = price;
        }
      }
    } catch (e) {
      print('Error fetching accepted offer price: $e');
    }
  }

  @override
  void onClose() {
    _proofListener?.cancel();
    _taskStatusListener?.cancel();
    super.onClose();
  }
}
