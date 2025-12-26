import 'dart:async';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/user_model.dart';
import 'package:red_balloon_app/services/user_service.dart';

class UserManagementController extends GetxController {
  final UserService _userService = UserService();
  
  var isLoading = false.obs;
  var allUsers = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var searchQuery = ''.obs;
  StreamSubscription? _usersSubscription; // 🔥 Added
  
  // User stats cache (make values observable so UI updates)
  final Map<String, RxMap<String, dynamic>> _userStatsCache = {};
  
  // Cache flag to prevent re-fetching
  var _dataLoaded = false;
  
  @override
  void onInit() {
    super.onInit();
    _startUsersListener();
    
    // 🔥 Re-run search whenever the raw user list changes
    ever(allUsers, (_) => searchUsers(searchQuery.value));
  }
  
  @override
  void onClose() {
    _usersSubscription?.cancel();
    super.onClose();
  }

  /// 🔥 Real-time user listener
  void _startUsersListener() {
    isLoading.value = true;
    _usersSubscription?.cancel();
    _usersSubscription = _userService.streamAllUsers().listen((users) {
      allUsers.value = users;
      isLoading.value = false;
      
      // Fetch stats for new users in background
      for (var user in users) {
        _fetchUserStats(user.uid);
      }
    }, onError: (e) {
      print('❌ Error in users stream: $e');
      isLoading.value = false;
    });
  }
  
  /// Fetch all users from Firestore (with caching)
  Future<void> fetchAllUsers({bool forceRefresh = false}) async {
    // If data already loaded and not forcing refresh, skip
    if (_dataLoaded && !forceRefresh) {
      print('✅ Using cached user data (${allUsers.length} users)');
      return;
    }
    
    try {
      isLoading.value = true;
      print('🔍 Controller: Fetching all users...');
      
      // Fetch users using UserService
      final users = await _userService.getAllUsers();
      
      allUsers.value = users;
      filteredUsers.value = users;
      _dataLoaded = true;
      isLoading.value = false; // Show users immediately

      print('✅ Controller: Loaded ${users.length} users. Now fetching stats...');

      // Fetch stats for all users in background
      for (var user in users) {
        _fetchUserStats(user.uid);
      }
      
    } catch (e) {
      print('❌ Controller Error fetching users: $e');
      isLoading.value = false;
    }
  }
  
  /// Fetch and cache user stats
  Future<void> _fetchUserStats(String uid) async {
    // If already loading or loaded, return
    if (_userStatsCache.containsKey(uid) && _userStatsCache[uid]!['loading'] == true) return;
    if (_userStatsCache.containsKey(uid) && _userStatsCache[uid]!['loaded'] == true) return;
    
    print('🔄 Controller: Background fetch started for $uid');

    // Initialize cache with loading state
    _userStatsCache[uid] = <String, dynamic>{
      'tasksPosted': 0,
      'tasksCompleted': 0,
      'totalEarnings': 0.0,
      'rating': 0.0,
      'loaded': false,
      'loading': true,
    }.obs;

    try {
      final stats = await _userService.getUserTaskStats(uid);
      stats['loaded'] = true;
      stats['loading'] = false;
      _userStatsCache[uid]!.assignAll(stats);
      print('✨ Controller: Stats updated for $uid');
    } catch (e) {
      print('⚠️ Controller: Error updating stats for $uid: $e');
      _userStatsCache[uid]!['loading'] = false;
    }
  }
  
  /// Get user stats from cache
  Map<String, dynamic> getUserStats(String uid) {
    if (!_userStatsCache.containsKey(uid)) {
      // Create skeleton and trigger fetch
      _userStatsCache[uid] = <String, dynamic>{
        'tasksPosted': 0,
        'tasksCompleted': 0,
        'totalEarnings': 0.0,
        'rating': 0.0,
        'loaded': false,
        'loading': false,
      }.obs;
      _fetchUserStats(uid);
    }
    return _userStatsCache[uid]!;
  }
  
  /// Search users
  void searchUsers(String query) {
    searchQuery.value = query.toLowerCase();
    
    if (query.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers.where((user) {
        return user.displayName.toLowerCase().contains(searchQuery.value) ||
               (user.userId?.toLowerCase().contains(searchQuery.value) ?? false) ||
               (user.city?.toLowerCase().contains(searchQuery.value) ?? false);
      }).toList();
    }
    
    print('🔍 Search: "$query" - Found ${filteredUsers.length} users');
  }
  
  /// Get user initials
  String getUserInitials(String name) {
    if (name.isEmpty) return 'U';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
  }
  
  /// Determine user role based on stats
  String getUserRole(UserModel user) {
    final stats = getUserStats(user.uid);
    final tasksCompleted = stats['tasksCompleted'] ?? 0;
    final tasksPosted = stats['tasksPosted'] ?? 0;
    
    if (tasksCompleted > tasksPosted) {
      return 'Helper';
    } else if (tasksPosted > 0) {
      return 'Requester';
    } else {
      return 'User';
    }
  }
  
  /// Get tasks text
  String getTasksText(UserModel user) {
    final stats = getUserStats(user.uid);
    final role = getUserRole(user);
    
    if (role == 'Helper') {
      return '${stats['tasksCompleted']} tasks completed';
    } else if (role == 'Requester') {
      return '${stats['tasksPosted']} tasks posted';
    } else {
      return 'No tasks yet';
    }
  }
  
  /// Get user rating
  double getUserRating(UserModel user) {
    final stats = getUserStats(user.uid);
    final dynamic rating = stats['rating'] ?? 0.0;
    return (rating as num).toDouble();
  }
  
  /// Get user price/earnings
  String getUserPrice(UserModel user) {
    final stats = getUserStats(user.uid);
    final price = stats['totalEarnings'] ?? 0.0;
    return 'SAR ${price.toStringAsFixed(0)}';
  }
}
