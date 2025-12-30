import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../controller/escrow_detail_controller.dart';
import '../widgets/escrow_amount_card.dart';
import '../widgets/fund_distribution_table.dart';
import '../widgets/escrow_tasks_table.dart';

class EscrowDetail extends StatelessWidget {
  EscrowDetail({super.key});

  final EscrowDetailController controller = Get.put(EscrowDetailController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Escrow Details'),
        body: CustomContainer(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Held Card
                EscrowAmountCard(controller: controller),

                // Fund Distribution Table
                FundDistributionTable(controller: controller),

                // Escrow Tasks Table
                EscrowTasksTable(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
