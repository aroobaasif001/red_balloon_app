import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class SenderBubble extends StatelessWidget {
  final String text;
  final String time;

  const SenderBubble({super.key, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomContainer(
                  conColor: redColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // constraints: const BoxConstraints(
                  //   maxWidth: 292,
                  // ),
                  child: CustomText(text, fontSize: 15, color: whiteColor),
                ),

                const SizedBox(height: 6),

                CustomText(time, fontSize: 11, color: timeColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
