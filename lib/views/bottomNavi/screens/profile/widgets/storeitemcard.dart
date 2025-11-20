import 'package:flutter/material.dart';

import '../../../../../custom_widgets/custom_container.dart';
import '../../../../../custom_widgets/customtext.dart';
import '../../../../../utils/colors.dart';
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
      conColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      borderRadius: BorderRadius.circular(16),
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
          Image.asset(
            image,
            height: 60,
            width: 60,
          ),

          const SizedBox(height: 10),

          CustomText(
            title,
            fontSize: 15,
            fontWeight: FontVariant.semiBold,
            color: Colors.black,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/Mask group.png', height: 16),
              const SizedBox(width: 4),
              CustomText(
                "$price",
                fontSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 10),
          /// 🔥 BUY Button
          CustomContainer(
            width: 111,
            padding: const EdgeInsets.symmetric(vertical: 8),
            borderRadius: BorderRadius.circular(8),
            conColor: redColor,
            alignment: Alignment.center,
            child: CustomText(
              "Buy",
              fontSize: 14,
              fontWeight: FontVariant.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
