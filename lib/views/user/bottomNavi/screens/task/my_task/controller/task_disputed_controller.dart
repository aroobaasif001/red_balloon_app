import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TaskDisputedController extends GetxController {
  // Observable for Before/After toggle state
  final RxBool showBefore = true.obs;

  // Task data
  final RxString taskTitle = ''.obs;
  final RxString taskAmount = ''.obs;
  final RxString taskCategory = ''.obs;
  final RxString completedTime = ''.obs;
  final RxString taskId = ''.obs;
  final RxString disputeReason = ''.obs;
  final RxString disputeStartTime = ''.obs;

  // Participant data
  final RxString helperName = ''.obs;
  final RxString helperPhoto = ''.obs;
  final RxDouble helperRating = 0.0.obs;
  final RxInt helperTasksCompleted = 0.obs;

  final RxString requesterName = ''.obs;
  final RxString requesterPhoto = ''.obs;
  final RxDouble requesterRating = 0.0.obs;
  final RxString requesterMemberSince = ''.obs;

  // Evidence images
  final RxString beforeImageUrl = ''.obs;
  final RxString afterImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void initialize({
    required Map<String, dynamic> task,
    required Map<String, dynamic> dispute,
    required Map<String, dynamic> requester,
    required Map<String, dynamic> helper,
  }) {
    taskTitle.value = task['title'] ?? 'Task Details';
    taskAmount.value = '${task['budget'] ?? 0} SAR';
    taskCategory.value = task['category'] ?? 'Task';
    taskId.value = task['taskId'] ?? '#TK-0000';
    
    disputeReason.value = dispute['reason'] ?? 'No reason provided';
    disputeStartTime.value = dispute['disputedStartTime'] ?? '';

    // Participant data
    helperName.value = helper['name'] ?? 'Helper';
    helperPhoto.value = helper['photoUrl'] ?? '';
    // helperRating.value = ...
    
    requesterName.value = requester['name'] ?? 'Requester';
    requesterPhoto.value = requester['photoUrl'] ?? '';

    // Evidence images
    beforeImageUrl.value = (dispute['beforePhotoUrl'] ?? 
                           dispute['beforeImageUrl'] ?? 
                           dispute['beforePhoto'] ?? '').toString();
    afterImageUrl.value = (dispute['afterPhotoUrl'] ?? 
                          dispute['afterImageUrl'] ?? 
                          dispute['afterPhoto'] ?? '').toString();

    // If photos are missing, try to fetch them from Firestore collections directly
    if (beforeImageUrl.value.isEmpty || afterImageUrl.value.isEmpty) {
      fetchMissingPhotos(task['taskId'] ?? task['id']);
    }

    // Fetch ratings for participants
    if (helper['uid'] != null) _fetchUserRating(helper['uid'], isHelper: true);
    if (requester['uid'] != null) _fetchUserRating(requester['uid'], isHelper: false);
  }

  Future<void> _fetchUserRating(String uid, {required bool isHelper}) async {
    try {
      double sum = 0;
      int count = 0;

      // 1. As Helper
      final hTasks = await FirebaseFirestore.instance
          .collection('tasks')
          .where('acceptedOfferUid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();
      
      for (var doc in hTasks.docs) {
        final data = doc.data();
        if (data['requesterFeedback'] != null) {
          sum += (data['requesterFeedback']['rating'] ?? 0).toDouble();
          count++;
        }
      }

      // 2. As Requester
      final rTasks = await FirebaseFirestore.instance
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();

      for (var doc in rTasks.docs) {
        final data = doc.data();
        if (data['helperFeedback'] != null) {
          sum += (data['helperFeedback']['rating'] ?? 0).toDouble();
          count++;
        }
      }

      if (count > 0) {
        if (isHelper) {
          helperRating.value = sum / count;
        } else {
          requesterRating.value = sum / count;
        }
      } else {
        // Default to a decent rating if no feedbacks yet
        if (isHelper) helperRating.value = 5.0;
        else requesterRating.value = 5.0;
      }
    } catch (e) {
      print("Error fetching user rating: $e");
    }
  }

  Future<void> fetchMissingPhotos(String? tId) async {
    if (tId == null || tId.isEmpty || tId == 'default') return;

    try {
      // 1. Try validations collection first
      final valQuery = await FirebaseFirestore.instance
          .collection('validations')
          .where('taskId', isEqualTo: tId)
          .limit(1)
          .get();

      if (valQuery.docs.isNotEmpty) {
        final data = valQuery.docs.first.data();
        final b = data['beforePhotoUrl'] ?? data['beforeImageUrl'] ?? data['beforePhoto'] ?? '';
        final a = data['afterPhotoUrl'] ?? data['afterImageUrl'] ?? data['afterPhoto'] ?? '';
        
        if (b.isNotEmpty || a.isNotEmpty) {
          if (beforeImageUrl.value.isEmpty) beforeImageUrl.value = b.toString();
          if (afterImageUrl.value.isEmpty) afterImageUrl.value = a.toString();
          return; // Found them
        }
      }

      // 2. Try task_proofs fallback
      final proofQuery = await FirebaseFirestore.instance
          .collection('task_proofs')
          .where('taskId', isEqualTo: tId)
          .orderBy('submittedAt', descending: true)
          .limit(5)
          .get();

      if (proofQuery.docs.isNotEmpty) {
        for (var doc in proofQuery.docs) {
          final data = doc.data();
          final b = data['beforePhotoUrl'] ?? data['beforeImageUrl'] ?? data['beforePhoto'] ?? '';
          final a = data['afterPhotoUrl'] ?? data['afterImageUrl'] ?? data['afterPhoto'] ?? '';
          
          if (b.isNotEmpty || a.isNotEmpty) {
            if (beforeImageUrl.value.isEmpty) beforeImageUrl.value = b.toString();
            if (afterImageUrl.value.isEmpty) afterImageUrl.value = a.toString();
            break;
          }
        }
      }
    } catch (e) {
      print('Error fetching missing photos in TaskDisputedController: $e');
    }
  }

  void toggleEvidence() {
    showBefore.value = !showBefore.value;
  }

  DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
