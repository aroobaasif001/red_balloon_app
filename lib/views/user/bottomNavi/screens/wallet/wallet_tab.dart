import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/wallet/tabs/escrow_detail.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/wallet/tabs/withdraw_funds.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/wallet/tabs/transaction_details_screen.dart';

import '../../../../../custom_widgets/custom_appbar.dart';
import '../../../../../custom_widgets/transaction_item.dart';
import '../../../../../custom_widgets/customtext.dart';
import '../../../../../custom_widgets/wallet_balance_card.dart';
import 'controller/wallet_controller.dart';
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
                    backgroundColor: white2Color,
                    titleColor: blackColor,
                    currencyColor: blackColor,
                    balanceColor: blackColor,
                    subTitleColor: blackColor,
                    currency: controller.currency.value,
                    balance: controller.availableBalance.value,
                    subtitle: 'Ready to use for new tasks or withdrawal.',
                    onAddFunds: controller.addFunds,
                    buttonBackgroundColor: redColor,
                    buttonForegroundColor: whiteColor,
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

                // Recent Transactions Header
                TransactionsHeader(onViewAll: controller.viewAllTransactions),

                // Recent Transactions List
                Obx(
                  () => controller.recentTransactions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/icons/withdraw.png', // Fallback icon, maybe there's a better one
                                  height: 60,
                                  width: 60,
                                  color: grey2Color.withOpacity(0.5),
                                ),
                                const SizedBox(height: 15),
                                CustomText(
                                  "No Transactions Yet",
                                  fontSize: 16,
                                  color: grey2Color,
                                  fontWeight: FontVariant.medium,
                                ),
                                const SizedBox(height: 8),
                                CustomText(
                                  "Your transaction history will appear here.",
                                  fontSize: 13,
                                  color: grey2Color.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.recentTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                controller.recentTransactions[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => TransactionDetailsScreen(
                                    transactionData: transaction));
                              },
                              child: TransactionItem(
                                title: transaction['title'],
                                description: transaction['description'],
                                amount: transaction['amount'],
                                amountColor: Color(transaction['amountColor']),
                                daysAgo: transaction['daysAgo'],
                                iconPath: transaction['icon'],
                              ),
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
