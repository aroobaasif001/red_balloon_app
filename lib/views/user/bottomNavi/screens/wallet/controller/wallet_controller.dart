import 'package:get/get.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import '../tabs/add_funds.dart';
import '../tabs/transaction_history.dart';

import 'package:intl/intl.dart';

class WalletController extends GetxController {
  final WalletService _walletService = WalletService();

  // Observable variables
  RxDouble availableBalance = 0.00.obs; // Initially zero as requested
  RxDouble lockedBalance = 0.00.obs;
  RxString currency = 'SAR'.obs;
  RxInt releaseTimeHours = 0.obs;
  RxInt releaseTimeMinutes = 0.obs;
  RxDouble releaseProgress = 0.0.obs; // 0 to 1

  // Recent and all transactions lists
  RxList<Map<String, dynamic>> recentTransactions = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> allTransactions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _bindWalletData();
  }

  void _bindWalletData() {
    // Listen to real-time balance updates
    availableBalance.bindStream(_walletService.getWalletBalance());
    lockedBalance.bindStream(_walletService.getLockedBalance());

      _walletService.getTransactions().listen((list) {
      final processedList = list.map((item) {
        final isCredit = item['type'] == 'credit';
        final double rawAmount = (item['amount'] ?? 0.0).toDouble();
        
        // Floor to 2 decimal places if more than 2 digits after dot
        final double flooredAmount = (rawAmount * 100).floorToDouble() / 100;
        final String amountStr = flooredAmount.toString().endsWith('.0') 
            ? flooredAmount.toInt().toString() 
            : flooredAmount.toString();

        return {
          'type': item['type'],
          'title': item['title'],
          'description': item['description'],
          'amount': '${isCredit ? '+' : '-'}$amountStr',
          'amountColor': isCredit ? walletSuccessColor.value : walletErrorColor.value,
          'daysAgo': _formatDate(item['createdAt']),
          'icon': isCredit ? 'assets/icons/check_circle.png' : 'assets/icons/arrow_down.png',
        };
      }).toList();

      // Update all transactions
      allTransactions.assignAll(processedList);

      // Update recent transactions (Bss latest 4)
      recentTransactions.assignAll(
        processedList.length > 4 ? processedList.take(4).toList() : processedList,
      );
    });
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'just now';
    if (timestamp is DateTime) {
      return DateFormat('dd MMM, yyyy').format(timestamp);
    }
    // Handle Firestore Timestamp
    try {
      final date = (timestamp as dynamic).toDate();
      return DateFormat('dd MMM, yyyy').format(date);
    } catch (e) {
      return 'Recently';
    }
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
