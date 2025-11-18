import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class WalletBalanceCard extends StatelessWidget {
  final String currency;
  final double balance;
  final String subtitle;
  final VoidCallback onAddFunds;
  final Color backgroundColor;
  final String title;
  final Color titleColor;
  final Color currencyColor;
  final Color balanceColor;
  final Color subTitleColor;
  final Color buttonTextColor;
  final Color buttonBackgroundColor;
  final Color buttonForegroundColor;
  final bool isButtonAvailable;
  final Color borderColor;

  const WalletBalanceCard({
    super.key,
    required this.currency,
    required this.balance,
    required this.subtitle,
    required this.onAddFunds,
    this.backgroundColor = walletPrimaryColor,
    this.title = 'AVAILABLE BALANCE',
    this.titleColor = whiteColor,
    this.currencyColor = whiteColor,
    this.balanceColor = whiteColor,
    this.subTitleColor = whiteColor,
    this.buttonTextColor = walletPrimaryColor,
    this.buttonBackgroundColor = whiteColor,
    this.buttonForegroundColor = walletPrimaryColor,
    this.isButtonAvailable = true,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      conColor: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor, width: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            color: titleColor,
            fontSize: 12,
            fontWeight: FontVariant.regular,
            letterSpacing: 0.5,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                currency,
                color: currencyColor,
                fontWeight: FontVariant.regular,
                fontSize: 18,
              ),
              const SizedBox(width: 8),
              CustomText(
                balance.toStringAsFixed(2),
                color: balanceColor,
                fontWeight: FontVariant.bold,
                fontSize: 32,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(subtitle, color: subTitleColor, fontSize: 13),
          isButtonAvailable == true ? SizedBox(height: 16) : CustomContainer(),
          isButtonAvailable == true
              ? SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Add Funds',
                    onPressed: onAddFunds,
                    bgColor: whiteColor,
                    textColor: walletPrimaryColor,
                  ),
                )
              : CustomContainer(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  height: 30,
                  borderRadius: BorderRadius.circular(25),
                  conColor: walletPrimaryColor.withOpacity(0.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        'Minimum top-up: SAR 15',
                        fontWeight: FontVariant.bold,
                        fontSize: 12,
                        color: walletPrimaryColor,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
