import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/controller/user_profile_details_controller.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/danger_button.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/key_value_row.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/outline_black_button.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/profile_header_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/progress_bartile.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/rating_summary_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/section_title.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/stats_small_card.dart';

class UserProfileDetailsScreen extends StatelessWidget {
  final String userId;
  const UserProfileDetailsScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    // Initialize controller with userId
    final controller = Get.put(UserProfileDetailsController(), tag: userId);
    controller.fetchUserProfileData(userId);
    return Scaffold(
      appBar: CustomAppBar(titleText: 'User Profile Details'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: redColor),
          );
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROFILE HEADER
                ProfileHeaderCard(
                  name: controller.userName.value,
                  initial: controller.userName.value.isNotEmpty
                      ? controller.userName.value[0].toUpperCase()
                      : 'U',
                  verified: controller.isVerified.value,
                  photoUrl: controller.userPhoto.value,
                ),
                const SizedBox(height: 25),
                // USER PROGRESS SECTION
                CustomContainer(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(16),
                  conColor: white2Color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    bottom: BorderSide(color: bordercol, width: 1),
                    right: BorderSide(color: bordercol, width: 1),
                    left: BorderSide(color: bordercol, width: 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      blurRadius: 1,
                      color: blackColor.withOpacity(0.25),
                    ),
                  ],
                  child: Column(
                    children: [
                      SectionTitle("User Progress"),
                      SizedBox(height: 10),
                      ProgressBarTile(
                        title: "Work as a Requester",
                        percent: controller.requesterProgress.value,
                      ),
                      SizedBox(height: 16),
                      ProgressBarTile(
                        title: "Work as a Helper",
                        percent: controller.helperProgress.value,
                      ),
                      SizedBox(height: 16),
                      ProgressBarTile(
                        title: "Work as a Validator",
                        percent: controller.validatorProgress.value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // RATING CARD
                RatingSummaryCard(
                  rating: controller.rating.value,
                  completed: controller.tasksCompleted.value,
                ),
                const SizedBox(height: 25),

                /// STATS CARDS
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    StatsSmallCard(
                      imagePath: "assets/icons/validation1.png",
                      title: "Validation Accuracy",
                      value: controller.validationAccuracy.value,
                    ),
                    StatsSmallCard(
                      imagePath: "assets/icons/response1.png",
                      title: "Response Time",
                      value: controller.responseTime.value,
                    ),
                    StatsSmallCard(
                      imagePath: "assets/icons/avgd.png",
                      title: "Average Distance",
                      value: controller.averageDistance.value,
                    ),
                    StatsSmallCard(
                      imagePath: "assets/icons/comr.png",
                      title: "Completion Rate",
                      value: controller.completionRate.value,
                    ),
                    StatsSmallCard(
                      imagePath: "assets/icons/vio.png",
                      title: "Dispute Rate",
                      value: controller.disputeRate.value,
                    ),
                    StatsSmallCard(
                      imagePath: "assets/icons/disr.png",
                      title: "Violations",
                      value: controller.violations.value.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                /// ADMIN ANALYTICS
                CustomContainer(
                  margin: const EdgeInsets.only(bottom: 18),
                  border: Border(
                    bottom: BorderSide(color: bordercol, width: 1),
                    right: BorderSide(color: bordercol, width: 1),
                    left: BorderSide(color: bordercol, width: 1),
                  ),
                  conColor: white2Color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.25),
                      blurRadius: 1,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle("Admin Analytics"),
                      CustomContainer(
                        padding: EdgeInsets.all(18),
                        conColor: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              "Task Breakdown",
                              fontSize: 12,
                              fontWeight: FontVariant.semiBold,
                            ),
                            const SizedBox(height: 10),
                            KeyValueRow(
                              title: "Total Tasks",
                              value: controller.totalTasks.value.toString(),
                            ),
                            KeyValueRow(
                              title: "Completed",
                              value: controller.completedTasks.value.toString(),
                            ),
                            KeyValueRow(
                              title: "Cancelled by User",
                              value: controller.cancelledByUser.value
                                  .toString(),
                            ),
                            KeyValueRow(
                              title: "Cancelled by Helper",
                              value: controller.cancelledByHelper.value
                                  .toString(),
                            ),
                            KeyValueRow(
                              title: "Disputed",
                              value: controller.disputedTasks.value.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomContainer(
                        padding: EdgeInsets.all(18),
                        conColor: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              "Wallet Overview",
                              fontSize: 16,
                              fontWeight: FontVariant.bold,
                            ),
                            const SizedBox(height: 10),
                            KeyValueRow(
                              title: "Total Earned",
                              value:
                                  "SAR ${controller.totalEarned.value.toStringAsFixed(0)}",
                            ),
                            KeyValueRow(
                              title: "Current Balance",
                              value:
                                  "SAR ${controller.currentBalance.value.toStringAsFixed(0)}",
                            ),
                            KeyValueRow(
                              title: "Pending Withdrawals",
                              value:
                                  "SAR ${controller.pendingWithdrawals.value.toStringAsFixed(0)}",
                            ),
                            KeyValueRow(
                              title: "Penalties",
                              value: controller.penalties.value.toStringAsFixed(
                                0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    DangerButton(
                      label: "Warn User",
                      onTap: controller.warnUser,
                    ),
                    const SizedBox(width: 12),
                    Obx(() => OutlineBlackButton(
                      label: controller.isSuspended.value ? "Unsuspend Account" : "Suspend Account",
                      onTap: controller.toggleAccountSuspension,
                    )),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }
}
