import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_balloon_app/model/task_model.dart';

class AdminAllTasksController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var allTasks = <TaskModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('🚀 AdminAllTasksController onInit called');
    fetchAllTasks();
  }

  /// Fetch all tasks from Firestore
  Future<void> fetchAllTasks() async {
    try {
      isLoading.value = true;
      print('🔍 Fetching all tasks from Firestore...');

      // Remove orderBy to avoid index requirement
      final snapshot = await _firestore
          .collection('tasks')
          .get();

      print('📊 Found ${snapshot.docs.length} tasks in Firestore');

      if (snapshot.docs.isEmpty) {
        print('⚠️ No tasks found in database');
        allTasks.value = [];
        isLoading.value = false;
        return;
      }

      final List<TaskModel> fetchedTasks = [];
      
      for (var doc in snapshot.docs) {
        try {
          final task = TaskModel.fromFirestore(doc);
          fetchedTasks.add(task);
          print('✅ Loaded task: ${task.title}');
        } catch (e) {
          print('❌ Error parsing task ${doc.id}: $e');
        }
      }

      // Sort by createdAt in memory (newest first)
      fetchedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      allTasks.value = fetchedTasks;
      print('✅ Successfully loaded ${allTasks.length} tasks');
      
      isLoading.value = false;
    } catch (e) {
      print('❌ Error fetching all tasks: $e');
      print('Stack trace: ${StackTrace.current}');
      allTasks.value = [];
      isLoading.value = false;
    }
  }
}
