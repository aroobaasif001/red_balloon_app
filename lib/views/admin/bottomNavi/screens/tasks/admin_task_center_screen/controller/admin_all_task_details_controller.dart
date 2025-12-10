import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/offer_model.dart';
import 'package:red_balloon_app/model/task_details_cache_model.dart';
import 'package:red_balloon_app/services/offer_service.dart';
import 'package:red_balloon_app/services/user_service.dart';

class AdminAllTaskDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final OfferService _offerService = OfferService();
  
  // Static cache that persists across controller instances
  static final Map<String, TaskDetailsCache> _cache = {};
  
  // Loading state
  var isLoading = false.obs;
  
  // Task data
  var taskTitle = ''.obs;
  var taskDescription = ''.obs;
  var taskLocation = ''.obs;
  var taskBudget = ''.obs;
  var taskStatus = ''.obs;
  var taskType = ''.obs;
  var taskImageUrl = ''.obs;
  var taskCreatedAt = ''.obs;
  var taskCompletedAt = ''.obs;
  
  // Requester data
  var requesterName = ''.obs;
  var requesterUserId = ''.obs;
  var requesterImage = ''.obs;
  var requesterUid = ''.obs;
  var requesterTasksPosted = 0.obs;
  var requesterRating = 0.0.obs;
  
  // Helper data
  var helperName = ''.obs;
  var helperUserId = ''.obs;
  var helperImage = ''.obs;
  var helperUid = ''.obs;
  var helperTasksCompleted = 0.obs;
  var helperRating = 0.0.obs;
  var helperResponseTime = ''.obs;
  
  // Offers data
  var offers = <OfferModel>[].obs;
  var acceptedOfferId = ''.obs;
  var offerUserIds = <String, String>{}.obs; // Map: UID -> Formatted ID (e.g., "RB-001")
  
  // Proof data
  var beforePhotoUrl = ''.obs;
  var afterPhotoUrl = ''.obs;
  var selectedProofTab = 0.obs; // 0 = BEFORE, 1 = AFTER
  var hasProofDocument = false.obs; // Track if task has proof in database
  
  // Offers listener
  StreamSubscription<QuerySnapshot>? _offersSubscription;
  
  // Task document listener
  StreamSubscription<DocumentSnapshot>? _taskSubscription;
  
  // Proof listener
  StreamSubscription<QuerySnapshot>? _proofSubscription;
  
  /// Fetch task details (with static caching)
  Future<void> fetchTaskDetails(String taskId, {bool forceRefresh = false}) async {
    // Check if we have cached data for this task
    if (_cache.containsKey(taskId) && !forceRefresh) {
      print('✅ Using cached data for task: $taskId (${_cache.length} tasks cached)');
      _loadFromCache(taskId);
      return;
    }
    
    try {
      isLoading.value = true;
      print('🔍 Setting up real-time task listener for: $taskId');
      
      // Cancel previous task subscription
      await _taskSubscription?.cancel();
      
      // Set up real-time listener for task document
      _taskSubscription = _firestore
          .collection('tasks')
          .doc(taskId)
          .snapshots()
          .listen((taskDoc) async {
        if (!taskDoc.exists) {
          print('❌ Task not found');
          return;
        }
        
        final taskData = taskDoc.data()!;
        
        // Parse task data
        taskTitle.value = taskData['title'] ?? 'No Title';
        taskDescription.value = taskData['description'] ?? 'No description';
        taskLocation.value = taskData['location'] ?? 'Unknown';
        taskBudget.value = 'SAR ${taskData['budget'] ?? 0}';
        taskStatus.value = taskData['status'] ?? 'Unknown';
        taskType.value = taskData['taskType'] ?? 'Offline Task';
        taskImageUrl.value = taskData['imageUrl'] ?? '';
        
        // Parse dates
        if (taskData['createdAt'] != null) {
          final createdAt = _parseTimestamp(taskData['createdAt']);
          taskCreatedAt.value = _getTimeAgo(createdAt);
        }
        
        if (taskData['completedAt'] != null) {
          final completedAt = _parseTimestamp(taskData['completedAt']);
          taskCompletedAt.value = _getTimeAgo(completedAt);
        }
        
        // Fetch requester data (only if changed)
        final requesterUidValue = taskData['uid'];
        if (requesterUidValue != null && requesterUid.value != requesterUidValue) {
          requesterUid.value = requesterUidValue;
          await _fetchRequesterData(requesterUidValue);
        }
        
        // Fetch helper data (real-time update when offer accepted!)
        final helperUidValue = taskData['acceptedOfferUid'];
        if (helperUidValue != null && helperUid.value != helperUidValue) {
          print('🔄 Helper updated: $helperUidValue');
          helperUid.value = helperUidValue;
          acceptedOfferId.value = helperUidValue;
          await _fetchHelperData(helperUidValue);
        } else if (helperUidValue == null && helperUid.value.isNotEmpty) {
          // Helper removed
          print('🔄 Helper removed');
          helperUid.value = '';
          helperName.value = '';
          helperUserId.value = '';
          helperImage.value = '';
          helperTasksCompleted.value = 0;
          helperRating.value = 0.0;
          helperResponseTime.value = '';
        }
        
        // Update cache
        if (_cache.containsKey(taskId)) {
          _saveToCache(taskId);
        }
        
        // Fetch proof data from task_proofs collection
        _fetchProofData(taskId);
        
        print('✅ Task data updated in real-time');
      });
      
      // Fetch offers using real-time listener
      await _fetchOffers(taskId);
      
      // Save to cache
      _saveToCache(taskId);
      
      isLoading.value = false;
      print('✅ Task details loaded with real-time listeners');
    } catch (e) {
      print('❌ Error fetching task details: $e');
      isLoading.value = false;
    }
  }
  
  /// Load data from cache
  void _loadFromCache(String taskId) {
    final cached = _cache[taskId]!;
    
    taskTitle.value = cached.taskTitle;
    taskDescription.value = cached.taskDescription;
    taskLocation.value = cached.taskLocation;
    taskBudget.value = cached.taskBudget;
    taskStatus.value = cached.taskStatus;
    taskType.value = cached.taskType;
    taskImageUrl.value = cached.taskImageUrl;
    taskCreatedAt.value = cached.taskCreatedAt;
    taskCompletedAt.value = cached.taskCompletedAt;
    
    requesterName.value = cached.requesterName;
    requesterUserId.value = cached.requesterUserId;
    requesterImage.value = cached.requesterImage;
    requesterUid.value = cached.requesterUid;
    requesterTasksPosted.value = cached.requesterTasksPosted;
    requesterRating.value = cached.requesterRating;
    
    helperName.value = cached.helperName;
    helperUserId.value = cached.helperUserId;
    helperImage.value = cached.helperImage;
    helperUid.value = cached.helperUid;
    helperTasksCompleted.value = cached.helperTasksCompleted;
    helperRating.value = cached.helperRating;
    helperResponseTime.value = cached.helperResponseTime;
    
    offers.value = cached.offers;
    acceptedOfferId.value = cached.acceptedOfferId;
    
    // IMPORTANT: Still set up real-time listeners even when using cached data
    // This ensures new offers and proof appear even when using cached data
    _fetchOffers(taskId);
    _fetchProofData(taskId);
  }
  
  /// Save current data to cache
  void _saveToCache(String taskId) {
    _cache[taskId] = TaskDetailsCache(
      taskTitle: taskTitle.value,
      taskDescription: taskDescription.value,
      taskLocation: taskLocation.value,
      taskBudget: taskBudget.value,
      taskStatus: taskStatus.value,
      taskType: taskType.value,
      taskImageUrl: taskImageUrl.value,
      taskCreatedAt: taskCreatedAt.value,
      taskCompletedAt: taskCompletedAt.value,
      requesterName: requesterName.value,
      requesterUserId: requesterUserId.value,
      requesterImage: requesterImage.value,
      requesterUid: requesterUid.value,
      requesterTasksPosted: requesterTasksPosted.value,
      requesterRating: requesterRating.value,
      helperName: helperName.value,
      helperUserId: helperUserId.value,
      helperImage: helperImage.value,
      helperUid: helperUid.value,
      helperTasksCompleted: helperTasksCompleted.value,
      helperRating: helperRating.value,
      helperResponseTime: helperResponseTime.value,
      offers: offers.toList(),
      acceptedOfferId: acceptedOfferId.value,
    );
  }
  
  /// Fetch requester data
  Future<void> _fetchRequesterData(String uid) async {
    try {
      print('👤 Fetching requester data for: $uid');
      
      final user = await _userService.getUserByUid(uid);
      if (user != null) {
        requesterName.value = user.displayName;
        requesterUserId.value = user.userId ?? 'RB-0000';
        requesterImage.value = user.photoURL ?? '';
        
        // Fetch stats
        final stats = await _userService.getUserTaskStats(uid);
        requesterTasksPosted.value = stats['tasksPosted'] ?? 0;
        requesterRating.value = 4.5; // TODO: Get from user data
        
        print('✅ Requester: ${requesterName.value}');
      }
    } catch (e) {
      print('❌ Error fetching requester data: $e');
    }
  }
  
  /// Fetch helper data
  Future<void> _fetchHelperData(String uid) async {
    try {
      print('👷 Fetching helper data for: $uid');
      
      final user = await _userService.getUserByUid(uid);
      if (user != null) {
        helperName.value = user.displayName;
        helperUserId.value = user.userId ?? 'RB-0000';
        helperImage.value = user.photoURL ?? '';
        
        // Fetch stats
        final stats = await _userService.getUserTaskStats(uid);
        helperTasksCompleted.value = stats['tasksCompleted'] ?? 0;
        helperRating.value = 4.9; // TODO: Get from user data
        helperResponseTime.value = '< 5 min'; // TODO: Calculate from data
        
        print('✅ Helper: ${helperName.value}');
      }
    } catch (e) {
      print('❌ Error fetching helper data: $e');
    }
  }
  
  /// Fetch proof data from task_proofs collection with real-time listener
  Future<void> _fetchProofData(String taskId) async {
    try {
      print('📸 Setting up real-time proof listener for task: $taskId');
      print('🔍 Searching in task_proofs collection with taskId: $taskId');
      
      // Cancel previous subscription if exists
      await _proofSubscription?.cancel();
      
      // Set up real-time listener for proof
      _proofSubscription = _firestore
          .collection('task_proofs')
          .where('taskId', isEqualTo: taskId)
          .snapshots()
          .listen((snapshot) {
        print('🔄 Proof snapshot received: ${snapshot.docs.length} documents');
        
        if (snapshot.docs.isNotEmpty) {
          // Proof document exists in database
          hasProofDocument.value = true;
          
          final proofDoc = snapshot.docs.first;
          final proofData = proofDoc.data();
          
          print('📄 Proof document ID: ${proofDoc.id}');
          print('📄 Proof data keys: ${proofData.keys.toList()}');
          print('📄 beforePhotoUrl: ${proofData['beforePhotoUrl']}');
          print('📄 afterPhotoUrl: ${proofData['afterPhotoUrl']}');
          
          beforePhotoUrl.value = proofData['beforePhotoUrl'] ?? '';
          afterPhotoUrl.value = proofData['afterPhotoUrl'] ?? '';
          
          print('✅ Proof document exists - showing Before & After section');
          print('✅ Proof data updated: before=${beforePhotoUrl.value.isNotEmpty}, after=${afterPhotoUrl.value.isNotEmpty}');
        } else {
          // No proof document in database
          hasProofDocument.value = false;
          beforePhotoUrl.value = '';
          afterPhotoUrl.value = '';
          print('ℹ️ No proof document found - hiding Before & After section');
        }
      });
    } catch (e) {
      print('❌ Error setting up proof listener: $e');
      print('❌ Stack trace: ${StackTrace.current}');
    }
  }
  
  /// Fetch offers for this task using OfferService
  Future<void> _fetchOffers(String taskId) async {
    try {
      print('💰 Setting up real-time offers listener for task: $taskId');
      
      // Cancel previous subscription if exists
      await _offersSubscription?.cancel();
      
      // Set up real-time listener
      _offersSubscription = _firestore
          .collection('offers')
          .where('taskId', isEqualTo: taskId)
          .snapshots()
          .listen((snapshot) {
        print('🔄 Offers updated: ${snapshot.docs.length} offers');
        
        final List<OfferModel> offersList = [];
        
        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();
            final offer = OfferModel.fromJson(data, doc.id);
            offersList.add(offer);
          } catch (e) {
            print('❌ Error parsing offer: $e');
          }
        }
        
        // Sort offers: accepted first, then by creation date (newest first)
        offersList.sort((a, b) {
          // If one is accepted and other is not, accepted comes first
          if (a.status == 'accepted' && b.status != 'accepted') return -1;
          if (a.status != 'accepted' && b.status == 'accepted') return 1;
          
          // If both have same status, sort by creation date (newest first)
          return b.createdAt.compareTo(a.createdAt);
        });
        
        offers.value = offersList;
        
        // Fetch formatted user IDs for all offer users
        _fetchOfferUserIds(offersList);
        
        // Update cache with new offers
        if (_cache.containsKey(taskId)) {
          _saveToCache(taskId);
        }
        
        print('✅ Offers updated in real-time (${offersList.length} offers, sorted)');
      });
    } catch (e) {
      print('❌ Error setting up offers listener: $e');
    }
  }
  
  /// Fetch formatted user IDs for offer users
  Future<void> _fetchOfferUserIds(List<OfferModel> offersList) async {
    try {
      for (var offer in offersList) {
        final uid = offer.offeringUserUid;
        
        // Skip if already fetched
        if (offerUserIds.containsKey(uid)) continue;
        
        // Fetch user document
        final userDoc = await _firestore.collection('users').doc(uid).get();
        
        if (userDoc.exists) {
          final userData = userDoc.data();
          final formattedId = userData?['userId'] ?? '';
          
          if (formattedId.isNotEmpty) {
            offerUserIds[uid] = formattedId;
            offerUserIds.refresh(); // ✅ Trigger reactivity
            print('✅ Fetched user ID for $uid: $formattedId');
          } else {
            print('⚠️ User $uid has no userId field');
          }
        } else {
          print('⚠️ User document not found for $uid');
        }
      }
    } catch (e) {
      print('❌ Error fetching offer user IDs: $e');
    }
  }
  
  @override
  void onClose() {
    // Cancel subscriptions when controller is disposed
    _taskSubscription?.cancel();
    _offersSubscription?.cancel();
    _proofSubscription?.cancel();
    super.onClose();
  }
  
  /// Parse timestamp
  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
  }
  
  /// Get time ago string
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
  
  /// Clear cache (optional - for testing or memory management)
  static void clearCache() {
    _cache.clear();
    print('🗑️ Cache cleared');
  }
}
