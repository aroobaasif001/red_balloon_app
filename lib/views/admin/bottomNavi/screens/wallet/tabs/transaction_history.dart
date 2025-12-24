import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controllers/transaction_history_controller.dart';
import '../widgets/admin_build_filter_row2.dart';
import '../widgets/admin_build_summary_row2.dart';
import '../widgets/admin_build_transaction_card2.dart';

class AdminTransactionHistory extends StatelessWidget {
  const AdminTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionHistoryController());
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: const CustomAppBar(titleText: 'Transaction History'),
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: CustomContainer(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: redColor),
                      );
                    }

                    if (controller.selectedFilter.value == TransactionHistoryFilter.withdrawals) {
                      return Column(
                        children: [
                          const SizedBox(height: 8),
                          adminBuildSummaryRow2(context),
                          const SizedBox(height: 20),
                          adminBuildFilterRow2(
                            context,
                            selectedFilter: controller.selectedFilter.value,
                            onFilterSelected: controller.setFilter,
                          ),
                          const SizedBox(height: 100),
                          const Center(
                            child: CustomText(
                              'Coming Soon',
                              fontSize: 18,
                              fontWeight: FontVariant.bold,
                              color: walletGrey500Color,
                            ),
                          ),
                        ],
                      );
                    }

                    final items = controller.filteredTransactions;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          adminBuildSummaryRow2(context),
                          const SizedBox(height: 20),
                          adminBuildFilterRow2(
                            context,
                            selectedFilter: controller.selectedFilter.value,
                            onFilterSelected: controller.setFilter,
                          ),
                          const SizedBox(height: 20),
                          if (items.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CustomText('No transactions found'),
                              ),
                            ),
                          for (final item in items) ...[
                            adminBuildTransactionCard2(
                              context,
                              typeLabel: '${item.type} ${item.code}',
                              amount: '${item.isPositive ? '+' : '-'}SAR ${item.amount.toStringAsFixed(1)}',
                              isPositive: item.isPositive,
                              name: item.name,
                              role: item.role,
                              time: item.time,
                            ),
                            const SizedBox(height: 12),
                          ],
                          const SizedBox(height: 4),
                          Center(
                            child: CustomText(
                              'Transaction history updates in real-time.',
                              fontSize: 12,
                              fontWeight: FontVariant.regular,
                              color: txColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
