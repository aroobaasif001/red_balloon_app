import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/services/task_service.dart';

class TasksController extends GetxController {
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable lists
  final RxList<TaskModel> myTasks = <TaskModel>[].obs;
  final RxList<TaskModel> tasksNearMe = <TaskModel>[].obs;
  final RxList<TaskModel> historyTasks =
      <TaskModel>[].obs; // 🔥 NEW: For completed/cancelled tasks

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

  // Flag for initial load delay
  bool _isFirstLoad = true;

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

      // Allow UI to show loader initially
      isLoadingMyTasks.value = true;
      isLoadingTasksNearMe.value = true;
      isLoadingHistoryTasks.value = true;

      // Listen to all tasks stream for real-time updates
      _taskService.streamAllTasks().listen(
        (allTasks) async {
          // 🔥 Enforce minimum 1 second delay on first load
          if (_isFirstLoad) {
            await Future.delayed(const Duration(seconds: 1));
            _isFirstLoad = false;
          }

          // Filter my tasks (created by current user, not completed/cancelled)
          myTasks.value = allTasks.where((task) {
            final isMyTask = task.uid == currentUserId;
            final status = task.status.toLowerCase();
            final isActive =
                status != 'completed' &&
                status != 'cancelled' &&
                status != 'disputed' &&
                status != 'rejected';
            return isMyTask && isActive;
          }).toList();

          // Filter tasks near me (created by other users, not completed/cancelled)
          tasksNearMe.value = allTasks.where((task) {
            final isOtherUser = task.uid != currentUserId;
            final status = task.status.toLowerCase();
            final isActive =
                status != 'completed' &&
                status != 'cancelled' &&
                status != 'disputed' &&
                status != 'rejected';
            return isOtherUser && isActive;
          }).toList();

          // Filter history tasks (completed, cancelled, or rejected)
          // Include tasks where:
          // 1. User is the task owner (requester)
          // 2. User is the helper (acceptedOfferUid matches)
          historyTasks.value = allTasks.where((task) {
            final isMyTask = task.uid == currentUserId;
            final isHelper = task.acceptedOfferUid == currentUserId;
            final status = task.status.toLowerCase();
            final isHistory =
                status == 'completed' ||
                status == 'cancelled' ||
                status == 'rejected' ||
                status == 'disputed';
            return (isMyTask || isHelper) && isHistory;
          }).toList();

          isLoadingMyTasks.value = false;
          isLoadingTasksNearMe.value = false;
          isLoadingHistoryTasks.value = false;

          print(
            '✅ Real-time update: My Tasks: ${myTasks.length}, Tasks Near Me: ${tasksNearMe.length}, History: ${historyTasks.length}',
          );
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
  Future<void> fetchAllTasks({Duration minDelay = Duration.zero}) async {
    await Future.wait([
      fetchMyTasks(minDelay: minDelay), 
      fetchTasksNearMe(minDelay: minDelay)
    ]);
  }

  /// Fetch tasks created by current user
  Future<void> fetchMyTasks({Duration minDelay = Duration.zero}) async {
    try {
      isLoadingMyTasks.value = true;
      
      final delayFuture = Future.delayed(minDelay);

      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        print('❌ User not authenticated');
        myTasks.clear();
        return;
      }

      print('🔍 Current User UID: $currentUserId');

      // Fetch tasks where uid matches current user
      final tasksFuture = _taskService.getUserTasks(currentUserId);
      
      await Future.wait([delayFuture, tasksFuture]);
      final tasks = await tasksFuture;

      // Debug: Print each task's UID
      print('📋 Total tasks fetched from getUserTasks: ${tasks.length}');
      for (var task in tasks) {
        print(
          '  Task: "${task.title}" | UID: ${task.uid} | Status: ${task.status} | Match: ${task.uid == currentUserId}',
        );
      }

      // Filter to show only active tasks (not completed, cancelled, or rejected)
      myTasks.value = tasks.where((task) {
        final status = task.status.toLowerCase();
        return status != 'completed' &&
            status != 'cancelled' &&
            status != 'rejected' &&
            status != 'disputed';
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
  Future<void> fetchTasksNearMe({Duration minDelay = Duration.zero}) async {
    try {
      isLoadingTasksNearMe.value = true;
      
      final delayFuture = Future.delayed(minDelay);

      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        print('❌ User not authenticated for Tasks Near Me');
        tasksNearMe.clear();
        return;
      }

      print('🔍 Fetching Tasks Near Me for User: $currentUserId');

      // Fetch all tasks
      final allTasksFuture = _taskService.getAllTasks();
      
      await Future.wait([delayFuture, allTasksFuture]);
      final allTasks = await allTasksFuture;

      print('📋 Total tasks in database: ${allTasks.length}');

      // Filter out current user's tasks to show only other users' tasks
      tasksNearMe.value = allTasks.where((task) {
        final isOtherUser = task.uid != currentUserId;
        print(
          '  Task: "${task.title}" | UID: ${task.uid} | Is Other User: $isOtherUser',
        );
        return isOtherUser;
      }).toList();

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
  Future<void> fetchHistoryTasks({Duration minDelay = Duration.zero}) async {
    try {
      isLoadingHistoryTasks.value = true;
      
      final delayFuture = Future.delayed(minDelay);

      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        print('❌ User not authenticated for History Tasks');
        historyTasks.clear();
        return;
      }

      print('🔍 Fetching History Tasks for User: $currentUserId');

      // Fetch ALL tasks (not just user's tasks)
      final allTasksFuture = _taskService.getAllTasks();
      
      await Future.wait([delayFuture, allTasksFuture]);
      final allTasks = await allTasksFuture;

      print('📋 Total tasks in database: ${allTasks.length}');

      // Filter to show completed/cancelled/rejected tasks where user is either:
      // 1. Task owner (requester)
      // 2. Helper (acceptedOfferUid matches)
      historyTasks.value = allTasks.where((task) {
        final isMyTask = task.uid == currentUserId;
        final isHelper = task.acceptedOfferUid == currentUserId;
        final status = task.status.toLowerCase();
        final isHistory =
            status == 'completed' ||
            status == 'cancelled' ||
            status == 'rejected' ||
            status == 'disputed';
        final shouldInclude = (isMyTask || isHelper) && isHistory;

        if (shouldInclude) {
          print(
            '  ✅ Task: "${task.title}" | Status: ${task.status} | Role: ${isMyTask ? "Requester" : "Helper"}',
          );
        }

        return shouldInclude;
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
  Future<void> refreshTasks({Duration minDelay = Duration.zero}) async {
    await fetchAllTasks(minDelay: minDelay);
    await fetchHistoryTasks(minDelay: minDelay);
  }

  /// Get time ago string from DateTime
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months m ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min ago';
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
