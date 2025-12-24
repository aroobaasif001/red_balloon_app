import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/colors.dart';
import '../controllers/wallet_controller.dart';
import '../tabs/transaction_history.dart';
import 'admin_summary_card.dart';

Widget adminBuildSummaryRow(BuildContext context) {
  final WalletController controller = Get.find<WalletController>(tag: 'admin_wallet');

  return Obx(() => Row(
    children: [
      Expanded(
        child: adminSummaryCard(
          context,
          icon: Icons.lock,
          iconBg: iconBg,
          title: 'Locked Escrow',
          amount: controller.lockedEscrow.value,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: adminSummaryCard(
          onTap: () {
            Get.to(() => AdminTransactionHistory());
          },
          context,
          icon: 'assets/icons/task_2.png',
          iconBg: iconBg,
          title: 'Released Weekly',
          amount: controller.releasedWeekly.value,
          isIcon: false,
        ),
      ),
    ],
  ));
}
