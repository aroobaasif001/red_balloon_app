import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

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
  final isLoading = false.obs;

  // Summary values
  final lockedEscrow = 'SAR 0'.obs;
  final releasedWeekly = 'SAR 0'.obs;

  StreamSubscription? _transactionSubscription;
  StreamSubscription? _escrowSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _listenToAllTransactions();
    _listenToEscrowTotals();
  }

  void _listenToEscrowTotals() {
    _escrowSubscription = _firestore.collection('wallet').snapshots().listen((snapshot) {
      double totalEscrow = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        totalEscrow += (data['escrowBalance'] ?? 0.0).toDouble();
      }
      lockedEscrow.value = 'SAR ${NumberFormat('#,##0').format(totalEscrow)}';
    });
  }

  void _listenToAllTransactions() {
    isLoading.value = true;
    _transactionSubscription = _firestore
        .collectionGroup('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      List<WalletTransaction> allTrans = [];
      double weeklyTotal = 0.0;
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final title = data['title']?.toString() ?? 'Transaction';
        final amountVal = (data['amount'] ?? 0.0).toDouble();
        final createdAtTs = data['createdAt'] as Timestamp?;
        final createdAt = createdAtTs?.toDate() ?? DateTime.now();
        final taskId = data['taskId']?.toString() ?? 'N/A';

        String walletType = 'other';
        String iconPath = 'assets/icons/cash.png';

        // Categorize
        if (title.contains('Refund') || title.contains('Partial') || title.contains('Dispute') || title.contains('Dismissed')) {
          walletType = 'refund';
          iconPath = 'assets/icons/refresh.png';
          
          // Add to weekly total if within 7 days
          if (createdAt.isAfter(sevenDaysAgo)) {
            weeklyTotal += amountVal;
          }
        } else if (title.contains('Escrow') || title.contains('Payment Received') || title.contains('Payment')) {
          walletType = 'escrow';
          iconPath = 'assets/icons/shield.png';

          // Add to weekly total if it's a release (Helper receiving money)
          if ((title.contains('Payment') || title.contains('Released')) && createdAt.isAfter(sevenDaysAgo)) {
             weeklyTotal += amountVal;
          }
        } else if (title.contains('Withdrawal')) {
          walletType = 'withdrawal';
          iconPath = 'assets/icons/cash.png';
        }

        allTrans.add(WalletTransaction(
          id: taskId.startsWith('RB-') ? taskId : 'RB-${taskId.substring(0, min(5, taskId.length))}',
          amount: 'SAR ${amountVal.toStringAsFixed(1)}',
          title: title,
          subtitle: data['description']?.toString() ?? '',
          timeAgo: _getTimeAgo(createdAtTs),
          type: walletType,
          iconPath: iconPath,
        ));
      }
      transactions.value = allTrans;
      releasedWeekly.value = 'SAR ${NumberFormat('#,##0').format(weeklyTotal)}';
      isLoading.value = false;
    }, onError: (e) {
      print('Error listening to transactions: $e');
      isLoading.value = false;
    });
  }

  int min(int a, int b) => a < b ? a : b;

  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return "Just now";
    final diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return DateFormat('dd MMM yyyy').format(timestamp.toDate());
  }

  void setFilter(WalletFilter filter) {
    selectedFilter.value = filter;
  }

  List<WalletTransaction> get filteredTransactions {
    if (selectedFilter.value == WalletFilter.all) return transactions;
    return transactions.where((t) => t.type == selectedFilter.value.name).toList();
  }

  @override
  void onClose() {
    _transactionSubscription?.cancel();
    super.onClose();
  }
}
