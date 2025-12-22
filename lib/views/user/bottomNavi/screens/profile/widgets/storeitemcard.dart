import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../controller/in_app_store_controller.dart';

class StoreItemCard extends StatelessWidget {
  final String title;
  final String image;
  final num price;
  final bool isOwned;
  final bool isSelected;
  final VoidCallback? onSelect;

  const StoreItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    this.isOwned = false,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final InAppStoreController controller = Get.find<InAppStoreController>();

    return CustomContainer(
      conColor: white2Color,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.20),
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
            color: blackColor,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText("SAR", color: pricecolor2, fontSize: 14),
              const SizedBox(width: 4),
              CustomText("$price", color: pricecolor2, fontSize: 14),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 BUY/SELECT Button
          InkWell(
            onTap: onSelect ??
                (isOwned
                    ? null
                    : () {
                        controller.purchaseBadge(context, title, price.toDouble());
                      }),
            child: CustomContainer(
              width: 111,
              padding: const EdgeInsets.symmetric(vertical: 8),
              borderRadius: BorderRadius.circular(8),
              conColor: onSelect != null
                  ? (isSelected ? Colors.green : redColor)
                  : (isOwned == false ? redColor : greyColor),
              alignment: Alignment.center,
              child: CustomText(
                onSelect != null
                    ? (isSelected ? "Selected" : "Select")
                    : (isOwned == false ? "Buy" : "Owned"),
                fontSize: 14,
                fontWeight: FontVariant.bold,
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
