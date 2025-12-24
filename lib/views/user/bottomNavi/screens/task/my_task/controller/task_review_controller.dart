import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../../../../services/notification_services.dart';
import '../../../../../../../services/wallet_service.dart';

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

  // 🔥 Task and proof data
  var isLoading = true.obs;
  var isSubmitting = false.obs; // 🔥 Loading state for submission
  var taskTitle = ''.obs;
  var helperName = ''.obs;
  var helperInitial = ''.obs;
  var helperPhotoUrl = ''.obs; // 🔥 Helper's photo URL
  var helperId = ''.obs; // 🔥 Helper's UID
  var location = ''.obs;
  var submittedTime = ''.obs;
  var beforeImageUrl = ''.obs;
  var afterImageUrl = ''.obs;
  
  // 🔥 Current IDs for auto-rejection
  String? currentTaskId;
  String? currentProofId;

  // 🔥 Callback for navigation after submission
  Function()? onSubmissionComplete;

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

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        // 🔥 Auto-move to validation if no action taken
        print('⏰ Timer expired - Checking task status before auto validation');
        
        if (currentTaskId != null && currentProofId != null && !isSubmitting.value) {
          // 🔥 Check if task status has already changed
          try {
            final taskDoc = await FirebaseFirestore.instance
                .collection('tasks')
                .doc(currentTaskId!)
                .get();
            
            if (taskDoc.exists) {
              final taskStatus = taskDoc.data()?['status'] ?? '';
              
              // 🔥 Only auto-reject if task is still "in progress"
              if (taskStatus.toLowerCase() == 'in progress') {
                print('⏰ Task still in progress - Auto-rejecting to validation');
                selectedRejectionReason.value = 'Work not completed'; // Default reason
                submitRejection(taskId: currentTaskId!, proofId: currentProofId!);
              } else {
                print('✅ Task status already changed to "$taskStatus" - Skipping auto-validation');
              }
            }
          } catch (e) {
            print('❌ Error checking task status: $e');
          }
        }
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
      // 🔥 Cancel timer immediately to prevent auto-validation
      _timer?.cancel();
      
      isSubmitting.value = true; // 🔥 Show loading

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('❌ No user logged in');
        isSubmitting.value = false;
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
        'beforePhotoUrl': beforeImageUrl.value, // 🔥 Add before image
        'afterPhotoUrl': afterImageUrl.value, // 🔥 Add after image
        'isVotingCompleted':
            false, // 🔥 Initially false, will be true when voting reaches threshold
      });

      print('✅ Added to validations collection');

      // 2. Update task status to rejected
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'status': 'rejected',
      });

      print('✅ Task status updated to rejected');

      // 3. Update proof status to rejected
      await FirebaseFirestore.instance
          .collection('task_proofs')
          .doc(proofId)
          .update({'status': 'rejected'});

      print('✅ Proof status updated to rejected');

      Get.snackbar('Success', 'Rejection submitted successfully');

      // 🔥 Trigger Notifications
      if (helperId.value.isNotEmpty) {
        final ownerName = currentUser.displayName ?? 'Owner';
        
        await NotificationService.instance.notifyProofRejected(
          helperId: helperId.value.trim(),
          taskTitle: taskTitle.value,
          taskId: taskId,
          rejectedByName: ownerName,
        );
      }
      
      // 🔥 Broadcast to all users (EXCLUDING helper and current owner)
      await NotificationService.instance.broadcastValidationTask(
        taskTitle: taskTitle.value,
        taskId: taskId,
        excludeUserIds: [currentUser.uid.trim(), helperId.value.trim()],
      );

      // 🔥 Trigger navigation callback
      if (onSubmissionComplete != null) {
        await Future.delayed(Duration(milliseconds: 500));
        isSubmitting.value = false; // 🔥 Hide loading
        onSubmissionComplete!();
      }
    } catch (e) {
      print('❌ Error submitting rejection: $e');
      isSubmitting.value = false; // 🔥 Hide loading on error
      Get.snackbar('Error', 'Failed to submit rejection');
    }
  }

  /// 🔥 Accept proof
  Future<void> acceptProof({
    required String taskId,
    required String proofId,
  }) async {
    try {
      // 🔥 Cancel timer immediately to prevent auto-validation
      _timer?.cancel();
      
      isSubmitting.value = true; // 🔥 Show loading

      // 1. Fetch task details to get budget and requester UID
      final taskDoc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (!taskDoc.exists) {
        throw 'Task not found';
      }

      final taskData = taskDoc.data()!;
      final double budget = (taskData['budget'] ?? 0.0).toDouble();
      final String requesterUid = taskData['uid'] ?? '';
      final String title = taskData['title'] ?? 'Task';

      if (requesterUid.isEmpty) {
        throw 'Requester UID not found';
      }

      // 2. Distribute funds via WalletService
      final walletService = WalletService();
      final walletResult = await walletService.releaseEscrowToHelper(
        taskId: taskId,
        requesterUid: requesterUid,
        helperUid: helperId.value,
        totalAmount: budget,
        taskTitle: title,
      );

      if (!walletResult['success']) {
        throw walletResult['message'] ?? 'Failed to distribute funds';
      }

      // 3. Update task status to completed
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      // 4. Update proof status to accepted
      await FirebaseFirestore.instance
          .collection('task_proofs')
          .doc(proofId)
          .update({
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Proof accepted and funds distributed successfully');

      Get.snackbar('Success', 'Proof accepted and payment released!');

      // 5. 🔥 Trigger Notifications
      if (helperId.value.isNotEmpty) {
        // General proof accepted notification
        NotificationService.instance.notifyProofAccepted(
          helperId: helperId.value,
          taskTitle: taskTitle.value,
          taskId: taskId,
        );

        // Specific payment received notification (Includes amount)
        NotificationService.instance.notifyPaymentReceived(
          helperId: helperId.value,
          taskTitle: taskTitle.value,
          taskId: taskId,
          amount: walletResult['helperAmount'] ?? (budget * 0.85),
        );
      }

      // 🔥 Trigger navigation callback
      if (onSubmissionComplete != null) {
        await Future.delayed(Duration(milliseconds: 500));
        isSubmitting.value = false; // 🔥 Hide loading
        onSubmissionComplete!();
      }
    } catch (e) {
      print('❌ Error accepting proof: $e');
      isSubmitting.value = false; // 🔥 Hide loading on error
      Get.snackbar('Error', 'Failed to accept proof: ${e.toString()}');
    }
  }

  /// 🔥 Fetch task and proof data
  Future<void> fetchTaskAndProofData({
    required String taskId,
    required String proofId,
  }) async {
    try {
      isLoading.value = true;
      currentTaskId = taskId;
      currentProofId = proofId;

      // 1. Fetch task details
      final taskDoc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskDoc.exists) {
        final taskData = taskDoc.data()!;
        taskTitle.value = taskData['title'] ?? 'No Title';
        location.value = taskData['location'] ?? 'Unknown';

        // 2. Fetch helper details from accepted offer
        final offersQuery = await FirebaseFirestore.instance
            .collection('offers')
            .where('taskId', isEqualTo: taskId)
            .where('status', isEqualTo: 'accepted')
            .limit(1)
            .get();

        if (offersQuery.docs.isNotEmpty) {
          final offerData = offersQuery.docs.first.data();
          helperName.value = offerData['offeringUserName'] ?? 'Unknown Helper';
          helperPhotoUrl.value =
              offerData['offeringUserPhoto'] ?? ''; // 🔥 Get helper photo
          helperId.value = offerData['offeringUserUid'] ?? ''; // 🔥 Get helper UID

          // Get first letter for initial
          if (helperName.value.isNotEmpty &&
              helperName.value != 'Unknown Helper') {
            helperInitial.value = helperName.value[0].toUpperCase();
          } else {
            helperInitial.value = 'U';
          }

          // 🔥 Debug: Print helper info
          print('👤 Helper Name: ${helperName.value}');
          print('📸 Helper Photo URL: ${helperPhotoUrl.value}');
        }
      }

      // 3. Fetch proof details
      final proofDoc = await FirebaseFirestore.instance
          .collection('task_proofs')
          .doc(proofId)
          .get();

      if (proofDoc.exists) {
        final proofData = proofDoc.data()!;

        // 🔥 Debug: Print all proof data
        print('🔍 Proof Data Keys: ${proofData.keys.toList()}');
        print('🔍 Full Proof Data: $proofData');

        // 🔥 Try multiple possible field names for before image
        String? rawBeforeUrl =
            proofData['beforePhotoUrl'] ??
            proofData['beforeImageUrl'] ??
            proofData['before_photo_url'] ??
            proofData['beforePhoto'];

        // 🔥 Try multiple possible field names for after image
        String? rawAfterUrl =
            proofData['afterPhotoUrl'] ??
            proofData['afterImageUrl'] ??
            proofData['after_photo_url'] ??
            proofData['afterPhoto'];

        // 🔥 Clean and validate URLs
        beforeImageUrl.value = (rawBeforeUrl?.trim() ?? '').isEmpty
            ? ''
            : rawBeforeUrl!.trim();
        afterImageUrl.value = (rawAfterUrl?.trim() ?? '').isEmpty
            ? ''
            : rawAfterUrl!.trim();

        // 🔥 Debug: Print image URLs
        print('🖼️ Before Image URL: ${beforeImageUrl.value}');
        print('🖼️ After Image URL: ${afterImageUrl.value}');
        print('🖼️ Before Image Empty: ${beforeImageUrl.value.isEmpty}');
        print('🖼️ After Image Empty: ${afterImageUrl.value.isEmpty}');

        // Calculate submitted time
        try {
          final dynamic submittedAtData = proofData['submittedAt'];
          if (submittedAtData != null) {
            DateTime submittedDate;

            // Handle both Timestamp and String types
            if (submittedAtData is Timestamp) {
              submittedDate = submittedAtData.toDate();
            } else if (submittedAtData is String) {
              submittedDate = DateTime.parse(submittedAtData);
            } else {
              submittedDate = DateTime.now();
            }

            final Duration difference = DateTime.now().difference(
              submittedDate,
            );

            if (difference.inMinutes < 60) {
              submittedTime.value = '${difference.inMinutes} min ago';
            } else if (difference.inHours < 24) {
              submittedTime.value = '${difference.inHours} hours ago';
            } else {
              submittedTime.value = '${difference.inDays} days ago';
            }
          }
        } catch (e) {
          print('❌ Error parsing submittedAt: $e');
          submittedTime.value = 'Just now';
        }
      } else {
        print('❌ Proof document does not exist for proofId: $proofId');
      }

      isLoading.value = false;
      print('✅ Task and proof data loaded successfully');
    } catch (e) {
      print('❌ Error fetching task and proof data: $e');
      isLoading.value = false;
    }
  }
}
