import 'package:get/get.dart';

enum WalletFilter { all, withdrawal, refund, escrow }

class WalletTransaction {
  final String id;
  final String amount;
  final String title;
  final String subtitle;
  final String timeAgo;
  final String type; // 'withdrawal', 'refund', 'escrow'
  final String iconPath;

  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.type,
    required this.iconPath,
  });
}

class WalletController extends GetxController {
  final selectedFilter = WalletFilter.all.obs;

  final transactions = <WalletTransaction>[].obs;

  // Summary values
  final lockedEscrow = 'SAR 25,400'.obs;
  final releasedWeekly = 'SAR 6,800'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    transactions.assignAll(const [
      WalletTransaction(
        id: 'RB-234',
        amount: 'SAR 450',
        title: 'Withdrawal Request',
        subtitle: '',
        timeAgo: '10 minutes ago',
        type: 'withdrawal',
        iconPath: 'assets/icons/cash.png',
      ),
      WalletTransaction(
        id: 'RB-104',
        amount: 'SAR 650',
        title: 'Refund Request',
        subtitle: 'Disputed Task',
        timeAgo: '8 hours ago',
        type: 'refund',
        iconPath: 'assets/icons/refresh.png',
      ),
      WalletTransaction(
        id: 'RB-789',
        amount: 'SAR 500',
        title: 'Escrow Release',
        subtitle: 'Task Completed',
        timeAgo: '8 hours ago',
        type: 'escrow',
        iconPath: 'assets/icons/shield.png',
      ),
      WalletTransaction(
        id: 'RB-445',
        amount: 'SAR 320',
        title: 'Withdrawal Request',
        subtitle: '',
        timeAgo: '8 hours ago',
        type: 'withdrawal',
        iconPath: 'assets/icons/cash.png',
      ),
      WalletTransaction(
        id: 'RB-892',
        amount: 'SAR 180',
        title: 'Refund Request',
        subtitle: 'Task Cancelled',
        timeAgo: '8 hours ago',
        type: 'refund',
        iconPath: 'assets/icons/refresh.png',
      ),
    ]);
  }

  void setFilter(WalletFilter filter) {
    selectedFilter.value = filter;
  }

  List<WalletTransaction> get filteredTransactions {
    switch (selectedFilter.value) {
      case WalletFilter.withdrawal:
        return transactions.where((t) => t.type == 'withdrawal').toList();
      case WalletFilter.refund:
        return transactions.where((t) => t.type == 'refund').toList();
      case WalletFilter.escrow:
        return transactions.where((t) => t.type == 'escrow').toList();
      case WalletFilter.all:
      default:
        return transactions;
    }
  }
}
