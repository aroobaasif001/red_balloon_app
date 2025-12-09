import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/task_service.dart';

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
    } catch (e) {
      print('Error checking proof: $e');
      hasProof.value = false;
    } finally {
      isCheckingProof.value = false;
    }
  }

  // Help Request Status for Helper view
  RxBool requesterHelpRequested = false.obs;
  RxBool helperHelpRequested = false.obs;
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
  }
}
