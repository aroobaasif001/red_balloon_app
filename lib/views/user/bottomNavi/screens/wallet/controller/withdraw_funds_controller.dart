import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class WithdrawFundsController extends GetxController {
  final WalletService _walletService = WalletService();

  // Controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController bankController = TextEditingController(text: 'Select Bank');
  final TextEditingController bankAccountController = TextEditingController();

  // Observable state
  RxDouble availableBalance = 0.0.obs;
  RxDouble escrowBalance = 0.0.obs;
  
  RxList<Map<String, dynamic>> pastWithdrawals = <Map<String, dynamic>>[].obs;
  
  final List<String> methods = ['Bank Transfer', 'Mobile Wallet'];
  final Map<String, List<String>> banksByMethod = {
    'Bank Transfer': ['United Bank Limited (UBL)', 'Habib Bank Limited (HBL)', 'Bank Alfalah', 'Meezan Bank'],
    'Mobile Wallet': ['JazzCash', 'EasyPaisa', 'SadaPay'],
  };
  
  final Map<String, double> withdrawalLimits = {
    'United Bank Limited (UBL)': 50000.0,
    'Habib Bank Limited (HBL)': 45000.0,
    'Bank Alfalah': 40000.0,
    'Meezan Bank': 60000.0,
    'JazzCash': 25000.0,
    'EasyPaisa': 25000.0,
    'SadaPay': 30000.0,
  };

  RxString selectedMethod = 'Bank Transfer'.obs;
  RxString selectedBank = 'Select Bank'.obs;
  RxDouble currentMaxLimit = 2000.0.obs; // Default fallback

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    paymentMethodController.text = 'Bank Transfer';
    _bindData();
  }

  void _bindData() {
    availableBalance.bindStream(_walletService.getWalletBalance());
    escrowBalance.bindStream(_walletService.getLockedBalance());
    
    // Bind past withdrawals
    _walletService.getWithdrawalRequestsStream().listen((list) {
      pastWithdrawals.assignAll(list);
    });
  }

  void showMethodSelection() {
    Get.bottomSheet(
      SafeArea(
        child: CustomContainer(
          conColor: whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText('Select Payment Method', fontSize: 18, fontWeight: FontVariant.bold),
              const SizedBox(height: 20),
              ...methods.map((method) => ListTile(
                title: CustomText(method),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  setMethod(method);
                  Get.back();
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void showBankSelection() {
    if (selectedMethod.value.isEmpty) {
      Get.snackbar('Alert', 'Please select a payment method first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final banks = banksByMethod[selectedMethod.value] ?? [];

    Get.bottomSheet(
      SafeArea(
        child: CustomContainer(
          conColor: whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText('Select ${selectedMethod.value}', fontSize: 18, fontWeight: FontVariant.bold),
              const SizedBox(height: 20),
              ...banks.map((bank) => ListTile(
                title: CustomText(bank),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  setBank(bank);
                  Get.back();
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    paymentMethodController.dispose();
    bankController.dispose();
    bankAccountController.dispose();
    super.onClose();
  }

  void setMethod(String method) {
    selectedMethod.value = method;
    paymentMethodController.text = method;
    // Reset bank selection
    selectedBank.value = 'Select Bank';
    bankController.text = 'Select Bank';
    currentMaxLimit.value = 2000.0;
  }

  void setBank(String bank) {
    selectedBank.value = bank;
    bankController.text = bank;
    currentMaxLimit.value = withdrawalLimits[bank] ?? 2000.0;
  }

  Future<void> submitWithdrawal() async {
    // 1. Validation
    if (amountController.text.isEmpty) {
      DialogHelpers.showAddFundsError('Please enter amount');
      return;
    }

    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0) {
      DialogHelpers.showAddFundsError('Invalid amount');
      return;
    }

    if (amount < 50) {
      DialogHelpers.showAddFundsError('Minimum withdrawal is SAR 50');
      return;
    }

    if (amount > availableBalance.value) {
      DialogHelpers.showAddFundsError('Insufficient balance');
      return;
    }

    if (amount > currentMaxLimit.value) {
      DialogHelpers.showAddFundsError('Amount exceeds bank limit');
      return;
    }

    if (selectedMethod.value.isEmpty || selectedBank.value == 'Select Bank') {
      DialogHelpers.showAddFundsError('Please select payment method and bank');
      return;
    }

    if (bankAccountController.text.isEmpty) {
      DialogHelpers.showAddFundsError('Please enter account number / IBAN');
      return;
    }

    // 2. Confirmation
    try {
      isLoading.value = true;
      
      // In a real "test" mode, we could just simulate success without Firestore
      // But since user wants internal setup first, we go with Firestore requests.
      final success = await _walletService.requestWithdrawal(
        amount: amount,
        method: selectedMethod.value,
        bank: selectedBank.value,
        accountNumber: bankAccountController.text,
      );

      if (success) {
        // Clear fields
        amountController.clear();
        bankAccountController.clear();
        selectedBank.value = 'Select Bank';
        bankController.text = 'Select Bank';
        
        Get.snackbar(
          'Success', 
          'Withdrawal request submitted successfully. Admin will review it shortly.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        DialogHelpers.showAddFundsError('Failed to submit request. Please try again.');
      }
    } catch (e) {
      DialogHelpers.showAddFundsError('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String formatCurrency(double amount) {
    return 'SAR ${amount.toStringAsFixed(2)}';
  }
  
  String formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Pending';
    if (timestamp is DateTime) return DateFormat('MMM d, yyyy').format(timestamp);
    if (timestamp is Timestamp) return DateFormat('MMM d, yyyy').format(timestamp.toDate());
    return 'Recently';
  }
}
