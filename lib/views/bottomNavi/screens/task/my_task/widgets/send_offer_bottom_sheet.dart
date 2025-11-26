import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../../../../../utils/dialog_helpers.dart';

class SendOfferBottomSheet extends StatefulWidget {
  const SendOfferBottomSheet({super.key});

  @override
  State<SendOfferBottomSheet> createState() => _SendOfferBottomSheetState();
}

class _SendOfferBottomSheetState extends State<SendOfferBottomSheet> {
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: "200");
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: whiteColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ================= TITLE =================
            const CustomText(
              "Send an offer",
              fontSize: 20,
              fontWeight: FontVariant.bold,
              color: textcolord,
            ),

            const SizedBox(height: 24),

            // ================= PRICE DISPLAY =================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const CustomText(
                  "SAR",
                  fontSize: 28,
                  fontWeight: FontVariant.semiBold,
                  color: grayColor,
                ),
                const SizedBox(width: 7),
                CustomContainer(
                  conColor: blackColor,
                  width: 1,
                  height: 30,
                  margin: EdgeInsets.only(top: 10),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: TextField(
                    cursorColor: blackColor,
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            // ================= DIVIDER =================
            Container(
              height: 1,
              color: blackColor,
              margin: const EdgeInsets.symmetric(vertical: 12),
            ),

            const SizedBox(height: 5),

            // ================= INFO TEXT =================
            CustomText(
              "Your offer must be reasonable. Very low or very high offers reduce acceptance chance.",
              fontSize: 12,
              color: blackColor.withOpacity(0.35),
              fontWeight: FontVariant.regular,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            CustomButton(
              label: 'Place Your Offer',
              onPressed: () {
                DialogHelpers.showPaymentSuccessDialog(
                  context: context,
                  message: 'Your Offer has been sent\nsuccessfully',
                  showButton: false,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
