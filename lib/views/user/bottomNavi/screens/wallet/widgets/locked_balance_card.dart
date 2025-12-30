import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class LockedBalanceCard extends StatelessWidget {
  final String currency;
  final double balance;
  final String subtitle;
  final int hoursRemaining;
  final int minutesRemaining;
  final double releaseProgress; // 0 to 1

  const LockedBalanceCard({
    super.key,
    required this.currency,
    required this.balance,
    required this.subtitle,
    required this.hoursRemaining,
    required this.minutesRemaining,
    required this.releaseProgress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      conColor: walletCardBgColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: walletCardBorderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'LOCKED IN ESCROW',
                color: walletLabelTextColor,
                fontSize: 12,
                fontWeight: FontVariant.medium,
                letterSpacing: 0.5,
              ),
              Center(
                child: Image.asset(
                  'assets/icons/locked_transactions.png',
                  color: walletPrimaryColor,
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                currency,
                color: walletBalanceTextColor,
                fontSize: 18,
                fontWeight: FontVariant.regular,
              ),
              const SizedBox(width: 8),
              CustomText(
                balance.toStringAsFixed(2),
                color: walletBalanceTextColor,
                fontWeight: FontVariant.bold,
                fontSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
