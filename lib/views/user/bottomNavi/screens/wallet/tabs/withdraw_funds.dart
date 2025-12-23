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
                  Obx(() => custom_withdraw_balance_card(
                    availableAmount: controller.formatCurrency(controller.availableBalance.value),
                    lockedAmount: controller.formatCurrency(controller.escrowBalance.value),
                    maxWithdrawalLimitMessage: 'Maximum Withdrawal Limit: ${controller.formatCurrency(controller.currentMaxLimit.value)}',
                  )),
                  SizedBox(height: 20),
                  WithdrawalDetailsCard(
                    amountController: controller.amountController,
                    paymentMethodController: controller.paymentMethodController,
                    bankController: controller.bankController,
                    bankAccountController: controller.bankAccountController,
                    onMethodTap: controller.showMethodSelection,
                    onBankTap: controller.showBankSelection,
                    onButtonPressed: controller.submitWithdrawal,
                  ),
                  SizedBox(height: 20),
                  Obx(() => PastWithdrawalRequests(
                    withdrawalRequests: controller.pastWithdrawals.map((w) => WithdrawalRequest(
                      date: controller.formatDate(w['createdAt']),
                      amount: controller.formatCurrency((w['amount'] ?? 0.0).toDouble()),
                      status: w['status'] ?? 'Pending',
                    )).toList(),
                  )),
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
