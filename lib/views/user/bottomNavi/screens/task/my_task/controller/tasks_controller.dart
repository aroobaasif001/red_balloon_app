import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/services/task_service.dart';

class TasksController extends GetxController {
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable lists
  final RxList<TaskModel> myTasks = <TaskModel>[].obs;
  final RxList<TaskModel> tasksNearMe = <TaskModel>[].obs;
  final RxList<TaskModel> historyTasks = <TaskModel>[].obs; // 🔥 NEW: For completed/cancelled tasks
  
  // Loading states
  final RxBool isLoadingMyTasks = false.obs;
  final RxBool isLoadingTasksNearMe = false.obs;
  final RxBool isLoadingHistoryTasks = false.obs; // 🔥 NEW

  // For triggering UI updates
  RxInt updateTrigger = 0.obs;

  @override
  void onInit() {
    super.onInit();
    print('🚀 TasksController initialized');
    print('👤 Current User: ${_auth.currentUser?.uid ?? "NOT LOGGED IN"}');
    print('📧 Email: ${_auth.currentUser?.email ?? "N/A"}');
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
    ever(myTasks, (_) {
      // Cancel existing timer if any
      if (Get.isRegistered<Timer>()) {
        Get.delete<Timer>();
      }

      // Start new timer
      Future.delayed(Duration(seconds: 30), () {
        if (myTasks.isNotEmpty || tasksNearMe.isNotEmpty) {
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
      if (myTasks.isNotEmpty || tasksNearMe.isNotEmpty) {
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
        print('❌ User not authenticated');
        isLoadingMyTasks.value = false;
        isLoadingTasksNearMe.value = false;
        return;
      }

      // Listen to all tasks stream for real-time updates
      _taskService.streamAllTasks().listen(
        (allTasks) {
          // Filter my tasks (created by current user, not completed/cancelled)
          myTasks.value = allTasks
              .where((task) {
                final isMyTask = task.uid == currentUserId;
                final status = task.status.toLowerCase();
                final isActive = status != 'completed' && status != 'cancelled';
                return isMyTask && isActive;
              })
              .toList();

          // Filter tasks near me (created by other users, not completed/cancelled)
          tasksNearMe.value = allTasks
              .where((task) {
                final isOtherUser = task.uid != currentUserId;
                final status = task.status.toLowerCase();
                final isActive = status != 'completed' && status != 'cancelled';
                return isOtherUser && isActive;
              })
              .toList();

          // Filter history tasks (completed or cancelled)
          historyTasks.value = allTasks
              .where((task) {
                final isMyTask = task.uid == currentUserId;
                final status = task.status.toLowerCase();
                final isHistory = status == 'completed' || status == 'cancelled' || status == 'rejected';
                return isMyTask && isHistory;
              })
              .toList();

          isLoadingMyTasks.value = false;
          isLoadingTasksNearMe.value = false;
          isLoadingHistoryTasks.value = false;

          print('✅ Real-time update: My Tasks: ${myTasks.length}, Tasks Near Me: ${tasksNearMe.length}, History: ${historyTasks.length}');
        },
        onError: (error) {
          print('❌ Error in real-time updates: $error');
          isLoadingMyTasks.value = false;
          isLoadingTasksNearMe.value = false;
          isLoadingHistoryTasks.value = false;
        },
      );
    } catch (e) {
      print('❌ Error setting up real-time updates: $e');
      isLoadingMyTasks.value = false;
      isLoadingTasksNearMe.value = false;
      isLoadingHistoryTasks.value = false;
    }
  }

  /// Fetch all tasks (both my tasks and tasks near me)
  Future<void> fetchAllTasks() async {
    await Future.wait([
      fetchMyTasks(),
      fetchTasksNearMe(),
    ]);
  }

  /// Fetch tasks created by current user
  Future<void> fetchMyTasks() async {
    try {
      isLoadingMyTasks.value = true;
      
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        print('❌ User not authenticated');
        myTasks.clear();
        return;
      }

      print('🔍 Current User UID: $currentUserId');

      // Fetch tasks where uid matches current user
      final tasks = await _taskService.getUserTasks(currentUserId);
      
      // Debug: Print each task's UID
      print('📋 Total tasks fetched from getUserTasks: ${tasks.length}');
      for (var task in tasks) {
        print('  Task: "${task.title}" | UID: ${task.uid} | Status: ${task.status} | Match: ${task.uid == currentUserId}');
      }
      
      // Filter to show only active tasks (not completed, cancelled, or rejected)
      myTasks.value = tasks.where((task) {
        final status = task.status.toLowerCase();
        return status != 'completed' && status != 'cancelled' && status != 'rejected';
      }).toList();
      
      print('✅ My Tasks Count (Active only): ${myTasks.length}');
    } catch (e) {
      print('❌ Error fetching my tasks: $e');
      Get.snackbar(
        'Error',
        'Failed to load your tasks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMyTasks.value = false;
    }
  }

  /// Fetch tasks created by other users (tasks near me)
  Future<void> fetchTasksNearMe() async {
    try {
      isLoadingTasksNearMe.value = true;
      
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        print('❌ User not authenticated for Tasks Near Me');
        tasksNearMe.clear();
        return;
      }

      print('🔍 Fetching Tasks Near Me for User: $currentUserId');

      // Fetch all tasks
      final allTasks = await _taskService.getAllTasks();
      
      print('📋 Total tasks in database: ${allTasks.length}');
      
      // Filter out current user's tasks to show only other users' tasks
      tasksNearMe.value = allTasks
          .where((task) {
            final isOtherUser = task.uid != currentUserId;
            print('  Task: "${task.title}" | UID: ${task.uid} | Is Other User: $isOtherUser');
            return isOtherUser;
          })
          .toList();
      
      print('✅ Tasks Near Me Count: ${tasksNearMe.length}');
    } catch (e) {
      print('❌ Error fetching tasks near me: $e');
      Get.snackbar(
        'Error',
        'Failed to load tasks near you',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingTasksNearMe.value = false;
    }
  }

  /// Fetch history tasks (completed and cancelled) for current user
  Future<void> fetchHistoryTasks() async {
    try {
      isLoadingHistoryTasks.value = true;
      
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        print('❌ User not authenticated for History Tasks');
        historyTasks.clear();
        return;
      }

      print('🔍 Fetching History Tasks for User: $currentUserId');

      // Fetch all user's tasks
      final allUserTasks = await _taskService.getUserTasks(currentUserId);
      
      print('📋 Total user tasks: ${allUserTasks.length}');
      
      // Filter to show only completed or cancelled tasks
      historyTasks.value = allUserTasks.where((task) {
        final status = task.status.toLowerCase();
        final isHistory = status == 'completed' || status == 'cancelled' || status == 'rejected';
        print('  Task: "${task.title}" | Status: ${task.status} | Is History: $isHistory');
        return isHistory;
      }).toList();
      
      print('✅ History Tasks Count: ${historyTasks.length}');
    } catch (e) {
      print('❌ Error fetching history tasks: $e');
      Get.snackbar(
        'Error',
        'Failed to load history tasks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHistoryTasks.value = false;
    }
  }

  /// Refresh all tasks
  Future<void> refreshTasks() async {
    await fetchAllTasks();
    await fetchHistoryTasks(); // 🔥 Also refresh history
  }

  /// Get time ago string from DateTime
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format budget to display with currency
  String formatBudget(double budget) {
    return 'SAR ${budget.toStringAsFixed(0)}';
  }

  /// Get status display text
  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Not accepted';
      case 'accepted':
        return 'Accepted';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
