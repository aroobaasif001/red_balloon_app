import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/model/task_model.dart';
import '../controller/escrow_detail_controller.dart';

class EscrowTasksTable extends StatelessWidget {
  final EscrowDetailController controller;

  const EscrowTasksTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        conColor: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: walletCardBorderColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with toggle
            GestureDetector(
              onTap: controller.toggleTasks,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Escrow Tasks',
                    color: walletBlackColor,
                    fontSize: 16,
                    fontWeight: FontVariant.bold,
                  ),
                  Icon(
                    controller.isTasksExpanded.value
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
                          flex: 3,
                          child: CustomText(
                            'TASK',
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

                  if (controller.userTasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CustomText(
                          'No active escrow tasks',
                          color: greyColor,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    // Table Rows
                    ...controller.userTasks.asMap().entries.map((entry) {
                      int index = entry.key;
                      TaskModel task = entry.value;
                      bool isLast = index == controller.userTasks.length - 1;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CustomText(
                                    task.title,
                                    color: walletBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontVariant.regular,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    'SAR ${task.budget.toStringAsFixed(2)}',
                                    color: walletBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontVariant.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    task.status.toLowerCase() == 'rejected'
                                        ? 'Validation'
                                        : (task.status.capitalizeFirst ?? task.status),
                                    color: _getStatusColor(task.status),
                                    fontSize: 13,
                                    fontWeight: FontVariant.semiBold,
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
              crossFadeState: controller.isTasksExpanded.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.blue;
      case 'in progress':
        return orangecolor;
      case 'disputed':
        return redColor;
      case 'rejected':
        return redColor;
      default:
        return greyColor;
    }
  }
}
