import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/controller/task_completed_controller.dart';

class PaymentSummaryCard extends StatelessWidget {
  final TaskCompletedController controller;

  const PaymentSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          spreadRadius: 0,
          blurRadius: 4,
          color: blackColor.withOpacity(0.25),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Payment Summary",
              fontSize: 16,
              fontWeight: FontVariant.bold,
              color: textcolord,
            ),
            const SizedBox(height: 16),
            CustomContainer(
              padding: const EdgeInsets.all(16),
              conColor: white2Color,
              borderRadius: BorderRadius.circular(8),
              child: controller.isRequester 
              ? Column(
                  // ---------------- REQUESTER VIEW ----------------
                  children: [
                    _buildPaymentRow(
                      "Task Budget",
                      "SAR ${controller.budgetAmount.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentRow(
                      "Payment Status",
                      "Sent to Helper",
                    ),
                    const SizedBox(height: 16),
                    Divider(color: borderColor),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Total Paid",
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: textcolord,
                        ),
                        CustomText(
                          "SAR ${controller.budgetAmount.toStringAsFixed(2)}",
                          fontSize: 18,
                          fontWeight: FontVariant.bold,
                          color: redColor,
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  // ---------------- HELPER VIEW ----------------
                  children: [
                    _buildPaymentRow(
                      "Platform Fee (7.5%)",
                      "SAR ${controller.platformFee.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentRow(
                      "Escrow Fee (7.5%)",
                      "- SAR ${controller.escrowFee.abs().toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 16),
                    Divider(color: borderColor),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Final Amount Earned",
                          fontSize: 14,
                          fontWeight: FontVariant.semiBold,
                          color: textcolord,
                        ),
                        CustomText(
                          "SAR ${controller.finalAmountEarned.toStringAsFixed(2)}",
                          fontSize: 18,
                          fontWeight: FontVariant.bold,
                          color: greenColor,
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(label, fontSize: 14, color: grey2Color),
        CustomText(
          amount,
          fontSize: 14,
          fontWeight: FontVariant.semiBold,
          color: textcolord,
        ),
      ],
    );
  }
}
