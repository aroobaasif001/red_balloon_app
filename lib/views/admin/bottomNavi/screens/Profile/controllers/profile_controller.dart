import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/wallet/tabs/transaction_history.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/controllers/notification_permission_controller.dart';

class AdminProfileController extends GetxController {
  final WalletService _walletService = WalletService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Initialize NotificationPermissionController
  late final NotificationPermissionController _permissionController;

  // Profile fields
  final name = 'Sarah Mitchell'.obs;
  final code = 'ARB-0987'.obs;
  final email = 'sarah.m@email.com'.obs;
  final phone = '+1 415-555-0192'.obs;
  final city = 'San Francisco, CA'.obs;
  final lastActive = '2 hours ago'.obs;

  // Real data
  final walletBalance = 'SAR 0.00'.obs;
  final warningsIssued = 0.obs;

  // Notification enabled state - proxies to permission controller
  RxBool get notificationsEnabled => _permissionController.isNotificationEnabled;

  @override
  void onInit() {
    super.onInit();
    _permissionController = Get.put(NotificationPermissionController(), permanent: true);
    _bindWalletData();
    _fetchWarningsCount();
  }

  void _bindWalletData() {
    _walletService.getWalletBalance().listen((balance) {
      walletBalance.value = 'SAR ${balance.toStringAsFixed(2)}';
    });
  }

  Future<void> _fetchWarningsCount() async {
    try {
      final snapshot = await _firestore.collection('warning_issued').count().get();
      warningsIssued.value = snapshot.count ?? 0;
    } catch (e) {
      print('Error fetching warnings count: $e');
    }
  }

  void toggleNotifications(bool value) async {
    await _permissionController.handleToggle(value);
  }
  
  void navigateToTransactions() {
    // Re-use User Transaction History Screen
    Get.to(() => const TransactionHistory());
  }
}
