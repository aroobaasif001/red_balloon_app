import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../controller/withdraw_funds_controller.dart';
import '../widgets/custom_wallet_balance_card.dart';
import '../widgets/past_withdrawal_requests.dart';
import '../widgets/withdrawal_details_card.dart';

class WithdrawFunds extends StatelessWidget {
  const WithdrawFunds({super.key});

  @override
  Widget build(BuildContext context) {
    final WithdrawFundsController controller = Get.put(
      WithdrawFundsController(),
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Withdraw Funds'),
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  custom_withdraw_balance_card(),
                  SizedBox(height: 20),
                  WithdrawalDetailsCard(
                    amountController: controller.amountController,
                    paymentMethodController: controller.paymentMethodController,
                    onButtonPressed: controller.submitWithdrawal,
                  ),
                  SizedBox(height: 20),
                  PastWithdrawalRequests(
                    withdrawalRequests: [
                      WithdrawalRequest(
                        date: 'Nov 3, 2025',
                        amount: 'SAR 150.00',
                        status: 'Completed',
                      ),
                      WithdrawalRequest(
                        date: 'Oct 31, 2025',
                        amount: 'SAR 100.00',
                        status: 'Pending',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
