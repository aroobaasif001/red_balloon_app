import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ReceiverImageBubble extends StatelessWidget {
  final String imgPath;

  const ReceiverImageBubble({super.key, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "A",
          fontSize: 14,
          fontWeight: FontVariant.bold,
          color: redColor,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: CustomContainer(
            conColor: whiteColor,
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            child: Image.asset(
              imgPath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
