import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/tabs/escrow_detail.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/tabs/withdraw_funds.dart';

import '../../../../custom_widgets/custom_appbar.dart';
import '../../../../custom_widgets/transaction_item.dart';
import '../../../../custom_widgets/wallet_balance_card.dart';
import 'controller/wallet_controller.dart';
import 'widgets/info_card.dart';
import 'widgets/locked_balance_card.dart';
import 'widgets/transactions_header.dart';

class WalletTab extends StatelessWidget {
  WalletTab({super.key});

  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          disableLeading: true,
          titleText: 'Wallet',
          action: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                onTap: () {
                  Get.to(() => WithdrawFunds());
                },
                child: Center(
                  child: Image.asset(
                    'assets/icons/withdraw.png',
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: CustomContainer(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 70),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Available Balance Card
                Obx(
                  () => WalletBalanceCard(
                    currency: controller.currency.value,
                    balance: controller.availableBalance.value,
                    subtitle: 'Ready to use for new tasks or withdrawal.',
                    onAddFunds: controller.addFunds,
                  ),
                ),

                // Locked Balance Card
                InkWell(
                  onTap: () {
                    Get.to(() => EscrowDetail());
                  },
                  child: Obx(
                    () => LockedBalanceCard(
                      currency: controller.currency.value,
                      balance: controller.lockedBalance.value,
                      subtitle: 'Held securely until validation is complete.',
                      hoursRemaining: controller.releaseTimeHours.value,
                      minutesRemaining: controller.releaseTimeMinutes.value,
                      releaseProgress: controller.releaseProgress.value,
                    ),
                  ),
                ),

                // Info Card
                InfoCard(
                  message:
                      'Funds are auto-released after successful validation.',
                  linkText: 'Learn more',
                  onLinkTap: controller.learnMore,
                ),

                // Recent Transactions Header
                TransactionsHeader(onViewAll: controller.viewAllTransactions),

                // Recent Transactions List
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.recentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = controller.recentTransactions[index];
                      return TransactionItem(
                        title: transaction['title'],
                        description: transaction['description'],
                        amount: transaction['amount'],
                        amountColor: Color(transaction['amountColor']),
                        daysAgo: transaction['daysAgo'],
                        iconPath: transaction['icon'],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
