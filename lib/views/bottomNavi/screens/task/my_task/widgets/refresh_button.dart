import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import '../../../../../../utils/colors.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              DialogHelpers.showSendOfferBottomSheet(context);
            },
            child: Container(
              height: 51,
              decoration: BoxDecoration(
                color: pricecolor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: CustomText(
                  "Send Offer",
                  color: whiteColor,
                  fontSize: 18,
                  fontWeight: FontVariant.medium,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Container(
            height: 51,
            decoration: BoxDecoration(
              color: pricecolor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: pricecolor,

                width: 1,
              ),
            ),
            child: const Center(
              child: CustomText(
                "Chat",
                color: whiteColor,
                fontSize: 18,
                fontWeight: FontVariant.medium,
              ),
            ),
          ),
        ),
      ],
    );

  }
}
