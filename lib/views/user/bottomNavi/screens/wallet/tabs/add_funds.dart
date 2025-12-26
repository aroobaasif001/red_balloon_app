import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../custom_widgets/wallet_balance_card.dart';
import '../controller/add_funds_controller.dart';
import '../widgets/info_card.dart';
import '../widgets/payment_methods_list.dart';
import '../widgets/predefined_amount_buttons.dart';

class AddFunds extends StatelessWidget {
  AddFunds({super.key});

  final AddFundsController controller = Get.put(AddFundsController());
  final TextEditingController customAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Add Funds'),
        body: CustomContainer(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Balance Card
                Obx(
                  () => WalletBalanceCard(
                    currency: 'SAR',
                    backgroundColor: walletCardBgColor,
                    title: 'Current Balance',
                    titleColor: grey5Color,
                    balanceColor: blackColor,
                    currencyColor: grey5Color,
                    subTitleColor: grey5Color,
                    borderColor: fundCardBorderColor,
                    balance: controller.walletController.availableBalance.value,
                    subtitle: 'Funds will be added to this balance.',
                    onAddFunds: () {},
                    isButtonAvailable: false,
                  ),
                ),

                // Choose Amount Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: CustomText(
                    'Choose Amount',
                    fontSize: 16,
                    fontWeight: FontVariant.bold,
                  ),
                ),

                // Predefined Amount Buttons
                PredefinedAmountButtons(
                  controller: controller,
                  customAmountController: customAmountController,
                ),

                // const SizedBox(height: 16),
                //
                // // Custom Amount Input
                // CustomAmountInput(
                //   controller: controller,
                //   customAmountController: customAmountController,
                // ),

                // Info Card
                InfoCard(
                  message:
                      'A small service fee may apply depending on your payment provider.',
                  linkText: '',
                  onLinkTap: () {},
                ),

                // Add Funds Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Obx(
                    () => CustomButton(
                      borderRadius: BorderRadius.circular(20),
                      label: 'Add Funds',
                      isLoading: controller.isLoading.value,
                      loaderColor: redColor,
                      onPressed: () {
                        controller.addFunds(context);
                      },
                    ),
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
