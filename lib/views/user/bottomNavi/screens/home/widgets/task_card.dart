import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String price;
  final String btnText;
  final VoidCallback? onPressed;

  const TaskCard({
    super.key,
    required this.title,
    required this.price,
    required this.btnText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: greyLiteColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(title, fontSize: 13, fontWeight: FontVariant.semiBold),
              CustomText(price, fontSize: 12, color: redColor, fontWeight: FontVariant.bold),
            ],
          ),
          CustomButton(
            label: btnText,
            onPressed: onPressed ?? () {},
            width: 90,
            height: 32,
            bgColor: redColor,
          ),
        ],
      ),
    );
  }
}
