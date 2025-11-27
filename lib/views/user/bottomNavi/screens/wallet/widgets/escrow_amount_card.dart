import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/escrow_detail_controller.dart';

class EscrowAmountCard extends StatelessWidget {
  final EscrowDetailController controller;

  const EscrowAmountCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomContainer(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        conColor: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: walletCardBorderColor),
        child: Column(
          children: [
            // Lock Icon
            Center(
              child: Image.asset(
                'assets/icons/locked_transactions.png',
                color: walletPrimaryColor,
                height: 48,
                width: 48,
              ),
            ),
            const SizedBox(height: 26),

            // Amount Held Label
            CustomText(
              'AMOUNT HELD',
              color: walletTransactionDescColor,
              fontSize: 14,
              fontWeight: FontVariant.regular,
            ),
            const SizedBox(height: 18),

            // Amount
            CustomText(
              '${controller.currency.value} ${controller.amountHeld.value.toStringAsFixed(2)}',
              color: walletBlackColor,
              fontSize: 32,
              fontWeight: FontVariant.bold,
            ),
            const SizedBox(height: 18),

            // Task Name
            CustomText(
              'for task \'${controller.taskName.value}\'',
              color: walletTransactionDescColor,
              fontSize: 13,
              fontWeight: FontVariant.regular,
            ),
            const SizedBox(height: 16),

            // Validation Status
            CustomContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              conColor: escrowAmountCardWaitingBackground,
              borderRadius: BorderRadius.circular(28),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset('assets/icons/waiting.png', height: 16),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    controller.validationStatus.value,
                    color: walletErrorColor,
                    fontSize: 12,
                    fontWeight: FontVariant.semiBold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
