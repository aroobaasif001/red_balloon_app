import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

class CustomBalanceColumn extends StatelessWidget {
  final String title;
  final String amount;
  final Color amountColor;

  const CustomBalanceColumn({Key? key, required this.title, required this.amount, required this.amountColor})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(title, fontSize: 12, fontWeight: FontVariant.regular),
        const SizedBox(height: 13.68),
        CustomText(amount, fontSize: 24, fontWeight: FontVariant.bold, color: amountColor),
      ],
    );
  }
}
