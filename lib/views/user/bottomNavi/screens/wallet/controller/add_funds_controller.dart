import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/services/fatora_service.dart';
import '../tabs/fatora_checkout_screen.dart';
import 'wallet_controller.dart';

class AddFundsController extends GetxController {
  final WalletService _walletService = WalletService();
  final WalletController walletController = Get.find<WalletController>();

  // Observable variables
  RxString selectedAmount = '25'.obs;
  RxString customAmount = ''.obs;
  RxString selectedPaymentMethod = 'card'.obs; // Default to card
  RxBool isLoading = false.obs;

  // Predefined amounts
  final List<String> predefinedAmounts = ['25', '50', '100', '250', '500'];

  // Payment methods
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'card',
      'title': 'Credit / Debit Card',
      'subtitle': 'Visa, Mastercard, Amex',
      'icon': 'assets/images/card.png',
    },
    // {
    //   'id': 'paypal',
    //   'title': 'PayPal',
    //   'subtitle': 'Fast & secure',
    //   'icon': 'assets/images/paypal.png',
    // },
    // {
    //   'id': 'wallet',
    //   'title': 'STC Pay / Apple Pay',
    //   'subtitle': 'Mobile wallet',
    //   'icon': 'assets/images/iphone.png',
    // },
    {
      'id': 'redballoon',
      'title': 'Redeem Red Balloon Card',
      'subtitle': 'Use gift card or promo',
      'icon': 'assets/images/red_ballon.png',
    },
  ];

  // Getters
  String get finalAmount =>
      customAmount.value.isNotEmpty ? customAmount.value : selectedAmount.value;

  bool get isPaymentMethodSelected => selectedPaymentMethod.value.isNotEmpty;

  bool get isAmountValid {
    try {
      final amount = double.parse(finalAmount);
      return amount >= 15;
    } catch (e) {
      return false;
    }
  }

  // Methods
  void selectAmount(String amount) {
    selectedAmount.value = amount;
    customAmount.value = '';
  }

  void setCustomAmount(String amount) {
    customAmount.value = amount;
  }

  void selectPaymentMethod(String methodId) {
    selectedPaymentMethod.value = methodId;
  }

  void addFunds(BuildContext context) {
    if (!isAmountValid) {
      DialogHelpers.showAddFundsError('Minimum top-up is SAR 15');
      return;
    }

    // Show confirmation dialog
    DialogHelpers.showAddFundsConfirmationDialog(
      context: context,
      amount: finalAmount,
      onConfirm: () async {
        try {
          isLoading.value = true;
          final double amountToAdd = double.parse(finalAmount);
          final currentUser = FirebaseAuth.instance.currentUser;

          if (selectedPaymentMethod.value == 'redballoon') {
            DialogHelpers.showAddFundsError('Red Balloon Card redemption is not implemented yet.');
            isLoading.value = false;
            return;
          }

          // 1. Get Checkout URL from Fatora
          final String? checkoutUrl = await FatoraService.initiatePayment(
            amount: amountToAdd,
            customerName: currentUser?.displayName ?? 'User',
            customerEmail: currentUser?.email ?? 'user@example.com',
            note: 'Add Funds to Red Balloon Wallet',
          );

          if (checkoutUrl != null) {
            // 2. Open WebView for payment
            await Get.to(() => FatoraCheckoutScreen(
              checkoutUrl: checkoutUrl,
              onSuccess: (invoiceId) async {
                // Payment was successful, update balance in Firestore
                Get.back(); // Close webview
                
                final success = await _walletService.addFunds(amountToAdd);
                if (success) {
                  if (currentUser != null) {
                    NotificationService.instance.notifyFundsAdded(
                      userId: currentUser.uid,
                      amount: amountToAdd,
                    );
                  }

                  DialogHelpers.showAddFundsSuccess(
                    context: context,
                    amount: finalAmount,
                    paymentMethod: 'Fatora.io',
                    onDone: () {
                      Get.back(); // Navigate back to wallet
                    },
                  );
                } else {
                  DialogHelpers.showAddFundsError('Payment successful but failed to update wallet. Please contact support.');
                }
              },
              onFailure: () {
                Get.back(); // Close webview
                DialogHelpers.showAddFundsError('Payment failed or was cancelled.');
              },
            ));
          } else {
            DialogHelpers.showAddFundsError('Failed to initiate payment. Please try again.');
          }
        } catch (e) {
          DialogHelpers.showAddFundsError('An unexpected error occurred: ${e.toString()}');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  void clearSelection() {
    selectedAmount.value = '25';
    customAmount.value = '';
    selectedPaymentMethod.value = 'card';
  }

  @override
  void onClose() {
    super.onClose();
  }
}
