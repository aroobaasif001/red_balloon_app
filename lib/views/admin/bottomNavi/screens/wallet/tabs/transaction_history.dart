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
import '../transaction_details/admin_transaction_details_screen.dart';

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
              const SizedBox(height: 8),
              // Fixed Header Section
              adminBuildSummaryRow2(context),
              const SizedBox(height: 20),
              Obx(
                () => adminBuildFilterRow2(
                  context,
                  selectedFilter: controller.selectedFilter.value,
                  onFilterSelected: controller.setFilter,
                ),
              ),
              const SizedBox(height: 20),

              // Scrollable Items Section
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: redColor),
                    );
                  }

                  final items = controller.filteredTransactions;
                  if (items.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CustomText('No transactions found'),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final item in items) ...[
                          adminBuildTransactionCard2(
                            context,
                            typeLabel:
                                '${item.type} ${controller.userMapping[item.userUid] ?? item.code}',
                            amount:
                                '${item.isPositive ? '+' : '-'}SAR ${item.amount.toStringAsFixed(1)}',
                            isPositive: item.isPositive,
                            name: item.name,
                            role: item.role,
                            time: item.time,
                            status: item.status, // 🔥 Added status to reflect pending/completed
                            onTap: () {
                              Get.to(() => AdminTransactionDetailsScreen(
                                    transactionData: item.fullData,
                                    userUid: item.userUid,
                                    taskId: item.taskId,
                                  ));
                            },
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
                        const SizedBox(height: 30), // Bottom padding
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
