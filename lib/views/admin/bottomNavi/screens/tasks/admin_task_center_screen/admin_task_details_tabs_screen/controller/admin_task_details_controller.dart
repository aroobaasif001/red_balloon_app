import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTaskDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var isLoading = true.obs;
  var taskTitle = ''.obs;
  var taskDescription = ''.obs; // 🔥 Added task description
  var rejectionReason = ''.obs;
  var completedTime = ''.obs;
  var taskCreatorUserId = ''.obs;
  var taskCreatorName = ''.obs;
  var taskCreatorImage = ''.obs;
  
  var helperUserId = ''.obs;
  var helperName = ''.obs;
  var helperImage = ''.obs;
  var helperTasksCount = 0.obs;
  var helperRating = 0.0.obs;
  var helperResponseTime = ''.obs;
  
  var beforePhotoUrl = ''.obs;
  var afterPhotoUrl = ''.obs;
  
  var supportRequesterVotes = 0.obs;
  var supportHelperVotes = 0.obs;
  var totalVotes = 0.obs;

  /// Fetch all task details
  Future<void> fetchTaskDetails(String validationId) async {
    try {
      isLoading.value = true;
      print('🔍 Fetching task details for validation: $validationId');

      // 1. Fetch validation document
      final validationDoc = await _firestore.collection('validations').doc(validationId).get();
      
      if (!validationDoc.exists) {
        print('❌ Validation not found');
        isLoading.value = false;
        return;
      }

      final validationData = validationDoc.data()!;
      final taskId = validationData['taskId'];
      final proofId = validationData['proofId'];
      
      print('📄 Validation Document ID: $validationId');
      print('📄 Validation Data: $validationData');
      
      rejectionReason.value = validationData['rejectionReason'] ?? 'No reason provided';
      beforePhotoUrl.value = validationData['beforePhotoUrl'] ?? '';
      afterPhotoUrl.value = validationData['afterPhotoUrl'] ?? '';
      
      // 🔥 Fetch votes directly from validation document
      final helperVotesFromDB = validationData['helperVotes'];
      final requesterVotesFromDB = validationData['requesterVotes'];
      
      print('🔍 RAW helperVotes from DB: $helperVotesFromDB (type: ${helperVotesFromDB.runtimeType})');
      print('🔍 RAW requesterVotes from DB: $requesterVotesFromDB (type: ${requesterVotesFromDB.runtimeType})');
      
      supportHelperVotes.value = helperVotesFromDB ?? 0;
      supportRequesterVotes.value = requesterVotesFromDB ?? 0;
      totalVotes.value = supportHelperVotes.value + supportRequesterVotes.value;
      
      print('✅ FINAL Votes - Helper: ${supportHelperVotes.value}, Requester: ${supportRequesterVotes.value}, Total: ${totalVotes.value}');
      
      // Calculate completed time
      if (validationData['rejectedAt'] != null) {
        DateTime rejectedAt;
        if (validationData['rejectedAt'] is String) {
          rejectedAt = DateTime.parse(validationData['rejectedAt']);
        } else {
          rejectedAt = (validationData['rejectedAt'] as Timestamp).toDate();
        }
        completedTime.value = _getTimeAgo(rejectedAt);
      }

      // 2. Fetch task details and REQUESTER UID
      String? requesterUid = null;
      if (taskId != null) {
        print('📋 Fetching task details for taskId: $taskId');
        final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
        if (taskDoc.exists) {
          final taskData = taskDoc.data()!;
          taskTitle.value = taskData['title'] ?? 'No Title';
          taskDescription.value = taskData['description'] ?? 'No description available';
          requesterUid = taskData['uid']; // 🔥 Get requester UID from task.uid
          print('✅ Task title: ${taskTitle.value}');
          print('✅ Task description: ${taskDescription.value}');
          print('✅ Requester UID from task.uid: $requesterUid');
        } else {
          print('❌ Task document not found');
        }
      }

      // 3. Fetch REQUESTER details using UID from task.uid
      if (requesterUid != null) {
        print('👤 Fetching REQUESTER details for UID: $requesterUid');
        await _fetchUserDetails(requesterUid, isHelper: false);
      } else {
        print('⚠️ Requester UID not found in task');
      }

      // 4. Fetch HELPER details from task_proofs
      if (proofId != null) {
        print('👷 Fetching proof details for proofId: $proofId');
        final proofDoc = await _firestore.collection('task_proofs').doc(proofId).get();
        if (proofDoc.exists) {
          final proofData = proofDoc.data()!;
          final helperUid = proofData['userId']; // 🔥 Get helper UID from proof.userId
          print('👷 Helper UID from task_proofs.userId: $helperUid');
          if (helperUid != null) {
            print('👤 Fetching HELPER details for UID: $helperUid');
            await _fetchUserDetails(helperUid, isHelper: true);
          } else {
            print('⚠️ Helper userId is null in proof');
          }
        } else {
          print('❌ Proof document not found');
        }
      } else {
        print('⚠️ proofId is null');
      }

      isLoading.value = false;
      print('✅ Task details loaded successfully');
    } catch (e) {
      print('❌ Error fetching task details: $e');
      isLoading.value = false;
    }
  }

  /// Fetch user details from users collection
  Future<void> _fetchUserDetails(String uid, {required bool isHelper}) async {
    try {
      print('🔍 Fetching user details for UID: $uid (isHelper: $isHelper)');
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        
        // 🔥 DEBUG: Print ALL fields to see what's available
        print('📋 Available fields in user document:');
        userData.forEach((key, value) {
          print('   - $key: $value');
        });
        
        final userId = userData['userId'] ?? 'RB-00000';
        
        // 🔥 Try multiple possible field names for name
        String name = 'Unknown User';
        if (userData.containsKey('username') && userData['username'] != null && userData['username'].toString().isNotEmpty) {
          name = userData['username'];
        } else if (userData.containsKey('name') && userData['name'] != null && userData['name'].toString().isNotEmpty) {
          name = userData['name'];
        } else if (userData.containsKey('displayName') && userData['displayName'] != null && userData['displayName'].toString().isNotEmpty) {
          name = userData['displayName'];
        }
        
        // 🔥 Try multiple possible field names for image
        String image = '';
        if (userData.containsKey('photoURL') && userData['photoURL'] != null && userData['photoURL'].toString().isNotEmpty) {
          image = userData['photoURL'];
        } else if (userData.containsKey('profileImage') && userData['profileImage'] != null && userData['profileImage'].toString().isNotEmpty) {
          image = userData['profileImage'];
        } else if (userData.containsKey('profilePicture') && userData['profilePicture'] != null && userData['profilePicture'].toString().isNotEmpty) {
          image = userData['profilePicture'];
        }
        
        print('✅ User found: $name ($userId)');
        print('📸 User image: ${image.isNotEmpty ? image : "Not available"}');
        
        if (isHelper) {
          helperUserId.value = userId;
          helperName.value = name;
          helperImage.value = image;
          
          // Fetch helper stats
          helperTasksCount.value = userData['completedTasks'] ?? 0;
          helperRating.value = (userData['rating'] ?? 0.0).toDouble();
          helperResponseTime.value = _calculateResponseTime(userData['averageResponseTime']);
          
          print('📊 Helper stats - Tasks: ${helperTasksCount.value}, Rating: ${helperRating.value}');
        } else {
          taskCreatorUserId.value = userId;
          taskCreatorName.value = name;
          taskCreatorImage.value = image;
          
          print('📊 Task creator: $name ($userId)');
        }
      } else {
        print('❌ User document not found for UID: $uid');
      }
    } catch (e) {
      print('❌ Error fetching user details for $uid: $e');
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Completed ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return 'Completed ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return 'Completed ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Completed just now';
    }
  }

  String _calculateResponseTime(dynamic avgResponseTime) {
    if (avgResponseTime == null) return '5 min';
    
    if (avgResponseTime is int) {
      if (avgResponseTime < 60) {
        return '$avgResponseTime min';
      } else {
        final hours = avgResponseTime ~/ 60;
        return '$hours hr${hours > 1 ? 's' : ''}';
      }
    }
    
    return '5 min';
  }
}
