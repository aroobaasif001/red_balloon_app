import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final Color amountColor;
  final String daysAgo;
  final String iconPath;

  const TransactionItem({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.amountColor,
    required this.daysAgo,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      conColor: walletTransactionBgColor,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          CustomContainer(
            width: 40,
            height: 40,
            conColor: amountColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            child: Center(
              child: Icon(
                amount.startsWith('+')
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: amountColor,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title, fontWeight: FontVariant.bold, fontSize: 14),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CustomText(
                      description,
                      color: walletTransactionDescColor,
                      fontWeight: FontVariant.regular,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      '  •  ${daysAgo}',
                      color: walletTransactionDescColor,
                      fontSize: 11,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CustomText(
            amount,
            color: amountColor,
            fontWeight: FontVariant.bold,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
