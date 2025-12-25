import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/offer_model.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/model/user_model.dart';
import 'package:red_balloon_app/services/offer_service.dart';
import 'package:red_balloon_app/services/task_service.dart';
import 'package:red_balloon_app/services/user_service.dart';

import '../../../../../../../services/notification_services.dart';
import '../../../../bottom_navi_screen.dart';

class TaskInProgressController extends GetxController {
  final TaskService _taskService = TaskService();
  final OfferService _offerService = OfferService();
  final UserService _userService = UserService();

  // Observables
  var isLoading = true.obs;
  Rx<TaskModel?> task = Rx<TaskModel?>(null);
  Rx<OfferModel?> acceptedOffer = Rx<OfferModel?>(null);
  Rx<UserModel?> helperUser = Rx<UserModel?>(null);
  var helperStats = <String, dynamic>{}.obs;
  var hasProof = false.obs; // 🔥 Track if proof exists
  var proofId = ''.obs; // 🔥 Store proof ID

  // 🔥 Optional task ID to fetch specific task
  final String? taskId;

  TaskInProgressController({this.taskId});

  // Help Request Status
  var requesterHelpRequested = false.obs;
  var helperHelpRequested = false.obs;
  var helperHelpReason = ''.obs;
  var helperHelpDetails = ''.obs;

  // Real-time listeners
  StreamSubscription? _taskListener;
  StreamSubscription? _proofListener;

  @override
  void onInit() {
    super.onInit();
    fetchInProgressTask();
  }

  void setupTaskListener(String taskId) {
    _taskListener = FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            if (data != null) {
              requesterHelpRequested.value =
                  data['requesterHelpRequested'] ?? false;
              helperHelpRequested.value = data['helperHelpRequested'] ?? false;
              helperHelpReason.value = data['helperHelpReason'] ?? '';
              helperHelpDetails.value = data['helperHelpDetails'] ?? '';

              // 🔥 Check for status change to anything other than 'in progress'
              final taskStatus = data['status']?.toString().toLowerCase() ?? '';
              if (taskStatus.isNotEmpty && taskStatus != 'in progress') {
                print(
                  '✅ Task status changed to $taskStatus. Navigating back from TaskInProgressScreen.',
                );
                if (Get.isRegistered<TaskInProgressController>()) {
                  Get.offAll(() => BottomNaviScreen(initialIndex: 1));
                }
              }

              // Also update local task model if needed, but these flags are most critical
              // task.value = TaskModel.fromJson(data, snapshot.id); // Optional, might cause rebuilds
            }
          }
        });

    // Setup real-time proof listener
    setupProofListener(taskId);
  }

  void setupProofListener(String taskId) {
    _proofListener = FirebaseFirestore.instance
        .collection('task_proofs')
        .where('taskId', isEqualTo: taskId)
        .orderBy('submittedAt', descending: true)
        .limit(5)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            hasProof.value = true;

            // Try to find a proof with images
            QueryDocumentSnapshot<Map<String, dynamic>>? proofWithImages;

            for (var doc in snapshot.docs) {
              final data = doc.data();
              if (data['beforePhotoUrl'] != null &&
                  data['afterPhotoUrl'] != null) {
                proofWithImages = doc;
                break;
              }
            }

            // Use proof with images if found, otherwise use the latest one
            final selectedProof = proofWithImages ?? snapshot.docs.first;

            proofId.value = selectedProof.id;
            print('✅ Real-time proof update: ${proofId.value}');
          } else {
            hasProof.value = false;
          }
        });
  }

  @override
  void onClose() {
    _taskListener?.cancel();
    _proofListener?.cancel();
    super.onClose();
  }

  /// Submit Help Request for Requester
  Future<void> submitHelpRequest(String reason, String details) async {
    if (task.value?.id == null) return;

    await _taskService.updateHelpRequest(
      taskId: task.value!.id!,
      role: 'requester',
      reason: reason,
      details: details,
    );

    // 🔥 Send Push Notification to helper
    final hUid = acceptedOffer.value?.offeringUserUid;
    final tTitle = task.value?.title;
    final tId = task.value?.id;

    if (hUid != null && tTitle != null && tId != null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      final senderName = currentUser?.displayName ?? 'Requester';

      NotificationService.instance.notifyHelpRequested(
        receiverId: hUid,
        senderName: senderName,
        taskTitle: tTitle,
        taskId: tId,
      );
    }

    // Refresh local state (listener handles it mostly, but good for immediate feedback if needed)
  }

  /// Fetch in-progress task (specific or first available)
  Future<void> fetchInProgressTask() async {
    try {
      isLoading.value = true;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('❌ No user logged in');
        isLoading.value = false;
        return;
      }

      // 🔥 If taskId is provided, fetch that specific task
      if (taskId != null && taskId!.isNotEmpty) {
        final taskDoc = await FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskId)
            .get();

        if (!taskDoc.exists) {
          print('❌ Task not found: $taskId');
          isLoading.value = false;
          return;
        }

        task.value = TaskModel.fromJson(taskDoc.data()!, taskDoc.id);
        setupTaskListener(task.value!.id!); // 🔥 Start listening

        print('✅ Found specific task: ${task.value?.title}');
      } else {
        // Get first in-progress task for current user
        final tasksSnapshot = await FirebaseFirestore.instance
            .collection('tasks')
            .where('uid', isEqualTo: currentUser.uid)
            .where('status', isEqualTo: 'in progress')
            .limit(1)
            .get();

        if (tasksSnapshot.docs.isEmpty) {
          print('❌ No in-progress tasks found');
          isLoading.value = false;
          return;
        }

        // Parse task
        final taskDoc = tasksSnapshot.docs.first;
        task.value = TaskModel.fromJson(taskDoc.data(), taskDoc.id);
        setupTaskListener(task.value!.id!); // 🔥 Start listening

        print('✅ Found in-progress task: ${task.value?.title}');
      }

      // Fetch accepted offer for this task
      await fetchAcceptedOffer(task.value!.id!);

      // 🔥 Check if proof exists for this task
      await checkForProof(task.value!.id!);

      isLoading.value = false;
    } catch (e) {
      print('❌ Error fetching in-progress task: $e');
      isLoading.value = false;
    }
  }

  /// Fetch the accepted offer for the task
  Future<void> fetchAcceptedOffer(String taskId) async {
    try {
      final offersSnapshot = await FirebaseFirestore.instance
          .collection('offers')
          .where('taskId', isEqualTo: taskId)
          .where('status', isEqualTo: 'accepted')
          .limit(1)
          .get();

      if (offersSnapshot.docs.isEmpty) {
        print('❌ No accepted offer found for task');
        return;
      }

      final offerDoc = offersSnapshot.docs.first;
      acceptedOffer.value = OfferModel.fromJson(
        offerDoc.data(),
        offerDoc.id, // 🔥 Pass docId as second parameter
      );

      print(
        '✅ Found accepted offer from: ${acceptedOffer.value?.offeringUserName}',
      );

      // Fetch helper user details
      if (acceptedOffer.value?.offeringUserUid != null) {
        await fetchHelperDetails(acceptedOffer.value!.offeringUserUid);
      }
    } catch (e) {
      print('❌ Error fetching accepted offer: $e');
    }
  }

  /// Fetch helper user details and stats
  Future<void> fetchHelperDetails(String helperUid) async {
    try {
      helperUser.value = await _userService.getUserByUid(helperUid);
      helperStats.value = await _userService.getUserStatistics(helperUid);

      print('✅ Fetched helper details: ${helperUser.value?.displayName}');
    } catch (e) {
      print('❌ Error fetching helper details: $e');
    }
  }

  /// Format budget
  String formatBudget(double? budget) {
    if (budget == null) return 'SAR 0';
    return 'SAR ${budget.toStringAsFixed(0)}';
  }

  /// Get time ago
  String getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
  }

  /// Get initials from name
  String getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// 🔥 Check if proof exists for this task
  Future<void> checkForProof(String taskId) async {
    try {
      final proofSnapshot = await FirebaseFirestore.instance
          .collection('task_proofs')
          .where('taskId', isEqualTo: taskId)
          .orderBy('submittedAt', descending: true) // 🔥 Get latest first
          .limit(5) // 🔥 Get top 5 to find one with images
          .get();

      hasProof.value = proofSnapshot.docs.isNotEmpty;

      if (hasProof.value) {
        // 🔥 Try to find a proof with images
        QueryDocumentSnapshot<Map<String, dynamic>>? proofWithImages;

        for (var doc in proofSnapshot.docs) {
          final data = doc.data();
          if (data['beforePhotoUrl'] != null && data['afterPhotoUrl'] != null) {
            proofWithImages = doc;
            break;
          }
        }

        // Use proof with images if found, otherwise use the latest one
        final selectedProof = proofWithImages ?? proofSnapshot.docs.first;

        proofId.value = selectedProof.id;
        final proofData = selectedProof.data();
        print('✅ Proof found for task: $taskId, proofId: ${proofId.value}');
        print(
          '   Has images: ${proofData['beforePhotoUrl'] != null && proofData['afterPhotoUrl'] != null}',
        );
      } else {
        print('❌ No proof found for task: $taskId');
      }
    } catch (e) {
      print('❌ Error checking for proof: $e');
      hasProof.value = false;
    }
  }
}
