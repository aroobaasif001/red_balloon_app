import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/widgets/send_offer_bottom_sheet.dart';

import 'colors.dart';

class DialogHelpers {
  // Add Funds Dialog Methods
  static void showAddFundsError(String message) {
    Get.snackbar('Error', message);
  }

  static void showAddFundsSuccess(String amount, String paymentMethod) {
    Get.snackbar(
      'Success',
      'Processing payment of SAR $amount via $paymentMethod',
    );
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
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
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

                      CustomButton(label: 'OK', onPressed: onButtonTap),
                    ],
                    if (showButton == false) SizedBox(height: 41.5),
                  ],
                ),
              ),

              // ================= RED CHECK ICON =================
              Positioned(
                top: -80,
                child: Image.asset(
                  'assets/icons/check.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ===================================================
  /// SHOW HELPER PROFILE DIALOG
  /// ===================================================
  static void showHelperProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 35,
            ),
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 25,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// FLAG + CLOSE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.flag_outlined, color: redColor, size: 22),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: walletTextGreyColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// RED AVATAR
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: redColor,
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              "A",
                              fontSize: 40,
                              fontWeight: FontVariant.bold,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: CustomContainer(
                              height: 18,
                              width: 18,
                              conColor: redColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      /// NAME
                      CustomText(
                        "Anton Furnitures",
                        fontSize: 20,
                        fontWeight: FontVariant.bold,
                      ),
                      const SizedBox(height: 10),

                      /// RB TAG
                      CustomContainer(
                        conColor: Colors.red.shade50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        child: CustomText(
                          "RB-452",
                          fontSize: 12,
                          color: redColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      /// VERIFIED HELPER TAG
                      CustomContainer(
                        conColor: greenBg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: redColor),
                            const SizedBox(width: 6),
                            CustomText(
                              "Verified Helper",
                              fontSize: 13,
                              color: walletSuccessColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      /// STAR + RATING SECTION
                      CustomContainer(
                        conColor: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: redColor, size: 26),
                                const SizedBox(width: 8),
                                CustomText(
                                  "4.9",
                                  fontSize: 22,
                                  fontWeight: FontVariant.bold,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            CustomText(
                              "(25 tasks completed)",
                              fontSize: 13,
                              color: timeColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 2 × 2 STATS GRID
                      Row(
                        children: [
                          Expanded(
                            child: _statBox(
                              "Validation Accuracy",
                              "96%",
                              'assets/icons/streamline-color_target.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statBox(
                              "Response Time",
                              "< 5 min",
                              'assets/icons/material-symbols_avg-time-outline.png',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _statBox(
                              "Distance",
                              "3.2 km",
                              'assets/icons/duo-icons_location.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statBox(
                              "Completion Rate",
                              "98%",
                              'assets/icons/charm_circle-tick.png',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// DESCRIPTION BOX
                      CustomContainer(
                        conColor: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/duo-icons_message-3.png", // 🔥 your image path here
                              height: 24,
                              width: 24,
                              color:
                                  redColor, // ⭐ keeps the same red tint/color
                            ),

                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomText(
                                "Reliable and quick worker from Riyadh. I have 3 years of experience helping with moving, delivery, and errands. Always on time and careful with belongings!",
                                fontSize: 14,
                                color: timeColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ================================
  /// STAT BOX BUILDER
  /// ================================
  static Widget _statBox(String title, String value, String imagePath) {
    return CustomContainer(
      conColor: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Image.asset(imagePath, height: 24, width: 24, fit: BoxFit.contain),
          const SizedBox(height: 8),

          CustomText(title, fontSize: 13, color: timeColor),

          const SizedBox(height: 4),

          CustomText(
            value,
            fontSize: 20,
            fontWeight: FontVariant.bold,
            color: redColor,
          ),
        ],
      ),
    );
  }

  /// ===================================================
  /// SHOW SEND OFFER BOTTOM SHEET
  /// ===================================================
  static void showSendOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const SendOfferBottomSheet();
      },
    );
  }
}

/// =================================================================
/// SMALL STAT BOX WIDGET (Matches Screenshot Perfectly)
/// =================================================================
Widget _statBox(String title, String value, IconData icon) {
  return CustomContainer(
    conColor: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Column(
      children: [
        Icon(icon, color: redColor, size: 26),
        const SizedBox(height: 8),
        CustomText(title, fontSize: 13, color: Colors.grey),
        const SizedBox(height: 4),
        CustomText(
          value,
          fontSize: 18,
          fontWeight: FontVariant.bold,
          color: redColor,
        ),
      ],
    ),
  );
}
