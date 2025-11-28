import 'package:flutter/material.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';

class StoreItemCard extends StatelessWidget {
  final String title;
  final String image;
  final int price;

  const StoreItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: white2Color,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.20),
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 🔥 NEW — Circular White Background Around Image
          Expanded(
            child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10), // balanced padding
                child: Image.asset(
                  image,
                  height: 44,
                  width: 44,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          CustomText(
            title,
            fontSize: 15,
            fontWeight: FontVariant.semiBold,
            color:blackColor,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/Mask group.png', height: 16),
              const SizedBox(width: 4),
              CustomText("$price", color: pricecolor2, fontSize: 14),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 BUY Button
          InkWell(
            onTap: () {
              DialogHelpers.showBuyBadgeDialog(context);
            },
            child: CustomContainer(
              width: 111,
              padding: const EdgeInsets.symmetric(vertical: 8),
              borderRadius: BorderRadius.circular(8),
              conColor: redColor,
              alignment: Alignment.center,
              child: const CustomText(
                "Buy",
                fontSize: 14,
                fontWeight: FontVariant.bold,
                color:whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
