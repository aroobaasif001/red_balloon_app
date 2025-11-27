import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

class AddFundsController extends GetxController {
  // Observable variables
  RxString selectedAmount = '25'.obs;
  RxString customAmount = ''.obs;
  RxString selectedPaymentMethod = ''.obs;

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
    {
      'id': 'paypal',
      'title': 'PayPal',
      'subtitle': 'Fast & secure',
      'icon': 'assets/images/paypal.png',
    },
    {
      'id': 'wallet',
      'title': 'STC Pay / Apple Pay',
      'subtitle': 'Mobile wallet',
      'icon': 'assets/images/iphone.png',
    },
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

  void addFunds() {
    if (!isAmountValid) {
      DialogHelpers.showAddFundsError('Minimum top-up is SAR 15');
      return;
    }

    if (!isPaymentMethodSelected) {
      DialogHelpers.showAddFundsError('Please select a payment method');
      return;
    }

    // Process payment
    DialogHelpers.showAddFundsSuccess(
      finalAmount,
      selectedPaymentMethod.toString(),
    );

    // Here you would typically call an API to process the payment
    // After successful payment, navigate back
    // Get.back();
  }

  void clearSelection() {
    selectedAmount.value = '25';
    customAmount.value = '';
    selectedPaymentMethod.value = '';
  }

  @override
  void onClose() {
    super.onClose();
  }
}
