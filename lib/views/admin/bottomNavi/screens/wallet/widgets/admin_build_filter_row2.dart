import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../controllers/transaction_history_controller.dart';

Widget adminBuildFilterRow2(
  BuildContext context, {
  required TransactionHistoryFilter selectedFilter,
  required void Function(TransactionHistoryFilter) onFilterSelected,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _buildFilterChip(
          label: 'All',
          isSelected: selectedFilter == TransactionHistoryFilter.all,
          onTap: () => onFilterSelected(TransactionHistoryFilter.all),
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'Escrow',
          isSelected: selectedFilter == TransactionHistoryFilter.escrow,
          onTap: () => onFilterSelected(TransactionHistoryFilter.escrow),
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'Withdrawals',
          isSelected: selectedFilter == TransactionHistoryFilter.withdrawals,
          onTap: () => onFilterSelected(TransactionHistoryFilter.withdrawals),
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'Refunds',
          isSelected: selectedFilter == TransactionHistoryFilter.refunds,
          onTap: () => onFilterSelected(TransactionHistoryFilter.refunds),
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          label: 'Releases',
          isSelected: selectedFilter == TransactionHistoryFilter.releases,
          onTap: () => onFilterSelected(TransactionHistoryFilter.releases),
        ),
      ],
    ),
  );
}

Widget _buildFilterChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(9999),
      conColor: isSelected ? redColor : whiteColor,
      border: Border.all(
        color: isSelected ? Colors.transparent : beforecolor,
        width: 1,
      ),
      child: CustomText(
        label,
        fontSize: 14,
        fontWeight: FontVariant.semiBold,
        color: isSelected ? whiteColor : walletGrey600Color,
      ),
    ),
  );
}
