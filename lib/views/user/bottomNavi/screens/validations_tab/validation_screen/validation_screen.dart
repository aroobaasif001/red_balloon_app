import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/controller/validation_screen_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/tabs/AfterTab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/tabs/BeforeTab.dart';

class ValidationScreen extends StatefulWidget {
  final bool isTask;
  final String? taskId;
  final String? userId;
  final String? beforePhotoUrl;
  final String? afterPhotoUrl;
  final String? proofId; // 🔥 Added proofId parameter

  const ValidationScreen({
    super.key,
    this.isTask = false,
    this.taskId,
    this.userId,
    this.beforePhotoUrl,
    this.afterPhotoUrl,
    this.proofId, // 🔥 Added to constructor
  });

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  int selectedTab = 0; // 0 = BEFORE, 1 = AFTER
  late final ValidationScreenController controller;

  @override
  void initState() {
    super.initState();

    // Initialize controller
    controller = Get.put(ValidationScreenController());

    // Fetch task details if data is provided
    if (widget.taskId != null) {
      controller.fetchTaskDetails(
        validationTaskId: widget.taskId!,
        validationUserId: widget.userId ?? 'RB-00000',
        validationBeforePhoto: widget.beforePhotoUrl ?? '',
        validationAfterPhoto: widget.afterPhotoUrl ?? '',
        proofId: widget.proofId, // 🔥 Pass proofId to controller
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: redColor));
        }

        return SingleChildScrollView(
          // ✅ SCROLLABLE ADDED
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              CustomAppBar1(
                title: 'Validation',
                rightImagePath: 'assets/icons/button.png',
                rightImageHeight: 50,
                rightImageWidth: 20,
                showRightImage: false,
              ),

              const SizedBox(height: 20),

              /// 🔴 TOP SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// PROFILE + TITLE + TIMER (RIGHT SIDE)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/images/prof.png"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                controller.taskTitle.value,
                                fontSize: 18,
                                fontWeight: FontVariant.bold,
                                color: blackColor,
                                maxLines: null, // unlimited lines allow
                                overflow:
                                    TextOverflow.visible, // next line wrap
                              ),
                              const SizedBox(height: 2),
                              CustomText(
                                controller.userId.value,
                                fontSize: 14,
                                fontWeight: FontVariant.medium,
                                color: rbtxColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        /// RIGHT — TIMER (EXACT LIKE YOUR IMAGE)
                        CustomContainer(
                          width: 55,
                          height: 55,
                          borderRadius: BorderRadius.circular(60),
                          padding: EdgeInsets.all(3),
                          conColor: whiteColor,
                          border: Border.all(color: redColor, width: 3),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: CustomText(
                              controller.remainingTime.value,
                              fontSize: 16,
                              fontWeight: FontVariant.bold,
                              color: redColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    CustomText(
                      "DESCRIPTION",
                      fontSize: 14,
                      fontWeight: FontVariant.bold,
                      color: greyColor,
                    ),

                    const SizedBox(height: 10),

                    CustomText(
                      controller.taskDescription.value,
                      fontSize: 15,
                      fontWeight: FontVariant.regular,
                      color: blackColor,
                    ),

                    const SizedBox(height: 18),

                    /// SUBMITTED TIME ROW
                    if (controller.completedAt.value != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/timer99.png", height: 18),
                          const SizedBox(width: 8),
                          CustomText(
                            "Submitted ${controller.getSubmittedTimeAgo()}",
                            fontSize: 14,
                            fontWeight: FontVariant.regular,
                            color: walletGrey600Color,
                          ),
                        ],
                      ),

                    const SizedBox(height: 25),

                    /// ⭐ VALIDATION STATISTICS
                    CustomContainer(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/statistics.png",
                                height: 21,
                              ),
                              const SizedBox(width: 8),
                              const CustomText(
                                "Validation Statistics",
                                fontSize: 18,
                                fontWeight: FontVariant.semiBold,
                                color: lastTextColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: redColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    "${controller.votesReceived.value.toString().padLeft(2, '0')} Votes Received",
                                    fontSize: 14,
                                    fontWeight: FontVariant.bold,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: redColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CustomText(
                                    "${controller.votesNeeded.value.toString().padLeft(2, '0')} Votes Needed",
                                    fontSize: 14,
                                    fontWeight: FontVariant.bold,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),

              /// 🔵 MAIN TABS
              Center(
                child: CustomContainer(
                  height: 44,
                  width: 173,
                  borderRadius: BorderRadius.circular(14),
                  conColor: appbard,
                  padding: const EdgeInsets.all(4),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.15),
                      blurRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTab = 0),
                          child: CustomContainer(
                            height: 36,
                            borderRadius: BorderRadius.circular(10),
                            conColor: selectedTab == 0
                                ? redColor
                                : Colors.transparent,
                            alignment: Alignment.center,
                            child: CustomText(
                              "BEFORE",
                              fontSize: 14,
                              fontWeight: FontVariant.semiBold,
                              color: selectedTab == 0
                                  ? whiteColor
                                  : walletGrey500Color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTab = 1),
                          child: CustomContainer(
                            height: 36,
                            borderRadius: BorderRadius.circular(10),
                            conColor: selectedTab == 1
                                ? redColor
                                : Colors.transparent,
                            alignment: Alignment.center,
                            child: CustomText(
                              "AFTER",
                              fontSize: 14,
                              fontWeight: FontVariant.semiBold,
                              color: selectedTab == 1
                                  ? whiteColor
                                  : walletGrey500Color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// TAB CONTENT (NO EXPANDED INSIDE SCROLL)
              selectedTab == 0
                  ? BeforeTab(
                      isTask:
                          controller.isTaskOwner.value ||
                          controller.isProofSubmitter.value,
                    )
                  : AfterTab(
                      isTask:
                          controller.isTaskOwner.value ||
                          controller.isProofSubmitter.value,
                    ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }), // Close Obx
    );
  }
}
