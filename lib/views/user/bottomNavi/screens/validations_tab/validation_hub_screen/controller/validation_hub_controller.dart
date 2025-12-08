import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/task_service.dart';

class ValidationHubController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TaskService _taskService = TaskService();

  RxList<Map<String, dynamic>> validations = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchValidations();
  }

  // Fetch validations from Firestore
  Future<void> fetchValidations() async {
    try {
      isLoading.value = true;

      // 🔥 Only fetch validations where isVotingCompleted is false
      final snapshot = await _firestore
          .collection('validations')
          .where('isVotingCompleted', isEqualTo: false)
          .get();

      final List<Map<String, dynamic>> fetchedValidations = [];

      for (var doc in snapshot.docs) {
        final validationData = doc.data();
        final taskId = validationData['taskId'];
        final rejectedBy = validationData['rejectedBy']; // UID of user who rejected

        // Fetch userId from users collection using rejectedBy UID
        String userId = 'RB-00000'; // Default
        if (rejectedBy != null && rejectedBy.isNotEmpty) {
          try {
            final userDoc = await _firestore
                .collection('users')
                .doc(rejectedBy)
                .get();
            
            if (userDoc.exists) {
              final userData = userDoc.data();
              userId = userData?['userId'] ?? 'RB-00000';
            }
          } catch (e) {
            print('Error fetching user data: $e');
          }
        }

        // Fetch task details using taskId
        if (taskId != null) {
          final taskData = await _taskService.getTaskById(taskId);
          if (taskData != null) {
            fetchedValidations.add({
              'validationId': doc.id,
              'taskId': taskId,
              'taskTitle': taskData['title'] ?? 'No Title',
              'userId': userId, // From users collection
              'beforePhotoUrl': validationData['beforePhotoUrl'] ?? '',
              'afterPhotoUrl': validationData['afterPhotoUrl'] ?? '',
              'proofId': validationData['proofId'] ?? '',
              'status': validationData['status'] ?? 'pending',
            });
          }
        }
      }

      validations.value = fetchedValidations;
      isLoading.value = false;
    } catch (e) {
      print('Error fetching validations: $e');
      isLoading.value = false;
    }
  }
}
