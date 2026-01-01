import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../custom_widgets/custom_container.dart';
import '../../../../../custom_widgets/customtext.dart';
import '../../../../../utils/colors.dart';
import 'controllers/wallet_controller.dart';
import 'widgets/admin_build_bottom_info_bar.dart';
import 'widgets/admin_build_filter_row.dart';
import 'widgets/admin_build_header.dart';
import 'widgets/admin_build_summary_row.dart';
import 'widgets/admin_wallet_transaction_card.dart';

import 'transaction_details/admin_transaction_details_screen.dart';
import 'withdrawal_requests/admin_withdrawal_details_screen.dart';

class AdminWalletTab extends StatelessWidget {
  const AdminWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(
      WalletController(),
      tag: 'admin_wallet',
      permanent: false,
    );
    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              adminBuildHeader(context),
              const SizedBox(height: 20),
              adminBuildSummaryRow(context),
              const SizedBox(height: 20),
              Obx(
                () => adminBuildFilterRow(
                  context,
                  selectedFilter: controller.selectedFilter.value,
                  onFilterSelected: controller.setFilter,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'Wallet Overview',
                        fontSize: 18,
                        fontWeight: FontVariant.bold,
                        color: black4Color,
                      ),
                      const SizedBox(height: 4),
                      const CustomText(
                        'This transactions are from the users',
                        fontSize: 14,
                        fontWeight: FontVariant.regular,
                        color: txColor,
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(color: redColor),
                            ),
                          );
                        }

                        if (controller.selectedFilter.value == WalletFilter.withdrawal) {
                          return _buildWithdrawalRequestsList(context, controller);
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

                        return Column(
                          children: [
                            for (int i = 0; i < items.length; i++) ...[
                              adminWalletTransactionCard(
                                context,
                                iconPath: items[i].iconPath,
                                iconBg: _iconBgForType(items[i].type),
                                id: controller.userMapping[items[i].userUid] ??
                                    items[i].id,
                                amount: items[i].amount,
                                title: items[i].title,
                                subtitle: items[i].subtitle,
                                timeAgo: items[i].timeAgo,
                                isWithDrawal: items[i].type == 'withdrawal',
                                onTap: () {
                                  Get.to(() => AdminTransactionDetailsScreen(
                                        transactionData: items[i].fullData,
                                        userUid: items[i].userUid,
                                        taskId: items[i].taskId,
                                      ));
                                },
                              ),
                              if (i != items.length - 1)
                                const SizedBox(height: 12),
                            ],
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              adminBuildBottomInfoBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawalRequestsList(BuildContext context, WalletController controller) {
    return Obx(() {
      final requests = controller.withdrawalRequests;
      if (requests.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CustomText('No pending withdrawal requests'),
          ),
        );
      }

      return Column(
        children: [
          for (var request in requests) ...[
            adminWalletTransactionCard(
              context,
              iconPath: 'assets/icons/cash.png',
              iconBg: iconBg2,
              id: controller.userMapping[request['uid']] ?? 'User',
              amount: 'SAR ${request['amount']}',
              title: 'Withdrawal Request',
              subtitle: '${request['bank']} - ${request['method']}',
              timeAgo: controller.getTimeAgo(request['createdAt'] as dynamic),
              isWithDrawal: true,
              onTap: () {
                // Navigate to withdrawal details
                _navigateToWithdrawalDetails(request);
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      );
    });
  }

  void _navigateToWithdrawalDetails(Map<String, dynamic> request) {
    Get.to(() => const AdminWithdrawalDetailsScreen(), arguments: request);
  }

  Color _iconBgForType(String type) {
    switch (type) {
      case 'withdrawal':
        return iconBg2;
      case 'refund':
        return iconBg3;
      case 'escrow':
        return iconBg4;
      default:
        return pinkColor;
    }
  }
}
