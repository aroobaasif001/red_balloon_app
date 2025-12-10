import 'package:get/get.dart';
import 'package:red_balloon_app/model/user_model.dart';
import 'package:red_balloon_app/services/user_service.dart';

class UserManagementController extends GetxController {
  final UserService _userService = UserService();
  
  var isLoading = false.obs;
  var allUsers = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var searchQuery = ''.obs;
  
  // User stats cache
  final Map<String, Map<String, dynamic>> _userStatsCache = {};
  
  // Cache flag to prevent re-fetching
  var _dataLoaded = false;
  
  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
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
      
      // Fetch stats for all users in parallel
      await Future.wait(
        users.map((user) => _fetchUserStats(user.uid)),
      );
      
      allUsers.value = users;
      filteredUsers.value = users;
      _dataLoaded = true;
      isLoading.value = false;
      print('✅ Controller: Loaded ${users.length} users (cached for future use)');
    } catch (e) {
      print('❌ Controller Error fetching users: $e');
      isLoading.value = false;
    }
  }
  
  /// Fetch and cache user stats
  Future<void> _fetchUserStats(String uid) async {
    if (_userStatsCache.containsKey(uid)) return;
    
    final stats = await _userService.getUserTaskStats(uid);
    _userStatsCache[uid] = stats;
  }
  
  /// Get user stats from cache
  Map<String, dynamic> getUserStats(String uid) {
    return _userStatsCache[uid] ?? {
      'tasksPosted': 0,
      'tasksCompleted': 0,
      'totalEarnings': 0,
    };
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
  
  /// Get user rating (rounded)
  int getUserRating(UserModel user) {
    // TODO: Get actual rating from user stats
    return 4; // Placeholder
  }
  
  /// Get user price/earnings
  String getUserPrice(UserModel user) {
    final stats = getUserStats(user.uid);
    final role = getUserRole(user);
    
    if (role == 'Helper') {
      return 'SAR ${stats['totalEarnings']}';
    } else {
      return 'SAR ${stats['tasksPosted'] * 100}'; // Estimate
    }
  }
}
