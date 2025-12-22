import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_balloon_app/model/task_model.dart';

class AdminValidationTasksController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var validationTasks = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('🚀 AdminValidationTasksController onInit called');
    fetchValidationTasks();
  }

  /// Fetch validation tasks from Firestore
  Future<void> fetchValidationTasks() async {
    try {
      isLoading.value = true;
      print('🔍 Fetching validation tasks from Firestore...');

      // Fetch ALL validations where sentToAdmin is true
      final validationsSnapshot = await _firestore
          .collection('validations')
          .where('sentToAdmin', isEqualTo: true)
          .get();

      print('📊 Found ${validationsSnapshot.docs.length} validations referred to Admin');

      if (validationsSnapshot.docs.isEmpty) {
        print('⚠️ No validations found in database');
        validationTasks.value = [];
        isLoading.value = false;
        return;
      }

      final List<Map<String, dynamic>> fetchedValidations = [];

      for (var validationDoc in validationsSnapshot.docs) {
        try {
          final validationData = validationDoc.data();
          final taskId = validationData['taskId'];

          if (taskId != null) {
            // Fetch task details
            final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
            
            if (taskDoc.exists) {
              final task = TaskModel.fromFirestore(taskDoc);
              
              // Calculate time since rejection
              DateTime? rejectedAt;
              if (validationData['rejectedAt'] != null) {
                if (validationData['rejectedAt'] is String) {
                  rejectedAt = DateTime.parse(validationData['rejectedAt']);
                } else {
                  rejectedAt = (validationData['rejectedAt'] as Timestamp).toDate();
                }
              }

              fetchedValidations.add({
                'validationId': validationDoc.id,
                'taskId': taskId,
                'title': task.title,
                'budget': task.budget,
                'location': task.location,
                'imageUrl': task.imageUrl,
                'rejectedAt': rejectedAt,
                'status': validationData['status'] ?? 'pending',
                'rejectionReason': validationData['rejectionReason'],
              });

              print('✅ Loaded validation task: ${task.title}');
            }
          }
        } catch (e) {
          print('❌ Error parsing validation ${validationDoc.id}: $e');
        }
      }

      // Sort by rejectedAt (newest first)
      fetchedValidations.sort((a, b) {
        final aTime = a['rejectedAt'] as DateTime?;
        final bTime = b['rejectedAt'] as DateTime?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });

      validationTasks.value = fetchedValidations;
      print('✅ Successfully loaded ${validationTasks.length} validation tasks');

      isLoading.value = false;
    } catch (e) {
      print('❌ Error fetching validation tasks: $e');
      print('Stack trace: ${StackTrace.current}');
      validationTasks.value = [];
      isLoading.value = false;
    }
  }

  String getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Started ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return 'Started ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return 'Started ${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Started just now';
    }
  }
}
