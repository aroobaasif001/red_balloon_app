import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskCompletedController extends GetxController {
  final Map<String, dynamic> taskData;
  final String taskId;
  final bool isRequester;
  final Map<String, dynamic> otherUserData;
  final Map<String, dynamic> validationInfo;

  TaskCompletedController({
    required this.taskData,
    required this.taskId,
    required this.isRequester,
    required this.otherUserData,
    required this.validationInfo,
  });

  // UI State
  RxBool showBefore = true.obs;

  // --- Getters for UI ---

  // 1. Task Title
  String get taskTitle => taskData['title'] ?? 'Task Details';

  // 2. Completed Date (e.g., "Dec 4, 2025 at 2:30 PM")
  String get formattedCompletedDate {
    final feedbackMap = isRequester ? taskData['requesterFeedback'] : taskData['helperFeedback'];
    final date = _parseDateTime(feedbackMap?['createdAt']) ?? _parseDateTime(taskData['completedAt']);

    if (date == null) return 'N/A';
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(date);
  }

  // 3. Amount (e.g., "SAR 250")
  double get budgetAmount {
     return (taskData['budget'] ?? 0).toDouble();
  }
  
  String get formattedAmount {
    return 'SAR $budgetAmount';
  }
  
  double get platformFee => budgetAmount * 0.075;
  double get escrowFee => budgetAmount * 0.075;
  double get finalAmountEarned => budgetAmount - platformFee - escrowFee;

  // 4. Category (Offline/Online)
  String get formattedCategory {
    final type = taskData['taskType']?.toString().toLowerCase();
    return type == 'online' ? 'Online Task' : 'Offline Task';
  }

  // 5. Completed Time (e.g., "2:30 PM")
  String get formattedCompletedTime {
    final feedbackMap = isRequester ? taskData['requesterFeedback'] : taskData['helperFeedback'];
    final date = _parseDateTime(feedbackMap?['createdAt']) ?? _parseDateTime(taskData['completedAt']);

    if (date == null) return 'N/A';
    return DateFormat('h:mm a').format(date);
  }

  // 6. Formatted Task ID (#TK-{Year}-{First4})
  String get formattedTaskId {
    final createdAt = _parseDateTime(taskData['createdAt']);
    String year = '2025'; // Fallback
    if (createdAt != null) {
      year = createdAt.year.toString();
    }
    String shortId = taskId.length > 4 ? taskId.substring(0, 4) : taskId;
    return '#TK-$year-$shortId';
  }

  // 7. Validation Images
  String get beforePhotoUrl => validationInfo['beforePhotoUrl'] ?? '';
  String get afterPhotoUrl => validationInfo['afterPhotoUrl'] ?? '';

  // 8. Other User (Counterparty) details
  String get otherUserName => otherUserData['name'] ?? 'Unknown';
  String get otherUserId => otherUserData['userId'] ?? 'RB-0000';
  String get otherUserPhoto => otherUserData['photoUrl'] ?? '';
  // Tasks completed logic: safely fallback if not in passed data
  String get otherUserTasksCompleted {
     // If fetched user data has it:
     return (otherUserData['tasksCompleted'] ?? 0).toString();
  }
  double get otherUserRating {
     // If fetched user data has it:
     return (otherUserData['rating'] ?? 5.0).toDouble();
  }

  // 9. Feedback Data logic
  Map<String, dynamic>? get myFeedback {
     if (isRequester) {
       return taskData['requesterFeedback'];
     } else {
       return taskData['helperFeedback'];
     }
  }

  String get feedbackReview => myFeedback?['review'] ?? '';
  double get feedbackRating => (myFeedback?['rating'] ?? 0).toDouble();
  String get feedbackTimeAgo {
    final ts = _parseDateTime(myFeedback?['createdAt']);
    if (ts == null) return '';
    // Simple time ago or date
    final diff = DateTime.now().difference(ts);
    if (diff.inDays > 7) {
       return DateFormat('MMM d, yyyy').format(ts);
    } else if (diff.inDays > 0) {
       return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
       return '${diff.inHours}h ago';
    } else {
       return 'Just now';
    }
  }
  
  String get feedbackAuthorName => "You"; // Or otherUserName if showing RECEIVED feedback

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
