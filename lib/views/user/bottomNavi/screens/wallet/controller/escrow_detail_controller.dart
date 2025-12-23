import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

class EscrowDetailController extends GetxController {
  // Observable variables
  RxDouble amountHeld = 100.0.obs;
  RxString currency = 'SAR'.obs;
  RxString taskName = 'Help Move Furniture'.obs;
  RxString validationStatus = 'Awaiting Validation (15 min left)'.obs;
  RxString validationTimeRemaining = '15 min left'.obs;

  // Fund Distribution Data
  final List<Map<String, dynamic>> fundDistribution = [
    {
      'split': 'Helper',
      'amount': 85.00,
      'status': 'Released instantly',
      'statusColor': 'pending',
    },
    {
      'split': 'Platform',
      'amount': 7.50,
      'status': 'Released instantly',
      'statusColor': 'success',
    },
    {
      'split': 'Validator Pool',
      'amount': 7.50,
      'status': 'Pending consensus',
      'statusColor': 'pending',
    },
  ];

  // Methods
  void viewTaskDetails() {
    DialogHelpers.showTaskDetailsInfo();
    // TODO: Navigate to task details screen
  }

  void updateValidationStatus() {
    // Simulate countdown
    int timeRemaining = 15;
    Future.delayed(const Duration(seconds: 1), () {
      if (timeRemaining > 0) {
        timeRemaining--;
        validationTimeRemaining.value = '$timeRemaining min left';
        updateValidationStatus();
      } else {
        validationStatus.value = 'Validation Complete';
        validationTimeRemaining.value = 'Completed';
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    updateValidationStatus();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
