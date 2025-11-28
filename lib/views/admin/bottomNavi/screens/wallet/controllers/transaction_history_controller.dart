import 'package:get/get.dart';

enum TransactionHistoryFilter { all, escrow, withdrawals, refunds, releases }

class TransactionHistoryItem {
  final String id;
  final String type;
  final String code;
  final double amount;
  final bool isPositive;
  final String name;
  final String role;
  final String time;

  TransactionHistoryItem({
    required this.id,
    required this.type,
    required this.code,
    required this.amount,
    required this.isPositive,
    required this.name,
    required this.role,
    required this.time,
  });
}

class TransactionHistoryController extends GetxController {
  final selectedFilter = TransactionHistoryFilter.all.obs;

  final transactions = <TransactionHistoryItem>[
    TransactionHistoryItem(
      id: '1',
      type: 'Escrow Release',
      code: 'RB-789',
      amount: 500,
      isPositive: true,
      name: 'Anton Furnitures',
      role: 'Helper',
      time: 'Oct 22, 2:30 PM',
    ),
    TransactionHistoryItem(
      id: '2',
      type: 'Withdrawal',
      code: 'RB-234',
      amount: 450,
      isPositive: false,
      name: 'Ahmed Al-Harbi',
      role: 'User',
      time: 'Oct 20, 4:15 PM',
    ),
    TransactionHistoryItem(
      id: '3',
      type: 'Refund',
      code: 'RB-892',
      amount: 180,
      isPositive: false,
      name: 'Reem Saeed',
      role: 'User',
      time: 'Oct 18, 10:22 AM',
    ),
    TransactionHistoryItem(
      id: '4',
      type: 'Platform Fee',
      code: 'RB-445',
      amount: 12,
      isPositive: true,
      name: 'Platform Revenue',
      role: 'System',
      time: 'Oct 18, 9:45 AM',
    ),
  ].obs;

  void setFilter(TransactionHistoryFilter filter) {
    selectedFilter.value = filter;
  }

  List<TransactionHistoryItem> get filteredTransactions {
    switch (selectedFilter.value) {
      case TransactionHistoryFilter.escrow:
        return transactions
            .where((t) => t.type.toLowerCase().contains('escrow'))
            .toList();
      case TransactionHistoryFilter.withdrawals:
        return transactions
            .where((t) => t.type.toLowerCase().contains('withdrawal'))
            .toList();
      case TransactionHistoryFilter.refunds:
        return transactions
            .where((t) => t.type.toLowerCase().contains('refund'))
            .toList();
      case TransactionHistoryFilter.releases:
        return transactions
            .where((t) => t.type.toLowerCase().contains('release'))
            .toList();
      case TransactionHistoryFilter.all:
      default:
        return transactions;
    }
  }
}
