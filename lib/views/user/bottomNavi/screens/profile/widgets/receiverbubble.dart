import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ReceiverBubble extends StatelessWidget {
  final String text;
  final String time;

  const ReceiverBubble({
    super.key,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: CustomText(
            "A",
            fontSize: 14,
            fontWeight: FontVariant.bold,
            color: redColor,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                width: 262,
                conColor:greyLiteColor,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                borderRadius: BorderRadius.circular(22),
                child: CustomText(
                  text,
                  fontSize: 15,
                  color: grey50Color,
                ),
              ),

              const SizedBox(height: 6),

              CustomText(
                time,
                fontSize: 11,
                color: timeColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
