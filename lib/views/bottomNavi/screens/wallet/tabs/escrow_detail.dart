import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/controller/escrow_detail_controller.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/widgets/escrow_amount_card.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/widgets/fund_distribution_table.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/widgets/info_card.dart';

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

                const SizedBox(height: 24),

                // Fund Distribution Table
                FundDistributionTable(controller: controller),

                const SizedBox(height: 16),

                // Info Alert
                InfoCard(
                  iconColor: whiteColor,
                  textColor: whiteColor,
                  borderColor: walletPrimaryColor,
                  backgroundColor: walletPrimaryColor,
                  message:
                      'Funds will be automatically distributed once validation reaches 6/9 consensus.',
                  linkText: '',
                  onLinkTap: () {},
                ),

                // View Task Details Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomButton(
                    label: 'View Task Details',
                    onPressed: () {
                      controller.viewTaskDetails();
                    },
                    bgColor: whiteColor,
                    textColor: walletErrorColor,
                    border: Border.all(color: walletPrimaryColor, width: 1),
                    // borderColor: walletErrorColor,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
