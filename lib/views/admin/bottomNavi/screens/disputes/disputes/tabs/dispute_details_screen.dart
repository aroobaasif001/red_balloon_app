import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

import 'controller/dispute_details_controller.dart';

class DisputeDetailsScreen extends StatefulWidget {
  final TaskModel? task;

  const DisputeDetailsScreen({super.key, this.task});

  @override
  State<DisputeDetailsScreen> createState() => _DisputeDetailsScreenState();
}

class _DisputeDetailsScreenState extends State<DisputeDetailsScreen> {
  late final DisputeDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DisputeDetailsController());
    if (widget.task != null && widget.task!.id != null) {
      controller.fetchDisputeDetails(widget.task!.id!);
    }
  }

  @override
  void dispose() {
    Get.delete<DisputeDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔴 TOP BAR
              CustomAppBar1(title: 'Dispute Details', showRightImage: false),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ////////////////////////////////////////////////////////
                    /// 🔴 1 — MAIN DISPUTE CARD (Help Move Furniture)
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border(
                        bottom: BorderSide(color: bordercol, width: 1),
                        right: BorderSide(color: bordercol, width: 1),
                        left: BorderSide(color: bordercol, width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Icon
                              CustomContainer(
                                padding: const EdgeInsets.all(8),
                                borderRadius: BorderRadius.circular(12),
                                conColor: rdBgColor,
                                height: 40,
                                width: 32,
                                image: const DecorationImage(
                                  image: AssetImage("assets/icons/svg.png"),
                                  scale: 4,
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// Title + Subtitle
                              Expanded(
                                child: Obx(
                                  () => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        controller.taskTitle.value.isEmpty
                                            ? "Loading..."
                                            : controller.taskTitle.value,
                                        fontSize: 16,
                                        fontWeight: FontVariant.semiBold,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 14),
                                      CustomText(
                                        controller.submittedTime.value.isEmpty
                                            ? "Recently"
                                            : "Submitted ${controller.submittedTime.value}",
                                        fontSize: 13,
                                        color: timeColor,
                                      ),
                                      const SizedBox(height: 6),
                                      CustomText(
                                        controller.requesterUserId.value.isEmpty
                                            ? "User: Loading..."
                                            : "User: ${controller.requesterUserId.value} (Requester)",
                                        fontSize: 13,
                                        color: timeColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// Open Badge
                              CustomContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                conColor: rdBgColor,
                                borderRadius: BorderRadius.circular(20),
                                child: CustomText(
                                  "Open",
                                  fontSize: 13,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ////////////////////////////////////////////////////////
                    /// 🔵 2 — REQUESTER INFORMATION CARD
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border(
                        bottom: BorderSide(color: bordercol, width: 1),
                        right: BorderSide(color: bordercol, width: 1),
                        left: BorderSide(color: bordercol, width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Requester Information",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                              CustomContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                conColor: greenBg,
                                borderRadius: BorderRadius.circular(20),
                                child: CustomText(
                                  "Verified",
                                  fontSize: 12,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Obx(
                            () => Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: redColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomText(
                                        controller.requesterName.value.isEmpty
                                            ? "User Name:   Loading..."
                                            : "User Name:   ${controller.requesterName.value}",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: redColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomText(
                                        controller.requesterCity.value.isEmpty
                                            ? "City:   Loading..."
                                            : "City:   ${controller.requesterCity.value}",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Icon(Icons.tag, color: redColor, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomText(
                                        controller.requesterUserId.value.isEmpty
                                            ? "Request ID:   Loading..."
                                            : "Request ID:   ${controller.requesterUserId.value}",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ////////////////////////////////////////////////////////
                    /// 🟣 3 — HELPER INFORMATION CARD
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border(
                        bottom: BorderSide(color: bordercol, width: 1),
                        right: BorderSide(color: bordercol, width: 1),
                        left: BorderSide(color: bordercol, width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Helper Information",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: rdBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomText(
                                  "Verified Helper",
                                  fontSize: 12,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  controller.helperName.value.isEmpty
                                      ? "Loading..."
                                      : "${controller.helperName.value}     ${controller.helperUserId.value}",
                                  fontSize: 15,
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Icon(Icons.star, color: redColor, size: 18),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      controller.helperRating.value
                                          .toStringAsFixed(1),
                                      fontSize: 14,
                                    ),
                                    const SizedBox(width: 2),
                                    CustomText(
                                      "(${controller.helperTasksCompleted.value} tasks completed)",
                                      fontSize: 14,
                                      color: timeColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          "Validation Accuracy",
                                          fontSize: 14,
                                          color: timeColor,
                                        ),
                                        const SizedBox(height: 4),
                                        CustomText(
                                          "96%",
                                          fontSize: 14,
                                          fontWeight: FontVariant.medium,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          "Response Time",
                                          fontSize: 14,
                                          color: timeColor,
                                        ),
                                        const SizedBox(height: 4),
                                        CustomText(
                                          "<5 min",
                                          fontSize: 14,
                                          fontWeight: FontVariant.medium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ////////////////////////////////////////////////////////
                    /// 🟡 4 — REQUEST REPORTS CARD
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border(
                        bottom: BorderSide(color: bordercol, width: 1),
                        right: BorderSide(color: bordercol, width: 1),
                        left: BorderSide(color: bordercol, width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Requester's Report",
                            fontSize: 16,
                            fontWeight: FontVariant.semiBold,
                          ),
                          const SizedBox(height: 5),
                          const Divider(thickness: 0.5),
                          const SizedBox(height: 5),
                          Obx(
                            () => CustomText(
                              controller.requesterReport.value.isEmpty
                                  ? "No report provided"
                                  : controller.requesterReport.value,
                              fontSize: 14,
                              color: timeColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Divider(thickness: 0.5),
                          const SizedBox(height: 10),
                          CustomText(
                            "Helper's Report",
                            fontSize: 15,
                            fontWeight: FontVariant.semiBold,
                          ),

                          const SizedBox(height: 10),
                          const Divider(thickness: 0.5),
                          const SizedBox(height: 10),

                          Obx(
                            () => CustomText(
                              controller.helperReport.value.isEmpty
                                  ? "No report provided"
                                  : controller.helperReport.value,
                              fontSize: 14,
                              color: timeColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    ////////////////////////////////////////////////////////
                    /// 🔴 BOTTOM ACTION BUTTONS
                    ////////////////////////////////////////////////////////
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Warn Helper",
                            fontSize: 15,
                            onPressed: () {
                              DialogHelpers.showConfirmationDialog(
                                context: context,
                                title: "Warn Helper?",
                                message: "Are you sure you want to send a formal warning to the helper regarding this dispute?",
                                confirmText: "Warn",
                                onConfirm: () => controller.warnHelper(),
                                iconData: Icons.warning_amber_rounded,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Warn Requester",
                            fontSize: 15,
                            onPressed: () {
                              DialogHelpers.showConfirmationDialog(
                                context: context,
                                title: "Warn Requester?",
                                message: "Are you sure you want to send a formal warning to the requester regarding this dispute?",
                                confirmText: "Warn",
                                onConfirm: () => controller.warnRequester(),
                                iconData: Icons.warning_amber_rounded,
                              );
                            },
                            bgColor: whiteColor,
                            textColor: walletBlackColor,
                            border: Border.all(color: walletBlackColor),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Refund Payment",
                            fontSize: 15,
                            onPressed: () {
                              DialogHelpers.showConfirmationDialog(
                                context: context,
                                title: "Refund Payment?",
                                message: "This will refund 96% to the requester and 1% to the helper. Continue?",
                                confirmText: "Refund",
                                onConfirm: () => controller.refundPayment(),
                                iconData: Icons.settings_backup_restore_rounded,
                              );
                            },
                            bgColor: whiteColor,
                            textColor: blackColor,
                            border: Border.all(color: blackColor),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Dismiss Dispute",
                            fontSize: 15,
                            onPressed: () {
                              DialogHelpers.showConfirmationDialog(
                                context: context,
                                title: "Dismiss Dispute?",
                                message: "This will split the funds: 85% to Helper and 7.5% to Requester. Continue?",
                                confirmText: "Dismiss",
                                onConfirm: () => controller.dismissDispute(),
                                iconData: Icons.gavel_rounded,
                              );
                            },
                            bgColor: whiteColor,
                            textColor: blackColor,
                            border: Border.all(color: blackColor),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
