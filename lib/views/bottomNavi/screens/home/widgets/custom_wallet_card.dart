import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import 'custom_balance_column.dart'; // your earlier widget

class CustomWalletCard extends StatelessWidget {
  final String availableAmount;
  final String escrowAmount;
  final VoidCallback? onAddFunds;

  const CustomWalletCard({
    Key? key,
    required this.availableAmount,
    required this.escrowAmount,
    this.onAddFunds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 30.49, vertical: 21.77),
      conColor: whiteLiteColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: blackColor.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CustomBalanceColumn(title: 'AVAILABLE', amount: availableAmount, amountColor: red1Color),

              const Expanded(child: SizedBox.shrink()),

              CustomBalanceColumn(title: 'IN ESCROW', amount: escrowAmount, amountColor: grey4Color),
            ],
          ),

          const SizedBox(height: 12.89),

          InkWell(
            onTap: onAddFunds,
            child: CustomText('+ Add Funds', fontSize: 13, fontWeight: FontVariant.bold, color: red1Color),
          ),
        ],
      ),
    );
  }
}
