import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/danger_button.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/key_value_row.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/outline_black_button.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/profile_header_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/progress_bartile.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/rating_summary_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/section_title.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/stats_small_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/strong_box.dart';

class UserProfileDetailsScreen extends StatelessWidget {
  const UserProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'User Profile Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROFILE HEADER
              const ProfileHeaderCard(
                name: "Anton Furnitures",
                initial: "A",
                verified: true,
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
                ),                 boxShadow: [
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
                      percent: 0.45,
                    ),
                    SizedBox(height: 16),
                    ProgressBarTile(title: "Work as a Helper", percent: 0.75),
                    SizedBox(height: 16),
                    ProgressBarTile(
                      title: "Work as a Validator",
                      percent: 0.12,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // RATING CARD
              const RatingSummaryCard(rating: 4.9, completed: 14),

              const SizedBox(height: 25),

              /// STATS CARDS
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  StatsSmallCard(
                    imagePath: "assets/icons/validation1.png",
                    title: "Validation Accuracy",
                    value: "96%",
                  ),

                  StatsSmallCard(
                    imagePath: "assets/icons/response1.png",
                    title: "Response Time",
                    value: "< 5 min",
                  ),
                  StatsSmallCard(
                    imagePath: "assets/icons/avgd.png",
                    title: "Average Distance",
                    value: "3.2 km",
                  ),
                  StatsSmallCard(
                    imagePath: "assets/icons/comr.png",
                    title: "Completion Rate",
                    value: "98%",
                  ),
                  StatsSmallCard(
                    imagePath: "assets/icons/vio.png",
                    title: "Dispute Rate",
                    value: "2.5%",
                  ),
                  StatsSmallCard(
                    imagePath: "assets/icons/disr.png",
                    title: "Violations",
                    value: "0",
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
                ),                 conColor: white2Color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
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

                          const KeyValueRow(title: "Total Tasks", value: "25"),
                          const KeyValueRow(title: "Completed", value: "22"),
                          const KeyValueRow(
                            title: "Cancelled by User",
                            value: "1",
                          ),
                          const KeyValueRow(
                            title: "Cancelled by Helper",
                            value: "0",
                          ),
                          const KeyValueRow(title: "Disputed", value: "2"),
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

                          const KeyValueRow(
                            title: "Total Earned",
                            value: "SAR 6,850",
                          ),
                          const KeyValueRow(
                            title: "Current Balance",
                            value: "SAR 1,240",
                          ),
                          const KeyValueRow(
                            title: "Pending Withdrawals",
                            value: "SAR 340",
                          ),
                          const KeyValueRow(title: "Penalties", value: "0"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  DangerButton(label: "Warn Helper", onTap: () {}),
                  const SizedBox(width: 12),
                  OutlineBlackButton(label: "Suspend Account", onTap: () {}),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/// STRONG SHADOW BOX (Visible Always)
