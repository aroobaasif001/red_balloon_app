import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import '../../../bottom_navi_screen.dart';
import 'controller/post_new_task_controller.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: CustomText(
          'Post New Task',
          fontSize: 24,
          fontWeight: FontVariant.bold,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Center(
              child: Image(
                image: AssetImage('assets/icons/lock_img.png'),
                height: 170,
              ),
            ),
            SizedBox(height: 29),
            CustomContainer(
              conColor: whiteColor,
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 35),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.25),
                  offset: const Offset(2, 4),
                  blurRadius: 4,
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        'Task Cost',
                        fontSize: 18,
                        fontWeight: FontVariant.medium,
                      ),
                      GetBuilder<PostNewTaskController>(
                        builder: (controller) {
                          final budget = controller.taskBudget.text.trim();
                          return CustomText(
                            'SAR ${budget.isEmpty ? "0" : budget}',
                            fontSize: 26,
                            fontWeight: FontVariant.bold,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Divider(),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        'Available Balance',
                        fontSize: 18,
                        fontWeight: FontVariant.medium,
                      ),
                      CustomText(
                        'SAR 100',
                        fontSize: 26,
                        fontWeight: FontVariant.bold,
                        color: redColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 39),
                  CustomContainer(
                    padding: EdgeInsets.all(20),
                    conColor: red2Color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.25),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 25,
                          color: whiteColor,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: CustomText(
                            'Funds will remain locked in escrow until task validation is complete.',
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 41),
            CustomContainer(
              padding: EdgeInsets.all(20),
              conColor: red2Color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(0.25),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage('assets/icons/gurd.png'),
                        height: 47,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Secure Escrow Protection',
                              fontSize: 22,
                              fontWeight: FontVariant.semiBold,
                              color: whiteColor,
                            ),
                            SizedBox(height: 7),
                            CustomText(
                              'Your funds are protected by our secure escrow system. Payment will only be released after validation.',
                              fontWeight: FontVariant.medium,
                              color: whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 55),
            GetBuilder<PostNewTaskController>(
              builder: (controller) {
                return Obx(
                  () => CustomButton(
                    width: MediaQuery.of(context).size.width * 0.7,
                    leading: controller.isLoading.value
                        ? SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                            ),
                          )
                        : Image(
                            image: AssetImage('assets/icons/lock.png'),
                            height: 26,
                          ),
                    label: controller.isLoading.value ? 'Processing...' : 'Confirm & Lock Funds',
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final success = await controller.submitTask();

                            if (success) {
                              DialogHelpers.showPaymentSuccessDialog(
                                context: context,
                                message:
                                    'Your Payment has been\nlocked in escrow successfully',
                                showButton: true,
                                onButtonTap: () {
                                  Get.offAll(() => BottomNaviScreen());
                                  DialogHelpers.showPaymentSuccessDialog(
                                    showButton: false,
                                    context: context,
                                    message: 'Your Task was posted\nsuccessfully!',
                                  );
                                },
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to submit task. Please try again.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                  ),
                );
              },
            ),

            SizedBox(height: 9),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: redColor, width: 1.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.7,
                  0,
                ), // FULL WIDTH
              ),
              onPressed: () => Get.back(),
              child: CustomText(
                'Go Back',
                fontSize: 20,
                fontWeight: FontVariant.semiBold,
                color: redColor,
              ),
            ),
            SizedBox(height: 38),
          ],
        ),
      ),
    );
  }
}
