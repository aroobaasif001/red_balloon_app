import 'package:get/get.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import '../tabs/add_funds.dart';
import '../tabs/transaction_history.dart';

class WalletController extends GetxController {
  // Observable variables
  RxDouble availableBalance = 255.00.obs;
  RxDouble lockedBalance = 100.00.obs;
  RxString currency = 'SAR'.obs;
  RxInt releaseTimeHours = 47.obs;
  RxInt releaseTimeMinutes = 12.obs;
  RxDouble releaseProgress = 0.65.obs; // 0 to 1

  // Recent transactions list
  RxList<Map<String, dynamic>> recentTransactions = <Map<String, dynamic>>[
    {
      'type': 'completed',
      'title': 'Task Completed',
      'description': 'Clean Solar Panels',
      'amount': '+50.00',
      'amountColor': walletSuccessColor.value,
      'daysAgo': '2 days ago',
      'icon': 'assets/icons/check_circle.png',
    },
    {
      'type': 'posted',
      'title': 'Task Posted',
      'description': 'Move Furniture',
      'amount': '-100.00',
      'amountColor': walletErrorColor.value,
      'daysAgo': '3 days ago',
      'icon': 'assets/icons/arrow_down.png',
    },
    {
      'type': 'added',
      'title': 'Funds Added',
      'description': 'Bank Transfer',
      'amount': '+200.00',
      'amountColor': walletSuccessColor.value,
      'daysAgo': '1 week ago',
      'icon': 'assets/icons/check_circle.png',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize any data fetching here
  }

  void addFunds() {
    Get.to(() => AddFunds());
  }

  void viewAllTransactions() {
    Get.to(() => TransactionHistory());
  }

  void learnMore() {
    // Show more info about fund release
    DialogHelpers.showFundReleaseInfo();
  }
}
