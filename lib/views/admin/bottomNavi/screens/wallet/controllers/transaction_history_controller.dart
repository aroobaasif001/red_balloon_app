import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

enum TransactionHistoryFilter { all, escrow, withdrawals, refunds, releases }

class TransactionHistoryItem {
  final String userUid;
  final String id;
  final String taskId;
  final String type;
  final String code; // This will remain as a fallback
  final double amount;
  final bool isPositive;
  final String name;
  final String role;
  final String time;
  final Map<String, dynamic> fullData;

  TransactionHistoryItem({
    required this.userUid,
    required this.id,
    required this.taskId,
    required this.type,
    required this.code,
    required this.amount,
    required this.isPositive,
    required this.name,
    required this.role,
    required this.time,
    required this.fullData,
  });
}

class TransactionHistoryController extends GetxController {
  final selectedFilter = TransactionHistoryFilter.all.obs;
  final transactions = <TransactionHistoryItem>[].obs;
  final userMapping = <String, String>{}.obs; // uid -> userId (RB-XXX)
  final isLoading = true.obs;
  final moneySendTotal = 0.0.obs;

  StreamSubscription? _subscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _listenToUserMapping();
    _listenToTransactions();
  }

  void _listenToUserMapping() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      final map = <String, String>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final userId = data['userId']?.toString();
        if (userId != null) {
          map[doc.id] = userId;
        }
      }
      userMapping.value = map;
    });
  }

  void _listenToTransactions() {
    isLoading.value = true;
    _subscription = _firestore
        .collectionGroup('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      List<TransactionHistoryItem> fetchedItems = [];
      double totalSent = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final title = data['title']?.toString() ?? 'Transaction';
        final amount = (data['amount'] ?? 0.0).toDouble();
        final createdAt = data['createdAt'] as Timestamp?;
        final taskId = data['taskId']?.toString() ?? 'N/A';
        final description = data['description']?.toString() ?? '';

        // Match user's image signs/colors:
        // Red (-) for Refunds/Withdrawals/Partial outflows
        // Green (+) for Escrow Releases/Fees or everything else
        bool isPositive = true;
        if (title.contains('Refund') || title.contains('Withdrawal') || title.contains('Partial')) {
          isPositive = false;
        }

        // Only count actual OUTFLOWS (Money Sent to users) in the header total
        bool isOutflow = (title.contains('Refund') || 
                         title.contains('Payment') || 
                         title.contains('Released') || 
                         title.contains('Partial') || 
                         title.contains('Withdrawal')) && 
                        !title.contains('Posted'); // Exclude deposits like "Task Posted - Escrow"

        if (isOutflow) {
          totalSent += amount;
        }

        final userUid = doc.reference.parent.parent?.id ?? '';
        final realUserId = userMapping[userUid] ?? 
            (taskId.startsWith('RB-') ? taskId : (taskId != 'N/A' && taskId.isNotEmpty ? 'RB-${taskId.substring(0, _min(5, taskId.length))}' : ''));

        fetchedItems.add(TransactionHistoryItem(
          userUid: userUid,
          id: doc.id,
          taskId: taskId,
          type: title,
          code: taskId.startsWith('RB-') ? taskId : (taskId != 'N/A' && taskId.isNotEmpty ? 'RB-${taskId.substring(0, _min(5, taskId.length))}' : ''),
          amount: amount,
          isPositive: isPositive,
          name: title.contains('Platform') ? 'Platform Revenue' : (description.isNotEmpty ? description : 'User'),
          role: title.contains('Platform') ? 'System' : 'User/Helper',
          time: _formatTime(createdAt),
          fullData: data,
        ));
      }

      transactions.assignAll(fetchedItems);
      moneySendTotal.value = totalSent;
      isLoading.value = false;
    }, onError: (e) {
      print('Error loading transaction history: $e');
      isLoading.value = false;
    });
  }

  int _min(int a, int b) => a < b ? a : b;

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown";
    final date = timestamp.toDate();
    return DateFormat('MMM dd, h:mm a').format(date);
  }

  void setFilter(TransactionHistoryFilter filter) {
    selectedFilter.value = filter;
  }

  List<TransactionHistoryItem> get filteredTransactions {
    List<TransactionHistoryItem> result;
    switch (selectedFilter.value) {
      case TransactionHistoryFilter.escrow:
        result = transactions.where((t) => t.type.toLowerCase().contains('escrow')).toList();
        break;
      case TransactionHistoryFilter.withdrawals:
        result = transactions.where((t) => t.type.toLowerCase().contains('withdrawal')).toList();
        break;
      case TransactionHistoryFilter.refunds:
        result = transactions.where((t) => t.type.toLowerCase().contains('refund')).toList();
        break;
      case TransactionHistoryFilter.releases:
        result = transactions.where((t) => t.type.toLowerCase().contains('release') || t.type.toLowerCase().contains('payment')).toList();
        break;
      case TransactionHistoryFilter.all:
      default:
        result = transactions;
    }
    return result;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
