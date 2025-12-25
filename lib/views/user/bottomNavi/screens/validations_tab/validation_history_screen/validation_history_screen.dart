import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../widgets/earningtile.dart';
import 'controller/validation_history_controller.dart';

class ValidationHistoryScreen extends StatelessWidget {
  const ValidationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ValidationHistoryController());

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Column(
          children: [
            /// 🔴 HEADER
            CustomAppBar1(
              title: 'Validation Hub',
              showRightImage: false,
              showLeftImage: true,
            ),

            /// SAB UI AB EK HI PADDING KE ANDAR
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),

                    /// 🔵 TOP TOTAL EARNINGS CARD
                    CustomContainer(
                      height: 180,
                      conColor: whiteColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.20),
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Center(
                        child: CustomContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          conColor: whiteColor,
                          border: Border.all(
                            color: taskstatus3.withOpacity(0.25),
                            width: 1,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: AssetImage('assets/icons/fas2 (1).png'),
                                height: 18,
                                width: 18,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                "Total Earnings:",
                                fontSize: 14,
                                fontWeight: FontVariant.regular,
                                color: totaTextColor,
                              ),
                              const SizedBox(width: 6),
                              Obx(() => CustomText(
                                "+${controller.totalEarning.value.toStringAsFixed(1)} SAR",
                                fontSize: 14,
                                fontWeight: FontVariant.bold,
                                color: historyGreenColor,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// 🔴 TITLE + RED UNDERLINE (CENTER)
                    Center(
                      child: Column(
                        children: [
                          const CustomText(
                            "Total Earnings",
                            fontSize: 20,
                            fontWeight: FontVariant.medium,
                            color: redColor,
                          ),
                          const SizedBox(height: 4),
                          Container(height: 1.5, width: 290, color: redColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    /// 🔵 LIST + SCROLL AREA
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value && controller.earnings.isEmpty) {
                          return const Center(child: CircularProgressIndicator(color: redColor));
                        }

                        if (controller.earnings.isEmpty) {
                          return const Center(
                            child: CustomText(
                              "No validation earnings yet.",
                              color: grey5Color,
                              fontSize: 16,
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: controller.earnings.length,
                          itemBuilder: (context, index) {
                            final item = controller.earnings[index];
                            return EarningTile(
                              title: item['title'],
                              date: item['date'],
                              amount: item['amount'],
                              status: item['status'],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            CustomContainer(
              conColor: walletCardBorderColor,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomText(
                  "Earnings from correct votes are released instantly.\n"
                  "Penalties reduce your withdrawable balance.",
                  fontSize: 13,
                  color: lastTextColor,
                  textAlign: TextAlign.center,
                  fontWeight: FontVariant.regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
