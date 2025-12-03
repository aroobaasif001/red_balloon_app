import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: InkWell(
        onTap: onAddFunds,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Wallet Balance',
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                  color: blackColor,
                ),
                CustomText(
                  availableAmount,
                  fontSize: 15,
                  fontWeight: FontVariant.medium,
                  color: blackColor,
                ),
              ],
            ),
            Image.asset('assets/icons/wallet_4.png', height: 34, width: 34),
          ],
        ),
      ),
    );
  }
}
