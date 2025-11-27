import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomWalletCard extends StatelessWidget {
  final String availableAmount;
  final VoidCallback? onAddFunds;

  const CustomWalletCard({
    Key? key,
    required this.availableAmount,
    this.onAddFunds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      conColor: whiteLiteColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.25),
          offset: const Offset(0, 4),
          blurRadius: 4,
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/wallet_2.png',
                    color: redColor,
                    height: 31,
                    width: 31,
                  ),
                  SizedBox(width: 4),
                  CustomText(
                    'Wallet Balance',
                    fontSize: Get.height * 0.022,
                    fontWeight: FontVariant.bold,
                    color: blackColor,
                  ),
                ],
              ),
              SizedBox(height: 16),
              CustomText(
                'SAR ${availableAmount}',
                fontSize: 24,
                fontWeight: FontVariant.bold,
                color: redColor,
              ),
              SizedBox(height: 16),
              CustomButton(
                width: 150,
                label: 'Add Funds',
                onPressed: onAddFunds,
              ),
              SizedBox(height: 16),
              CustomText(
                'Required to post new tasks',
                fontSize: 16,
                fontWeight: FontVariant.semiBold,
              ),
            ],
          ),
          Image.asset('assets/icons/red_ballon.png', width: 88),
        ],
      ),
    );
  }
}
