import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/services/task_service.dart';
import 'package:geolocator/geolocator.dart';

class TasksForYouController extends GetxController {
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable list for tasks
  RxList<TaskModel> tasksForYou = <TaskModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxString errorMessage = ''.obs;
  final RxMap<String, bool> userSuspensionStatus = <String, bool>{}.obs; // 🔥 Track suspension status
  final Rx<Position?> userPosition = Rx<Position?>(null); // 🔥 Track user location

  // For triggering UI updates
  RxInt updateTrigger = 0.obs;
  final Map<String, StreamSubscription> _suspensionSubscriptions = {}; // 🔥 Track real-time listeners

  @override
  void onInit() {
    super.onInit();
    _fetchUserLocation();
    startRealTimeUpdates();
    startAutoRefreshTimer();
  }

  /// 🔥 Fetch current user location
  Future<void> _fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        userPosition.value = position;
        print('📍 Home: User location fetched: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      print('❌ Home: Error fetching user location: $e');
    }
  }

  /// 🔥 Calculate distance to a task
  String? getDistanceToTask(double? taskLat, double? taskLon) {
    if (userPosition.value == null || taskLat == null || taskLon == null) {
      return null;
    }

    try {
      final distanceInMeters = Geolocator.distanceBetween(
        userPosition.value!.latitude,
        userPosition.value!.longitude,
        taskLat,
        taskLon,
      );

      if (distanceInMeters < 1000) {
        return '${distanceInMeters.toStringAsFixed(0)}m away';
      } else {
        final distanceInKm = distanceInMeters / 1000;
        return '${distanceInKm.toStringAsFixed(1)} km away';
      }
    } catch (e) {
      print('❌ Home: Error calculating distance: $e');
      return null;
    }
  }

  @override
  void onClose() {
    // 🔥 Cancel all suspension listeners
    for (var sub in _suspensionSubscriptions.values) {
      sub.cancel();
    }
    _suspensionSubscriptions.clear();
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
          // Filter tasks near me (created by other users, not completed/cancelled)
          final filteredTasks = allTasks.where((task) {
            final isOtherUser = task.uid != currentUserId;
            final status = task.status.toLowerCase();
            final isActive = status != 'completed' &&
                status != 'cancelled' &&
                status != 'disputed' &&
                status != 'rejected';
            return isOtherUser && isActive;
          }).toList();

          // 🔥 Sync suspension listeners for all task owners
          _syncSuspensionListeners(allTasks);

          tasksForYou.value = filteredTasks;
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

      // Filter tasks near me (created by other users, not completed/cancelled)
      final filteredTasks = allTasks.where((task) {
        final isOtherUser = task.uid != currentUserId;
        final status = task.status.toLowerCase();
        final isActive = status != 'completed' &&
            status != 'cancelled' &&
            status != 'disputed' &&
            status != 'rejected';
        return isOtherUser && isActive;
      }).toList();

      tasksForYou.value = filteredTasks;

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

  /// Format budget with currency
  String formatBudget(double budget) {
    return 'SAR ${budget.toStringAsFixed(0)}';
  }

  /// 🔥 Sync suspension listeners for a list of tasks
  void _syncSuspensionListeners(List<TaskModel> tasks) {
    for (var task in tasks) {
      final ownerUid = task.uid;
      if (!_suspensionSubscriptions.containsKey(ownerUid)) {
        print('📡 TasksForYouController: Starting suspension listener for $ownerUid');
        _suspensionSubscriptions[ownerUid] = _taskService.firestore
            .collection('users')
            .doc(ownerUid)
            .snapshots()
            .listen((doc) {
          if (doc.exists) {
            final isSuspended = doc.data()?['willLogin'] == false;
            userSuspensionStatus[ownerUid] = isSuspended;
          }
        });
      }
    }
  }

  /// 🔥 Public getter for suspension status
  bool isUserSuspended(String uid) {
    return userSuspensionStatus[uid] ?? false;
  }
}
