import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/admin_analytics_box.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/danger_button.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/key_value_row.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/outline_black_button.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/profile_header_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/progress_bartile.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/rating_summary_card.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/section_title.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/stats_small_card.dart';

class UserProfileDetailsScreen extends StatelessWidget {
  const UserProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    "User Profile Details",
                    fontSize: 20,
                    fontWeight: FontVariant.bold,
                    alignment: Alignment.center,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // PROFILE HEADER
              const ProfileHeaderCard(
                name: "Anton Furnitures",
                initial: "A",
                verified: true,
              ),

              const SizedBox(height: 25),

              // USER PROGRESS SECTION
              const SectionTitle("User Progress"),

              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(18),
                decoration: _strongBox(),
                child: Column(
                  children: const [
                    ProgressBarTile(
                      title: "Work as a Requester",
                      percent: 0.45,
                    ),
                    SizedBox(height: 16),
                    ProgressBarTile(
                      title: "Work as a Helper",
                      percent: 0.75,
                    ),
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
              const RatingSummaryCard(rating: 4.9, completed: 25),

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
                    imagePath: "assets/icons/disr.png",
                    title: "Dispute Rate",
                    value: "2.5%",
                  ),
                  StatsSmallCard(
                    imagePath: "assets/icons/vio.png",
                    title: "Violations",
                    value: "0",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ADMIN ANALYTICS
              const SectionTitle("Admin Analytics"),

              Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: _strongBox(),
                padding: const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      "Task Breakdown",
                      fontSize: 16,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 10),

                    const KeyValueRow(title: "Total Tasks", value: "25"),
                    const KeyValueRow(title: "Completed", value: "22"),
                    const KeyValueRow(title: "Cancelled by User", value: "1"),
                    const KeyValueRow(title: "Cancelled by Helper", value: "0"),
                    const KeyValueRow(title: "Disputed", value: "2"),

                    const SizedBox(height: 20),

                    const CustomText(
                      "Wallet Overview",
                      fontSize: 16,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 10),

                    const KeyValueRow(title: "Total Earned", value: "SAR 6,850"),
                    const KeyValueRow(title: "Current Balance", value: "SAR 1,240"),
                    const KeyValueRow(title: "Pending Withdrawals", value: "SAR 340"),
                    const KeyValueRow(title: "Penalties", value: "0"),
                  ],
                ),
              ),


              const SizedBox(height: 30),

              Row(
                children: [
                  DangerButton(
                    label: "Warn Helper",
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  OutlineBlackButton(
                    label: "Suspend Account",
                    onTap: () {},
                  ),
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
BoxDecoration _strongBox() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 12,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    )
  ],
);
