import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/add_funds_controller.dart';

class PredefinedAmountButtons extends StatelessWidget {
  final AddFundsController controller;
  final TextEditingController customAmountController;

  const PredefinedAmountButtons({
    super.key,
    required this.controller,
    required this.customAmountController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 3.5,
          children: controller.predefinedAmounts.map((amount) {
            final isSelected =
                controller.selectedAmount.value == amount &&
                controller.customAmount.value.isEmpty;
            return GestureDetector(
              onTap: () {
                controller.selectAmount(amount);
                customAmountController.clear();
              },
              child: CustomContainer(
                conColor: isSelected ? walletPrimaryColor : whiteColor,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: isSelected ? walletPrimaryColor : fundCardBorderColor,
                  width: 2.0,
                ),
                child: Center(
                  child: CustomText(
                    'SAR $amount',
                    color: isSelected ? whiteColor : walletBalanceTextColor,
                    fontSize: 14,
                    fontWeight: FontVariant.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
