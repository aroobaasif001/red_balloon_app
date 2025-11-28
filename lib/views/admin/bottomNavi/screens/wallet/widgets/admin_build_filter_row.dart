import 'package:flutter/material.dart';

import '../controllers/wallet_controller.dart';
import 'admin_filter_chip.dart';

Widget adminBuildFilterRow(
  BuildContext context, {
  required WalletFilter selectedFilter,
  required ValueChanged<WalletFilter> onFilterSelected,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        adminFilterChip(
          label: 'All',
          selected: selectedFilter == WalletFilter.all,
          onTap: () => onFilterSelected(WalletFilter.all),
        ),
        const SizedBox(width: 8),
        adminFilterChip(
          label: 'Withdrawal',
          selected: selectedFilter == WalletFilter.withdrawal,
          onTap: () => onFilterSelected(WalletFilter.withdrawal),
        ),
        const SizedBox(width: 8),
        adminFilterChip(
          label: 'Refund',
          selected: selectedFilter == WalletFilter.refund,
          onTap: () => onFilterSelected(WalletFilter.refund),
        ),
        const SizedBox(width: 8),
        adminFilterChip(
          label: 'Escrow',
          selected: selectedFilter == WalletFilter.escrow,
          onTap: () => onFilterSelected(WalletFilter.escrow),
        ),
      ],
    ),
  );
}
