import 'package:get/get.dart';

class AdminProfileController extends GetxController {
  // Example observable profile fields
  final name = 'Sarah Mitchell'.obs;
  final code = 'ARB-0987'.obs;
  final email = 'sarah.m@email.com'.obs;
  final phone = '+1 415-555-0192'.obs;
  final city = 'San Francisco, CA'.obs;
  final walletBalance = '\$1,247.50'.obs;
  final warningsIssued = 0.obs;
  final lastActive = '2 hours ago'.obs;

  final notificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }
}
