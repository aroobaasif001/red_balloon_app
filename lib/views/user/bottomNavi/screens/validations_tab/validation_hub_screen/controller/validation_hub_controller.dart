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
    _streamValidations();
  }

  // Stream validations from Firestore
  void _streamValidations() {
    isLoading.value = true;

    // 🔥 Stream changes where isVotingCompleted is false
    _firestore
        .collection('validations')
        .where('isVotingCompleted', isEqualTo: false)
        .snapshots()
        .listen((snapshot) async {
          
      final List<Map<String, dynamic>> fetchedValidations = [];

      for (var doc in snapshot.docs) {
        final validationData = doc.data();
        final taskId = validationData['taskId'];
        final rejectedBy = validationData['rejectedBy']; // UID

        // Fetch user data
        String userId = 'RB-00000';
        if (rejectedBy != null && rejectedBy.isNotEmpty) {
          try {
             // Optimize: You might consider caching user data if fetching repeatedly
            final userDoc = await _firestore.collection('users').doc(rejectedBy).get();
            if (userDoc.exists) {
              userId = userDoc.data()?['userId'] ?? 'RB-00000';
            }
          } catch (e) {
            print('Error fetching user data: $e');
          }
        }

        // Fetch task details
        if (taskId != null) {
          try {
            // Similarly, consider caching task details
            final taskData = await _taskService.getTaskById(taskId);
            if (taskData != null) {
              fetchedValidations.add({
                'validationId': doc.id,
                'taskId': taskId,
                'taskTitle': taskData['title'] ?? 'No Title',
                'userId': userId,
                'beforePhotoUrl': validationData['beforePhotoUrl'] ?? '',
                'afterPhotoUrl': validationData['afterPhotoUrl'] ?? '',
                'proofId': validationData['proofId'] ?? '',
                'status': validationData['status'] ?? 'pending',
                'rejectedAt': validationData['rejectedAt'] ?? '',
              });
            }
          } catch(e) {
             print('Error fetching task details: $e');
          }
        }
      }

      validations.value = fetchedValidations;
      isLoading.value = false;
      
    }, onError: (error) {
       print('Error streaming validations: $error');
       isLoading.value = false;
    });
  }
}
