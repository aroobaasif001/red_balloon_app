import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

class DialogHelpers {
  // Add Funds Dialog Methods
  static void showAddFundsError(String message) {
    Get.snackbar('Error', message);
  }

  static void showAddFundsSuccess(String amount, String paymentMethod) {
    Get.snackbar('Success', 'Processing payment of SAR $amount via $paymentMethod');
  }

  // Escrow Detail Dialog Methods
  static void showTaskDetailsInfo() {
    Get.snackbar('Task Details', 'Navigating to task details...');
  }

  // Wallet Controller Dialog Methods
  static void showFundReleaseInfo() {
    Get.snackbar('Info', 'Funds are auto-released after successful validation');
  }

  static void showPriceInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: CustomContainer(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 25),
            conColor: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: Offset(0, 4)),
            ],
            child: CustomText(
              "🎈 Minimum Price, SAR 15 • Every task needs at least this starting amount",
              fontWeight: FontVariant.semiBold,
              textAlign: TextAlign.center,
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }

  static void showPaymentSuccessDialog({
    required BuildContext context,

    // OPTIONAL CUSTOM MESSAGE
    String message = "Thank you! Your vote has\nbeen submitted",
    // OPTIONAL BUTTON VISIBILITY
    bool showButton = true,
    void Function()? onButtonTap,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // ================= WHITE CARD =================
              CustomContainer(
                padding: EdgeInsets.only(
                  top: 80,
                  left: 25,
                  right: 25,
                  bottom: showButton ? 25 : 10, // adjust padding
                ),
                conColor: const Color(0xFFF7FFF7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: Offset(0, 4)),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MAIN TEXT
                    CustomText(
                      message,
                      fontSize: 18,
                      fontWeight: FontVariant.semiBold,
                      textAlign: TextAlign.center,
                      color: Colors.black87,
                    ),

                    if (showButton) ...[
                      SizedBox(height: 25),

                      // ================= OK BUTTON =================
                    ],
                    if (showButton == false) SizedBox(height: 41.5),
                  ],
                ),
              ),

              // ================= RED CHECK ICON =================
              Positioned(top: -80, child: Image.asset('assets/icons/check.png', width: 150, height: 150)),
            ],
          ),
        );
      },
    );
  }

}
