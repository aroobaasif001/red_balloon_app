import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../validations_tab/widgets/validationemptywidget.dart';
import '../validation_history_screen/validation_history_screen.dart';
import '../validation_hub_screen/controller/validation_hub_controller.dart';
import '../validation_screen/validation_screen.dart';

class ValidationHubScreen extends StatefulWidget {
  const ValidationHubScreen({super.key});

  @override
  State<ValidationHubScreen> createState() => _ValidationHubScreenState();
}

class _ValidationHubScreenState extends State<ValidationHubScreen> {
  // 🔥 Initial loading state for 2 seconds
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    // Show lottie for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔥 Mark validations as seen when screen becomes visible
    // Schedule for after build to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = Get.find<ValidationHubController>();
        controller.onScreenVisible();
      }
    });
  }

  @override
  void dispose() {
    // 🔥 Mark screen as hidden when leaving
    final controller = Get.find<ValidationHubController>();
    controller.onScreenHidden();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ValidationHubController());

    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: whiteColor,
        color: redColor,
        onRefresh: () async {
          await controller.fetchValidations(
            minDelay: const Duration(seconds: 1),
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                if (controller.isLoading.value && !_isInitialLoading) {
                  return Container(
                    height: 600,
                    child: Center(
                      child: Lottie.asset(
                        'assets/animation/loader.json',
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  );
                }

                if (controller.validations.isEmpty && !_isInitialLoading) {
                  return const ValidationEmptyWidget();
                }

                if (_isInitialLoading) {
                  return Container(
                    height: 600,
                    child: Center(
                      child: Lottie.asset(
                        'assets/animation/loader.json',
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.validations.length,
                  itemBuilder: (_, index) {
                    final validation = controller.validations[index];
                    String time = DateFormat(
                      'dd MMM \'at\' hh:mm a',
                    ).format(validation['rejectedAt'].toDate());

                    return FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      delay: Duration(milliseconds: index * 700),
                      child: Padding(
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
                              /// TITLE + BADGE
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          validation['taskTitle'] ?? 'No Title',
                                          fontSize: 18,
                                          fontWeight: FontVariant.bold,
                                          fontType: AppFont.montserrat,
                                          color: blackColor,
                                          maxLines: null,
                                          overflow: TextOverflow.visible,
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
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(
                                          () => CustomText(
                                            controller
                                                    .remainingTimes[validation['validationId']] ??
                                                "15 min left to validate",
                                            fontSize: 14,
                                            fontWeight: FontVariant.regular,
                                            color: txColor,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        CustomText(
                                          time.toString(),
                                          fontSize: 14,
                                          fontWeight: FontVariant.regular,
                                          color: txColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 30),

                                  Expanded(
                                    child: CustomButton(
                                      label: "Review Proof",
                                      onPressed: () {
                                        Get.to(
                                          () => ValidationScreen(
                                            validationId:
                                                validation['validationId'],
                                            taskId: validation['taskId'],
                                            userId: validation['userId'],
                                            beforePhotoUrl:
                                                validation['beforePhotoUrl'],
                                            afterPhotoUrl:
                                                validation['afterPhotoUrl'],
                                            proofId: validation['proofId'],
                                          ),
                                        );
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
                      ),
                    );
                  },
                );
              }),
              // END COMMENTED CONTROLLER
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
      // floatingActionButton: CustomContainer(
      //   height: 300,
      //   // width: 100,
      //   borderRadius: BorderRadius.circular(50),
      //   padding: EdgeInsets.only(bottom: 80),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       FloatingActionButton(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(40),
      //         ),
      //         onPressed: () {
      //           Get.to(() => AdminBottomNaviScreen());
      //         },
      //         heroTag: 'add_task_fab',
      //         backgroundColor: redColor,
      //         child: Icon(Icons.ads_click, color: whiteColor),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
