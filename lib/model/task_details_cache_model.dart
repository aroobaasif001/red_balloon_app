import 'package:red_balloon_app/model/offer_model.dart';

/// Cache model for task details
class TaskDetailsCache {
  final String taskTitle;
  final String taskDescription;
  final String taskLocation;
  final String taskBudget;
  final String taskStatus;
  final String taskType;
  final String taskImageUrl;
  final String taskCreatedAt;
  final String taskCompletedAt;
  
  final String requesterName;
  final String requesterUserId;
  final String requesterImage;
  final String requesterUid;
  final int requesterTasksPosted;
  final double requesterRating;
  
  final String helperName;
  final String helperUserId;
  final String helperImage;
  final String helperUid;
  final int helperTasksCompleted;
  final double helperRating;
  final String helperResponseTime;
  
  final List<OfferModel> offers;
  final String acceptedOfferId;
  
  TaskDetailsCache({
    required this.taskTitle,
    required this.taskDescription,
    required this.taskLocation,
    required this.taskBudget,
    required this.taskStatus,
    required this.taskType,
    required this.taskImageUrl,
    required this.taskCreatedAt,
    required this.taskCompletedAt,
    required this.requesterName,
    required this.requesterUserId,
    required this.requesterImage,
    required this.requesterUid,
    required this.requesterTasksPosted,
    required this.requesterRating,
    required this.helperName,
    required this.helperUserId,
    required this.helperImage,
    required this.helperUid,
    required this.helperTasksCompleted,
    required this.helperRating,
    required this.helperResponseTime,
    required this.offers,
    required this.acceptedOfferId,
  });
}
