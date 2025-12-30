import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/escrow_detail_controller.dart';

class FundDistributionTable extends StatelessWidget {
  final EscrowDetailController controller;

  const FundDistributionTable({super.key, required this.controller});

  Color _getStatusColor(String statusColor) {
    switch (statusColor) {
      case 'success':
        return walletSuccessColor;
      case 'pending':
        return success;
      default:
        return walletBlackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        conColor: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: walletCardBorderColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with toggle
            GestureDetector(
              onTap: controller.toggleDistribution,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Fund Distribution',
                    color: walletBlackColor,
                    fontSize: 16,
                    fontWeight: FontVariant.bold,
                  ),
                  Icon(
                    controller.isDistributionExpanded.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: greyColor,
                  ),
                ],
              ),
            ),
            
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Column(
                children: [
                  const SizedBox(height: 16),
                  // Table Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            'SPLIT',
                            color: blackColor,
                            fontSize: 14,
                            fontWeight: FontVariant.bold,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            'AMOUNT',
                            color: blackColor,
                            fontSize: 14,
                            fontWeight: FontVariant.bold,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomText(
                            'STATUS',
                            color: walletTransactionDescColor,
                            fontSize: 14,
                            fontWeight: FontVariant.semiBold,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(height: 1, color: fundCardBorderColor),

                  // Table Rows
                  ...controller.fundDistribution.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> item = entry.value;
                    bool isLast = index == controller.fundDistribution.length - 1;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  item['split'],
                                  color: walletBlackColor,
                                  fontSize: 14,
                                  fontWeight: FontVariant.regular,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  'SAR ${item['amount'].toStringAsFixed(2)}',
                                  color: walletBlackColor,
                                  fontSize: 14,
                                  fontWeight: FontVariant.bold,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                  item['status'],
                                  color: blackColor,
                                  fontSize: 13,
                                  fontWeight: FontVariant.regular,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) Container(height: 1, color: walletCardBgColor),
                      ],
                    );
                  }).toList(),
                ],
              ),
              crossFadeState: controller.isDistributionExpanded.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
