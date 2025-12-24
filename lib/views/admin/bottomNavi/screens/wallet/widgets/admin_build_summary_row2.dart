import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../controllers/transaction_history_controller.dart';
import 'package:intl/intl.dart';

Widget adminBuildSummaryRow2(BuildContext context) {
  final controller = Get.find<TransactionHistoryController>();
  return Obx(() => CustomContainer(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    conColor: white2Color,
    borderRadius: BorderRadius.circular(16),
    border: Border(
      bottom: BorderSide(color: bordercol, width: 1),
      right: BorderSide(color: bordercol, width: 1),
      left: BorderSide(color: bordercol, width: 1),
    ),
    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.25),
        blurRadius: 1,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.arrow_upward,
          color: redColor,
          size: 28,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                'Money Sent to Users',
                fontSize: 16,
                fontWeight: FontVariant.medium,
                color: txColor,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              CustomText(
                'SAR ${NumberFormat('#,##0.0').format(controller.moneySendTotal.value)}',
                fontSize: 20,
                fontWeight: FontVariant.bold,
                color: txColor,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}
