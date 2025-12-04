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
    // Initialize with default/sample data
    _loadDisputeData();
  }

  void _loadDisputeData() {
    // Sample data - in real app, this would come from API/Firebase
    taskTitle.value = 'Furniture Moving & Assembly';
    taskAmount.value = '350 SAR';
    taskCategory.value = 'Moving Services';
    completedTime.value = '2:30 PM';
    taskId.value = '#TK-4729';
    disputeReason.value =
        '"Helper moved furniture incorrectly and caused damage to my wooden cabinet. The glass door was cracked during the move and the helper did not use proper protective materials."';
    disputeStartTime.value = '2 hours ago';

    // Helper data
    helperName.value = 'Ahmed AL-Rashid';
    helperRating.value = 4.8;
    helperTasksCompleted.value = 124;

    // Requester data
    requesterName.value = 'Sarah Mohammed';
    requesterRating.value = 4.6;
    requesterMemberSince.value = 'Jan 2023';
  }

  void toggleEvidence() {
    showBefore.value = !showBefore.value;
  }
}
