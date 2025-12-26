import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_balloon_app/services/notification_services.dart';

class HomeTabsController extends GetxController
    with GetTickerProviderStateMixin { // Changed to GetTickerProviderStateMixin if needed, but Single was fine
  late TabController tabController;

  // Reactive index for your custom tabs
  RxInt selectedTab = 0.obs;

  // Metrics
  RxInt activeTasksCount = 0.obs;
  RxInt disputesCount = 0.obs;
  RxInt pendingWithdrawalsCount = 0.obs;
  RxDouble totalEscrowBalance = 0.0.obs;

  // Alerts
  RxList<Map<String, dynamic>> taskAlerts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> validationAlerts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> walletAlerts = <Map<String, dynamic>>[].obs;

  StreamSubscription? _metricsSubscription;
  StreamSubscription? _tasksSubscription;
  StreamSubscription? _withdrawalsSubscription;
  StreamSubscription? _validationsSubscription;
  StreamSubscription? _walletSubscription;
  Timer? _alertRefreshTimer;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();

    // 3 tabs: TASK, VALIDATION, WALLET
    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTab.value = tabController.index;
      }
    });
    
    _startListeningToMetrics();
    _startListeningToAlerts();
    _startListeningToWallet();
    _startAlertRefreshTimer();
    
    _checkNotificationPermission();
  }

  void _startAlertRefreshTimer() {
    // Refresh alerts every minute to remove those older than 20 minutes
    _alertRefreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _filterAlerts();
    });
  }

  void _filterAlerts() {
    final now = DateTime.now();
    final twentyMinutesAgo = now.subtract(const Duration(minutes: 20));

    taskAlerts.value = taskAlerts.where((alert) {
      final time = alert['eventTime'] as DateTime?;
      return time != null && time.isAfter(twentyMinutesAgo);
    }).toList();

    validationAlerts.value = validationAlerts.where((alert) {
      final time = alert['eventTime'] as DateTime?;
      return time != null && time.isAfter(twentyMinutesAgo);
    }).toList();

    walletAlerts.value = walletAlerts.where((alert) {
      final time = alert['eventTime'] as DateTime?;
      return time != null && time.isAfter(twentyMinutesAgo);
    }).toList();
  }

  void _startListeningToAlerts() {
    // Listen to Tasks for Task alerts (Disputes/Help Requests)
    _tasksSubscription = _firestore.collection('tasks').snapshots().listen((snapshot) {
      List<Map<String, dynamic>> newTaskAlerts = [];
      
      final now = DateTime.now();
      final twentyMinutesAgo = now.subtract(const Duration(minutes: 20));

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        final status = (data['status'] as String?)?.toLowerCase() ?? '';
        
        DateTime? eventTime;
        if (data['disputedStartTime'] != null) {
          eventTime = DateTime.tryParse(data['disputedStartTime']);
        } else if (data['updatedAt'] is Timestamp) {
          eventTime = (data['updatedAt'] as Timestamp).toDate();
        } else if (data['createdAt'] is String) {
          eventTime = DateTime.tryParse(data['createdAt']);
        } else if (data['createdAt'] is Timestamp) {
          eventTime = (data['createdAt'] as Timestamp).toDate();
        }

        data['eventTime'] = eventTime;

        if (eventTime != null && eventTime.isAfter(twentyMinutesAgo)) {
          bool helpRequested = (data['requesterHelpRequested'] == true) || 
                               (data['helperHelpRequested'] == true);
          
          if (status == 'disputed' || helpRequested) {
            data['alertType'] = status == 'disputed' ? 'Dispute' : 'Help Requested';
            data['iconPath'] = 'assets/icons/delay.png';
            newTaskAlerts.add(data);
          }
        }
      }
      
      taskAlerts.assignAll(newTaskAlerts);
    });

    // Listen to Validations specifically for Validation Alerts
    _validationsSubscription = _firestore
        .collection('validations')
        .where('isVotingCompleted', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> newValidationAlerts = [];
      
      final now = DateTime.now();
      final twentyMinutesAgo = now.subtract(const Duration(minutes: 20));

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        
        DateTime? eventTime;
        if (data['rejectedAt'] is Timestamp) {
          eventTime = (data['rejectedAt'] as Timestamp).toDate();
        } else if (data['completedAt'] is Timestamp) {
          eventTime = (data['completedAt'] as Timestamp).toDate();
        } else if (data['updatedAt'] is Timestamp) {
          eventTime = (data['updatedAt'] as Timestamp).toDate();
        }

        data['eventTime'] = eventTime;

        if (eventTime != null && eventTime.isAfter(twentyMinutesAgo)) {
          data['alertType'] = 'Validation Hub';
          data['iconPath'] = 'assets/icons/delay.png';
          data['title'] = data['taskTitle'] ?? 'Validation Hub Alert'; // Use taskTitle from validation doc
          newValidationAlerts.add(data);
        }
      }
      
      validationAlerts.assignAll(newValidationAlerts);
    });

    // Listen to Withdrawals for Wallet alerts
    _withdrawalsSubscription = _firestore.collectionGroup('withdrawals').snapshots().listen((snapshot) {
      List<Map<String, dynamic>> newWalletAlerts = [];
      int pendingCount = 0;
      
      final now = DateTime.now();
      final twentyMinutesAgo = now.subtract(const Duration(minutes: 20));

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        final status = (data['status'] as String?)?.toLowerCase() ?? '';
        
        if (status == 'pending') {
          pendingCount++;

          DateTime? eventTime;
          if (data['updatedAt'] is Timestamp) {
            eventTime = (data['updatedAt'] as Timestamp).toDate();
          } else if (data['createdAt'] is Timestamp) {
            eventTime = (data['createdAt'] as Timestamp).toDate();
          }

          data['eventTime'] = eventTime;

          if (eventTime != null && eventTime.isAfter(twentyMinutesAgo)) {
            data['alertType'] = 'Withdrawal Request';
            data['iconPath'] = 'assets/icons/wallet_3.png';
            newWalletAlerts.add(data);
          }
        }
      }
      
      pendingWithdrawalsCount.value = pendingCount;
      walletAlerts.assignAll(newWalletAlerts);
    });
  }

  void _startListeningToMetrics() {
    _metricsSubscription = _firestore.collection('tasks').snapshots().listen((snapshot) {
      int active = 0;
      int disputed = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = (data['status'] as String?)?.toLowerCase() ?? '';
        
        if (status == 'in progress' || status == 'active') {
          active++;
        } else if (status == 'disputed') {
          disputed++;
        }
      }

      activeTasksCount.value = active;
      disputesCount.value = disputed;
    });
  }

  void _startListeningToWallet() {
    _walletSubscription = _firestore.collection('wallet').snapshots().listen((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final balance = (data['escrowBalance'] ?? 0.0).toDouble();
        total += balance;
      }
      totalEscrowBalance.value = total;
    });
  }
  
  Future<void> _checkNotificationPermission() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await NotificationService.instance.initializeForUser(userId);
      }
    } catch (e) {
      print('⚠️ Error initializing notifications: $e');
    }
  }

  // Sync Custom Tabs → Flutter TabController
  void changeTab(int index) {
    selectedTab.value = index;
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    _metricsSubscription?.cancel();
    _tasksSubscription?.cancel();
    _withdrawalsSubscription?.cancel();
    _validationsSubscription?.cancel();
    _walletSubscription?.cancel();
    _alertRefreshTimer?.cancel();
    tabController.dispose();
    super.onClose();
  }
}
