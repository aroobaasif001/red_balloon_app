import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/admin_bottom_navi_screen.dart';

import '../validation_history_screen/validation_history_screen.dart';
import '../validation_screen/validation_screen.dart';
import '../widgets/validationemptywidget.dart';
import 'controller/validation_hub_controller.dart';

class ValidationHubScreen extends StatelessWidget {
  const ValidationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ValidationHubController());

    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: whiteColor,
        color: redColor,
        onRefresh: () async {
          await controller.fetchValidations();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar1(
                title: 'Validation Hub',
                showLeftImage: false,
                onRightPressed: () {
                  Get.to(() => ValidationHistoryScreen());
                },
              ),

              const SizedBox(height: 25),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(color: redColor),
                    ),
                  );
                }

                if (controller.validations.isEmpty) {
                  return const ValidationEmptyWidget();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.validations.length,
                  itemBuilder: (_, index) {
                    final validation = controller.validations[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CustomContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(20),
                        conColor: white2Color,
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.20),
                            blurRadius: 3,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// BEFORE & AFTER IMAGES
                            Row(
                              children: [
                                Expanded(
                                  child: CustomContainer(
                                    height: 120,
                                    conColor: redColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    image:
                                        validation['beforePhotoUrl']
                                                ?.isNotEmpty ==
                                            true
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              validation['beforePhotoUrl'],
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    child: const CustomText(
                                      "BEFORE",
                                      fontWeight: FontVariant.semiBold,
                                      fontSize: 12,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: CustomContainer(
                                    height: 120,
                                    conColor: redColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    image:
                                        validation['afterPhotoUrl']
                                                ?.isNotEmpty ==
                                            true
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              validation['afterPhotoUrl'],
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    child: const CustomText(
                                      "AFTER",
                                      fontWeight: FontVariant.semiBold,
                                      fontSize: 12,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// TITLE + BADGE
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        validation['userId'] ?? 'RB-00000',
                                        fontSize: 18,
                                        fontWeight: FontVariant.bold,
                                        fontType: AppFont.montserrat,
                                        color: blackColor,
                                      ),
                                      CustomText(
                                        validation['taskTitle'] ?? 'No Title',
                                        fontSize: 16,
                                        fontWeight: FontVariant.semiBold,
                                        fontType: AppFont.montserrat,
                                        color: blackColor,
                                        maxLines: null,                 // unlimited lines allow
                                        overflow: TextOverflow.visible, // next line wrap
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            /// TIMER + BUTTON
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: walletCardBgColor,
                                    borderRadius: BorderRadius.circular(
                                      7,
                                    ), // FULL ROUND
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Image(
                                        image: AssetImage(
                                          "assets/icons/timer99.png",
                                        ),
                                        height: 20,
                                      ),
                                      SizedBox(width: 8),
                                      CustomText(
                                        "15 min left to validate",
                                        fontSize: 12,
                                        fontWeight: FontVariant.medium,
                                        color: blackColor,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: CustomButton(
                                    label: "Review Proof",
                                    onPressed: () {
                                      Get.to(() => ValidationScreen(
                                        taskId: validation['taskId'],
                                        userId: validation['userId'],
                                        beforePhotoUrl: validation['beforePhotoUrl'],
                                        afterPhotoUrl: validation['afterPhotoUrl'],
                                        proofId: validation['proofId'],
                                      ));
                                    },
                                    height: 40,
                                    width: 80,
                                    fontSize: 14,
                                    fontWeight: FontVariant.bold,
                                    borderRadius: BorderRadius.circular(14),
                                    bgColor: redColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomContainer(
        height: 300,
        // width: 100,
        borderRadius: BorderRadius.circular(50),
        padding: EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed: () {
                Get.to(() => AdminBottomNaviScreen());
              },
              heroTag: 'add_task_fab',
              backgroundColor: redColor,
              child: Icon(Icons.ads_click, color: whiteColor),
            ),
          ],
        ),
      ),

    );
  }
}
