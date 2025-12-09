import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/task_model.dart';

class AdminDisputesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  var isLoading = false.obs;
  var disputedTasks = <TaskModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchDisputedTasks();
  }
  
  /// Fetch all tasks with status 'disputed'
  Future<void> fetchDisputedTasks() async {
    try {
      isLoading.value = true;
      print('🔍 Fetching disputed tasks...');
      
      final snapshot = await _firestore
          .collection('tasks')
          .where('status', isEqualTo: 'Disputed')
          .get();
      
      print('📊 Found ${snapshot.docs.length} disputed tasks');
      
      final List<TaskModel> tasks = [];
      for (var doc in snapshot.docs) {
        try {
          final task = TaskModel.fromFirestore(doc);
          tasks.add(task);
          print('✅ Loaded task: ${task.title} (${task.id})');
        } catch (e) {
          print('❌ Error parsing task ${doc.id}: $e');
        }
      }
      
      disputedTasks.value = tasks;
      isLoading.value = false;
      print('✅ Loaded ${tasks.length} disputed tasks');
    } catch (e) {
      print('❌ Error fetching disputed tasks: $e');
      isLoading.value = false;
    }
  }
  
  /// Format budget to display
  String formatBudget(int budget) {
    return 'SAR $budget';
  }
  
  /// Calculate time ago from DateTime
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
