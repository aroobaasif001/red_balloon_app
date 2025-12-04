import 'package:get/get.dart';

class TaskCompletedController extends GetxController {
  // Observable for Before/After toggle state
  final RxBool showBefore = true.obs;

  // Task data
  final RxString taskTitle = ''.obs;
  final RxString taskAmount = ''.obs;
  final RxString taskCategory = ''.obs;
  final RxString completedTime = ''.obs;
  final RxString taskId = ''.obs;
  final RxString completedDate = ''.obs;

  // Participant data with ratings
  final RxString helperName = ''.obs;
  final RxString helperPhoto = ''.obs;
  final RxDouble helperRating = 0.0.obs;
  final RxInt helperTasksCompleted = 0.obs;

  final RxString requesterName = ''.obs;
  final RxString requesterPhoto = ''.obs;
  final RxDouble requesterRating = 0.0.obs;
  final RxString requesterMemberSince = ''.obs;

  // Payment Summary
  final RxDouble platformFee = 0.0.obs;
  final RxDouble escrowFee = 0.0.obs;
  final RxDouble finalAmountEarned = 0.0.obs;

  // Feedback & Ratings
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  // Evidence images
  final RxString beforeImageUrl = ''.obs;
  final RxString afterImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default/sample data
    _loadCompletedTaskData();
  }

  void _loadCompletedTaskData() {
    // Sample data - in real app, this would come from API/Firebase
    taskTitle.value = 'Fix kitchen sink sat';
    taskAmount.value = 'SAR 250';
    taskCategory.value = 'Offline Task';
    completedTime.value = '2:30 PM';
    taskId.value = '#TK-2024-4567';
    completedDate.value = 'Dec 4, 2025 at 2:30 PM';

    // Helper data
    helperName.value = 'Ahmed AL-Rashid';
    helperRating.value = 4.8;
    helperTasksCompleted.value = 124;

    // Requester data
    requesterName.value = 'Sarah Mohammed';
    requesterRating.value = 4.6;
    requesterMemberSince.value = 'Jan 2023';

    // Payment calculation
    platformFee.value = -12.50;
    escrowFee.value = -2.50;
    finalAmountEarned.value = 235.00;

    // Sample reviews
    reviews.value = [
      {
        'name': 'Sarah Mohammed',
        'time': '2 weeks ago',
        'rating': 5.0,
        'review':
            '"Ahmed was punctual, professional, and fixed the sink perfectly. The work area was clean and tidy. Highly recommend!"',
      }
    ];
  }

  void toggleEvidence() {
    showBefore.value = !showBefore.value;
  }

  double getTotalPlatformFee() {
    return platformFee.value;
  }

  double getTotalEscrowFee() {
    return escrowFee.value;
  }

  double getFinalAmount() {
    return finalAmountEarned.value;
  }
}
