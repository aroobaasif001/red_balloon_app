import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/add_funds_controller.dart';

class CustomAmountInput extends StatelessWidget {
  final AddFundsController controller;
  final TextEditingController customAmountController;

  const CustomAmountInput({
    super.key,
    required this.controller,
    required this.customAmountController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        conColor: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fundCardBorderColor),
        child: Row(
          children: [
            CustomText(
              'SAR',
              color: walletTransactionDescColor,
              fontSize: 14,
              fontWeight: FontVariant.regular,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                cursorColor: blackColor,
                controller: customAmountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: blackColor),
                decoration: InputDecoration(
                  hintText: 'Enter Custom Amount',
                  hintStyle: TextStyle(
                    color: walletTransactionDateColor,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  controller.setCustomAmount(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
