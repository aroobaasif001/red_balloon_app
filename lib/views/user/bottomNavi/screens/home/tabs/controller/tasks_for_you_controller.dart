import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/services/task_service.dart';

class TasksForYouController extends GetxController {
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable list for tasks
  RxList<TaskModel> tasksForYou = <TaskModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxString errorMessage = ''.obs;

  // For triggering UI updates
  RxInt updateTrigger = 0.obs;

  @override
  void onInit() {
    super.onInit();
    startRealTimeUpdates();
    startAutoRefreshTimer();
  }

  @override
  void onClose() {
    // Timers are automatically cancelled by GetX
    super.onClose();
  }

  /// Start auto-refresh timer based on time intervals
  void startAutoRefreshTimer() {
    // Refresh every 30 seconds to update time ago text
    // This covers seconds, minutes, hours, and days efficiently
    ever(tasksForYou, (_) {
      // Cancel existing timer if any
      if (Get.isRegistered<Timer>()) {
        Get.delete<Timer>();
      }

      // Start new timer
      Future.delayed(Duration(seconds: 30), () {
        if (tasksForYou.isNotEmpty) {
          updateTrigger.value++;
        }
      });
    });

    // Also set up a periodic timer for continuous updates
    Future.delayed(Duration(seconds: 30), () {
      _setupPeriodicTimer();
    });
  }

  /// Setup periodic timer for continuous updates
  void _setupPeriodicTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 30));
      if (tasksForYou.isNotEmpty) {
        updateTrigger.value++;
      }
      return true; // Continue looping
    });
  }

  /// Start real-time stream of tasks
  void startRealTimeUpdates() {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        errorMessage.value = 'User not authenticated';
        isLoading.value = false;
        return;
      }

      // Listen to all tasks stream
      _taskService.streamAllTasks().listen(
        (allTasks) {
          // Filter: tasks where uid != current user's uid
          final filteredTasks = allTasks
              .where((task) => task.uid != currentUserId)
              .toList();

          // Limit to 4 latest tasks
          tasksForYou.value = filteredTasks.take(4).toList();
          isLoading.value = false;
          errorMessage.value = '';
        },
        onError: (error) {
          errorMessage.value = 'Error fetching tasks: $error';
          isLoading.value = false;
          print('Error in startRealTimeUpdates: $error');
        },
      );
    } catch (e) {
      errorMessage.value = 'Error setting up real-time updates: $e';
      isLoading.value = false;
      print('Error in startRealTimeUpdates: $e');
    }
  }

  /// Pull to refresh - fetch latest tasks
  Future<void> refreshTasks() async {
    try {
      isRefreshing.value = true;
      errorMessage.value = '';

      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        errorMessage.value = 'User not authenticated';
        isRefreshing.value = false;
        return;
      }

      // Get all tasks
      final allTasks = await _taskService.getAllTasks();

      // Filter: tasks where uid != current user's uid
      final filteredTasks = allTasks
          .where((task) => task.uid != currentUserId)
          .toList();

      // Limit to 4 latest tasks
      tasksForYou.value = filteredTasks.take(4).toList();

      isRefreshing.value = false;
    } catch (e) {
      errorMessage.value = 'Error refreshing tasks: $e';
      isRefreshing.value = false;
      print('Error in refreshTasks: $e');
    }
  }

  /// Get placeholder image when imageUrl is null
  String getImageUrl(TaskModel task) {
    if (task.imageUrl != null && task.imageUrl!.isNotEmpty) {
      return task.imageUrl!;
    }
    // Return default placeholder based on task type
    if (task.taskType == 'Offline Task') {
      return 'assets/icons/chair.png';
    }
    return 'assets/icons/chair.png';
  }

  /// Format time ago from createdAt
  String getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  /// Format budget with currency
  String formatBudget(double budget) {
    return 'SAR ${budget.toStringAsFixed(0)}';
  }
}
