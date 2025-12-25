import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_task_details_tabs_screen/tabs/admin_after_tab.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_task_details_tabs_screen/tabs/admin_before_tab.dart';

import 'controller/admin_task_details_controller.dart';
import 'widgets/admin_task_voting_details_widget.dart';

class AdminTaskDetailsTabsScreen extends StatefulWidget {
  final String? validationId;
  const AdminTaskDetailsTabsScreen({super.key, this.validationId});
  @override
  State<AdminTaskDetailsTabsScreen> createState() =>
      _AdminTaskDetailsTabsScreenState();
}

class _AdminTaskDetailsTabsScreenState
    extends State<AdminTaskDetailsTabsScreen> {
  int selectedTab = 0; // 0 = BEFORE, 1 = AFTER
  late final AdminTaskDetailsController controller;

  @override
  void initState() {
    super.initState();
    // 🔥 Delete old controller instance to ensure fresh data
    Get.delete<AdminTaskDetailsController>();
    // Create new controller instance
    controller = Get.put(AdminTaskDetailsController());
    if (widget.validationId != null) {
      print(
        '🔄 Initializing controller for validation: ${widget.validationId}',
      );
      controller.fetchTaskDetails(widget.validationId!);
    }
  }

  @override
  void dispose() {
    // Clean up controller when screen is disposed
    Get.delete<AdminTaskDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar1(
              title: 'Task Details',
              rightImageHeight: 50,
              rightImageWidth: 20,
              showRightImage: false,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                borderRadius: BorderRadius.circular(20),
                conColor: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.20),
                    blurRadius: 3,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 15,
                            color: walletTextGreyColor,
                          ),
                          const SizedBox(width: 1),
                          CustomText(
                            "Al Malaz, Riyadh",
                            fontSize: 12,
                            color: timeColor,
                            fontWeight: FontVariant.medium,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomContainer(
                          height: 40,
                          width: 33,
                          color: rdBgColor,
                          borderRadius: BorderRadius.circular(14),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/icons/div (3).png",
                            height: 28,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),

                              /// TITLE
                              Obx(
                                () => CustomText(
                                  controller.taskTitle.value.isEmpty
                                      ? "Loading..."
                                      : controller.taskTitle.value,
                                  fontSize: 15,
                                  fontWeight: FontVariant.semiBold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Obx(
                                () => CustomText(
                                  controller.rejectionReason.value.isEmpty
                                      ? "Loading..."
                                      : controller.rejectionReason.value,
                                  fontSize: 14,
                                  color: timeColor,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => CustomText(
                                  controller.completedTime.value.isEmpty
                                      ? "Loading..."
                                      : controller.completedTime.value,
                                  fontSize: 12,
                                  color: walletGrey600Color,
                                ),
                              ),
                              Obx(
                                () => CustomText(
                                  controller.taskCreatorUserId.value.isEmpty
                                      ? "Task ID: Loading..."
                                      : "Task ID: ${controller.taskCreatorUserId.value}",
                                  fontSize: 12,
                                  color: timeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                "Participants",
                fontSize: 20,
                fontWeight: FontVariant.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                conColor: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.20),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                controller.helperImage.value.isNotEmpty
                                ? CachedNetworkImageProvider(controller.helperImage.value)
                                : AssetImage("assets/images/prof.png")
                                      as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => CustomText(
                                      controller.helperName.value.isEmpty
                                          ? "Loading..."
                                          : controller.helperName.value,
                                      fontSize: 16,
                                      fontWeight: FontVariant.semiBold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.check_circle,
                                    color: historyGreenColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                              Obx(
                                () => CustomText(
                                  controller.helperUserId.value.isEmpty
                                      ? "Helper ID: Loading..."
                                      : "Helper ID: ${controller.helperUserId.value}",
                                  fontSize: 12,
                                  color: timeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomContainer(
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          conColor: helpBgColor,
                          child: CustomText("Helper", fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Obx(
                              () => CustomText(
                                "${controller.helperTasksCount.value}",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                            ),
                            CustomText("Tasks", fontSize: 12, color: timeColor),
                          ],
                        ),
                        Column(
                          children: [
                            Obx(
                              () => CustomText(
                                controller.helperRating.value.toStringAsFixed(
                                  1,
                                ),
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                            ),
                            CustomText(
                              "Rating",
                              fontSize: 12,
                              color: timeColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Obx(
                              () => CustomText(
                                controller.helperResponseTime.value.isEmpty
                                    ? "5 min"
                                    : controller.helperResponseTime.value,
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                            ),
                            CustomText(
                              "Response",
                              fontSize: 12,
                              color: timeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                conColor: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.20),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => CircleAvatar(
                            radius: 26,
                            backgroundImage:
                                controller.taskCreatorImage.value.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    controller.taskCreatorImage.value,
                                  )
                                : AssetImage(
                                        "assets/images/Rectangle 34625307.png",
                                      )
                                      as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => CustomText(
                                  controller.taskCreatorName.value.isEmpty
                                      ? "Loading..."
                                      : controller.taskCreatorName.value,
                                  fontSize: 16,
                                  fontWeight: FontVariant.semiBold,
                                ),
                              ),
                              Obx(
                                () => CustomText(
                                  controller.taskCreatorUserId.value.isEmpty
                                      ? "Requester ID: Loading..."
                                      : "Requester ID: ${controller.taskCreatorUserId.value}",
                                  fontSize: 12,
                                  color: timeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomContainer(
                          boxShadow: [
                            BoxShadow(
                              color: blackColor.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          conColor: helpBgColor,
                          child: CustomText("Requester", fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Column(
                          children: [
                            CustomText(
                              "Riyadh",
                              fontSize: 16,
                              fontWeight: FontVariant.semiBold,
                            ),
                            CustomText(
                              "Location",
                              fontSize: 12,
                              color: timeColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText(
                              "8",
                              fontSize: 16,
                              fontWeight: FontVariant.semiBold,
                            ),
                            CustomText(
                              "Posted",
                              fontSize: 12,
                              color: timeColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText(
                              "2 yrs",
                              fontSize: 16,
                              fontWeight: FontVariant.semiBold,
                            ),
                            CustomText(
                              "Member",
                              fontSize: 12,
                              color: timeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                "Before & After Evidence",
                fontSize: 20,
                fontWeight: FontVariant.bold,
              ),
            ),
            SizedBox(height: 25),

            /// 🔥 -------------------- BEFORE / AFTER TABS --------------------
            Center(
              child: CustomContainer(
                height: 44,
                width: 173,
                borderRadius: BorderRadius.circular(14),
                conColor: beforecolor,
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
                            color: selectedTab == 0 ? whiteColor : blackColor,
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
                            color: selectedTab == 1 ? whiteColor : blackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => selectedTab == 0
                  ? AdminBeforeTab(imageUrl: controller.beforePhotoUrl.value)
                  : AdminAfterTab(imageUrl: controller.afterPhotoUrl.value),
            ),
            const SizedBox(height: 30),

            // 🔥 Voting and Task Details Widget (shared between both tabs)
            AdminTaskVotingDetailsWidget(controller: controller),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
