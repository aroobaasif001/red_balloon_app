import 'package:flutter/material.dart';

import '../../../../../custom_widgets/custom_container.dart';
import '../../../../../custom_widgets/customtext.dart';
import '../../../../../utils/colors.dart';
import 'info_card.dart';

class custom_withdraw_balance_card extends StatelessWidget {
  final String availableToWithdrawLabel;
  final String availableAmount;
  final double availableFontSize;
  final FontVariant availableFontVariant;
  final Color availableAmountColor;
  final String lockedBalanceLabel;
  final String lockedAmount;
  final double lockedFontSize;
  final FontVariant lockedFontVariant;
  final Color lockedAmountColor;
  final String releasingTimeLabel;
  final double releasingFontSize;
  final FontVariant releasingFontVariant;
  final Color releasingTimeColor;
  final double cardHorizontalPadding;
  final double cardVerticalPadding;
  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final double cardBorderWidth;
  final double cardBorderRadius;
  final String maxWithdrawalLimitMessage;
  final Color maxWithdrawalBgColor;
  final Color maxWithdrawalBorderColor;
  final Color maxWithdrawalIconColor;
  final Color maxWithdrawalTextColor;

  const custom_withdraw_balance_card({
    super.key,
    this.availableToWithdrawLabel = 'Available to Withdraw',
    this.availableAmount = 'SAR 255.00',
    this.availableFontSize = 24,
    this.availableFontVariant = FontVariant.bold,
    this.availableAmountColor = greenColor,
    this.lockedBalanceLabel = 'Locked Balance',
    this.lockedAmount = 'SAR 100.00',
    this.lockedFontSize = 20,
    this.lockedFontVariant = FontVariant.bold,
    this.lockedAmountColor = walletTransactionDescColor,
    this.releasingTimeLabel = '⏱ Releasing in 47h 12m',
    this.releasingFontSize = 12,
    this.releasingFontVariant = FontVariant.regular,
    this.releasingTimeColor = redColor,
    this.cardHorizontalPadding = 20,
    this.cardVerticalPadding = 25,
    this.cardBackgroundColor = white1Color,
    this.cardBorderColor = walletCardBorderColor,
    this.cardBorderWidth = 1,
    this.cardBorderRadius = 15,
    this.maxWithdrawalLimitMessage = 'Maximum Withdrawal Limit: SAR 2000',
    this.maxWithdrawalBgColor = whiteColor,
    this.maxWithdrawalBorderColor = whiteColor,
    this.maxWithdrawalIconColor = grey5Color,
    this.maxWithdrawalTextColor = grey5Color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      // height: 260,
      padding: EdgeInsets.symmetric(
        horizontal: cardHorizontalPadding,
        vertical: cardVerticalPadding,
      ),
      width: double.infinity,
      conColor: cardBackgroundColor,
      border: Border.all(color: cardBorderColor, width: cardBorderWidth),
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Column(
        children: [
          Row(
            children: [
              CustomText(
                availableToWithdrawLabel,
                fontSize: 14,
                fontWeight: FontVariant.regular,
                color: grey5Color,
              ),
              SizedBox(width: 15),
              Icon(Icons.check, color: greenColor, size: 16),
            ],
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomText(
              availableAmount,
              fontSize: availableFontSize,
              fontWeight: availableFontVariant,
              color: availableAmountColor,
            ),
          ),
          SizedBox(height: 15),
          Divider(color: fundCardBorderColor),
          SizedBox(height: 15),

          Row(
            children: [
              CustomText(
                lockedBalanceLabel,
                fontSize: 14,
                fontWeight: FontVariant.regular,
                color: walletTransactionDescColor,
              ),
              SizedBox(width: 15),
              Image.asset(
                'assets/icons/locked_transactions.png',
                color: walletTransactionDescColor,
                height: 16,
                width: 16,
              ),
            ],
          ),
          SizedBox(height: 15),

          Align(
            alignment: Alignment.bottomLeft,
            child: CustomText(
              lockedAmount,
              fontSize: lockedFontSize,
              fontWeight: lockedFontVariant,
              color: lockedAmountColor,
            ),
          ),
          SizedBox(height: 15),

          Align(
            alignment: Alignment.bottomLeft,
            child: CustomText(
              releasingTimeLabel,
              fontSize: releasingFontSize,
              fontWeight: releasingFontVariant,
              color: releasingTimeColor,
            ),
          ),
          SizedBox(height: 15),
          InfoCard(
            // cardHeight: 50,
            marginHorizontal: 0,
            marginVertical: 0,
            message: maxWithdrawalLimitMessage,
            linkText: '',
            onLinkTap: () {},
            backgroundColor: maxWithdrawalBgColor,
            borderColor: maxWithdrawalBorderColor,
            iconColor: maxWithdrawalIconColor,
            textColor: maxWithdrawalTextColor,
          ),
        ],
      ),
    );
  }
}
