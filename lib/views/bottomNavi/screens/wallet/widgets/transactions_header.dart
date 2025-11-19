import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class TransactionsHeader extends StatelessWidget {
  final VoidCallback onViewAll;

  const TransactionsHeader({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            'Recent Transactions',
            fontWeight: FontVariant.bold,
            fontSize: 16,
          ),
          GestureDetector(
            onTap: onViewAll,
            child: CustomText(
              'View All',
              color: walletPrimaryColor,
              fontWeight: FontVariant.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
