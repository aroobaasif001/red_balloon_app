import 'package:get/get.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/services/task_service.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EscrowDetailController extends GetxController {
  final WalletService _walletService = WalletService();
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable variables
  RxDouble amountHeld = 0.0.obs;
  RxString currency = 'SAR'.obs;
  RxString taskName = 'Current Active Task'.obs;
  RxString validationStatus = 'Awaiting Validation'.obs;
  RxString validationTimeRemaining = '15 min left'.obs;
  RxBool isDistributionExpanded = false.obs;
  RxBool isTasksExpanded = false.obs;
  RxList<TaskModel> userTasks = <TaskModel>[].obs;

  // Fund Distribution Data
  final RxList<Map<String, dynamic>> fundDistribution = <Map<String, dynamic>>[].obs;

  void _updateDistribution() {
    final amount = amountHeld.value;
    fundDistribution.assignAll([
      {
        'split': 'Helper',
        'amount': amount * 0.85,
        'status': 'Released instantly',
        'statusColor': 'pending',
      },
      {
        'split': 'Platform',
        'amount': amount * 0.075,
        'status': 'Released instantly',
        'statusColor': 'success',
      },
      {
        'split': 'Validator Pool',
        'amount': amount * 0.075,
        'status': 'Pending consensus',
        'statusColor': 'pending',
      },
    ]);
  }

  // Methods
  void viewTaskDetails() {
    DialogHelpers.showTaskDetailsInfo();
  }

  void updateValidationStatus() {
    // Simulate countdown
    int timeRemaining = 15;
    Future.delayed(const Duration(seconds: 1), () {
      if (timeRemaining > 0) {
        timeRemaining--;
        validationTimeRemaining.value = '$timeRemaining min left';
        validationStatus.value = 'Awaiting Validation ($timeRemaining min left)';
        updateValidationStatus();
      } else {
        validationStatus.value = 'Validation Complete';
        validationTimeRemaining.value = 'Completed';
      }
    });
  }

  void _listenToTasks() {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      _taskService.streamUserTasks(uid).listen((tasks) {
        // Filter out completed, refunded, and dispute dismissed tasks as requested
        userTasks.assignAll(tasks.where((task) {
          final status = task.status.toLowerCase();
          return status != 'completed' && 
                 status != 'refunded' && 
                 status != 'dispute dismissed';
        }).toList());
      });
    }
  }

  void toggleDistribution() {
    isDistributionExpanded.value = !isDistributionExpanded.value;
  }

  void toggleTasks() {
    isTasksExpanded.value = !isTasksExpanded.value;
  }

  @override
  void onInit() {
    super.onInit();
    amountHeld.bindStream(_walletService.getLockedBalance());
    ever(amountHeld, (_) => _updateDistribution());
    updateValidationStatus();
    _listenToTasks();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
