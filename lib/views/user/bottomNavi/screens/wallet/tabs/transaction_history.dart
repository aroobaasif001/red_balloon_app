import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../custom_widgets/transaction_item.dart';
import '../controller/wallet_controller.dart';
import 'transaction_details_screen.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Transaction History'),
        body: CustomContainer(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Recent Transactions List
                Obx(
                  () {
                    if (controller.allTransactions.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              CustomText(
                                "No transaction history",
                                fontSize: 16,
                                color: Colors.grey[500]!,
                                fontWeight: FontVariant.medium,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.allTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = controller.allTransactions[index];
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
                    );
                  },
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
