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

class AdminWalletTab extends StatelessWidget {
  const AdminWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(
      WalletController(),
      permanent: false,
    );
    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                        final items = controller.filteredTransactions;
                        return Column(
                          children: [
                            for (int i = 0; i < items.length; i++) ...[
                              adminWalletTransactionCard(
                                context,
                                iconPath: items[i].iconPath,
                                iconBg: _iconBgForType(items[i].type),
                                id: items[i].id,
                                amount: items[i].amount,
                                title: items[i].title,
                                subtitle: items[i].subtitle,
                                timeAgo: items[i].timeAgo,
                                isWithDrawal: items[i].type == 'withdrawal',
                              ),
                              if (i != items.length - 1)
                                const SizedBox(height: 12),
                            ],
                          ],
                        );
                      }),
                      const SizedBox(height: 80),
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
