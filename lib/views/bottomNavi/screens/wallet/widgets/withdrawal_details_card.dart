import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/widgets/info_card.dart';

class WithdrawalDetailsCard extends StatelessWidget {
  final String titleText;
  final String amountLabelText;
  final String amountHintText;
  final String minimumLimitText;
  final String paymentMethodLabelText;
  final String paymentMethodHintText;
  final String warningText;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final TextEditingController? amountController;
  final TextEditingController? paymentMethodController;
  final TextEditingController? bankController;
  final TextEditingController? bankAccountController;
  final double cardHorizontalPadding;
  final double cardVerticalPadding;
  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final double cardBorderWidth;
  final double cardBorderRadius;
  final double titleFontSize;
  final FontVariant titleFontVariant;
  final Color titleTextColor;
  final double labelFontSize;
  final FontVariant labelFontVariant;
  final Color labelTextColor;
  final double hintFontSize;
  final Color hintTextColor;
  final Color inputBackgroundColor;
  final Color inputBorderColor;
  final double warningFontSize;
  final FontVariant warningFontVariant;
  final Color warningTextColor;
  final Color warningBackgroundColor;
  final Color warningBorderColor;
  final Color buttonBackgroundColor;
  final Color buttonTextColor;
  final double buttonFontSize;
  final FontVariant buttonFontVariant;

  const WithdrawalDetailsCard({
    super.key,
    this.titleText = 'Withdrawal Details',
    this.amountLabelText = 'Enter amount to withdraw',
    this.amountHintText = 'Enter amount',
    this.minimumLimitText = 'Minimum Withdrawal Limit: SAR 100',
    this.paymentMethodLabelText = 'Select Payment Method',
    this.paymentMethodHintText = 'Select method',
    this.warningText = 'Processing may take up to 48 hours.',
    this.buttonText = 'Request Withdrawal',
    required this.onButtonPressed,
    this.amountController,
    this.paymentMethodController,
    this.cardHorizontalPadding = 16,
    this.cardVerticalPadding = 20,
    this.cardBackgroundColor = white1Color,
    this.cardBorderColor = walletCardBorderColor,
    this.cardBorderWidth = 1,
    this.cardBorderRadius = 12,
    this.titleFontSize = 16,
    this.titleFontVariant = FontVariant.bold,
    this.titleTextColor = walletBalanceTextColor,
    this.labelFontSize = 14,
    this.labelFontVariant = FontVariant.regular,
    this.labelTextColor = walletLabelTextColor,
    this.hintFontSize = 14,
    this.hintTextColor = walletTextGreyColor,
    this.inputBackgroundColor = whiteColor,
    this.inputBorderColor = walletCardBorderColor,
    this.warningFontSize = 12,
    this.warningFontVariant = FontVariant.regular,
    this.warningTextColor = walletErrorColor,
    this.warningBackgroundColor = escrowAmountCardWaitingBackground,
    this.warningBorderColor = walletErrorColor,
    this.buttonBackgroundColor = walletErrorColor,
    this.buttonTextColor = whiteColor,
    this.buttonFontSize = 16,
    this.buttonFontVariant = FontVariant.bold,
    this.bankAccountController,
    this.bankController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(
        horizontal: cardHorizontalPadding,
        vertical: cardVerticalPadding,
      ),
      width: double.infinity,
      conColor: cardBackgroundColor,
      border: Border.all(color: cardBorderColor, width: cardBorderWidth),
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            titleText,
            fontSize: titleFontSize,
            fontWeight: titleFontVariant,
            color: titleTextColor,
          ),
          SizedBox(height: 20),
          CustomText(
            amountLabelText,
            fontSize: labelFontSize,
            fontWeight: labelFontVariant,
            color: labelTextColor,
          ),
          SizedBox(height: 10),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: amountHintText,
              hintStyle: TextStyle(
                color: hintTextColor,
                fontSize: hintFontSize,
              ),
              filled: true,
              fillColor: inputBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 8),
          CustomText(
            minimumLimitText,
            fontSize: 12,
            fontWeight: FontVariant.regular,
            color: hintTextColor,
          ),
          SizedBox(height: 20),
          CustomText(
            paymentMethodLabelText,
            fontSize: labelFontSize,
            fontWeight: labelFontVariant,
            color: labelTextColor,
          ),
          SizedBox(height: 10),
          TextField(
            controller: paymentMethodController,
            cursorColor: blackColor,
            style: TextStyle(color: blackColor),
            decoration: InputDecoration(
              hintText: paymentMethodHintText,
              hintStyle: TextStyle(
                color: hintTextColor,
                fontSize: hintFontSize,
              ),
              filled: true,
              fillColor: inputBackgroundColor,
              suffixIcon: Icon(Icons.keyboard_arrow_down, color: hintTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            readOnly: true,
            onTap: () {},
          ),
          SizedBox(height: 20),
          CustomText(
            'Select Bank',
            fontSize: labelFontSize,
            fontWeight: labelFontVariant,
            color: labelTextColor,
          ),
          SizedBox(height: 10),
          TextField(
            controller: bankController,
            cursorColor: blackColor,
            style: TextStyle(color: blackColor),
            decoration: InputDecoration(
              hintText: 'United Bank Limited',
              hintStyle: TextStyle(
                color: hintTextColor,
                fontSize: hintFontSize,
              ),
              filled: true,
              fillColor: inputBackgroundColor,
              suffixIcon: Icon(Icons.keyboard_arrow_down, color: hintTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            readOnly: true,
            onTap: () {},
          ),
          SizedBox(height: 20),
          CustomText(
            'Add Bank Account Number',
            fontSize: labelFontSize,
            fontWeight: labelFontVariant,
            color: labelTextColor,
          ),
          SizedBox(height: 10),
          TextField(
            controller: bankAccountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '00001111222333',
              hintStyle: TextStyle(
                color: hintTextColor,
                fontSize: hintFontSize,
              ),
              filled: true,
              fillColor: inputBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: inputBorderColor, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          SizedBox(height: 20),
          InfoCard(
            cardHeight: 50,
            iconPath: 'assets/icons/clock.png',
            marginVertical: 0,
            marginHorizontal: 0,
            message: 'Processing may take up to 48 hours.',
            linkText: '',
            onLinkTap: () {},
            backgroundColor: walletPrimaryColor,
            iconColor: whiteColor,
            textColor: whiteColor,
          ),
          SizedBox(height: 20),
          CustomButton(
            borderRadius: BorderRadius.circular(20),
            label: 'Request Withdrawal',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
