import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../../../../../../custom_widgets/transaction_item.dart';
import '../controller/wallet_controller.dart';

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
