import 'package:flutter/material.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/user_management/tabs/user_profile_details/widget/key_value_row.dart';

import '../../../../../../../../utils/colors.dart';

class AdminAnalyticsSection extends StatelessWidget {
  const AdminAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:white4Color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔴 SECTION TITLE
          Row(
            children: const [
              Icon(Icons.show_chart, color:redColor),
              SizedBox(width: 8),
              Text(
                "Admin Analytics",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔵 TASK BREAKDOWN CONTAINER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color:whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Task Breakdown",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 12),

                KeyValueRow(title: "Total Tasks", value: "25"),
                KeyValueRow(title: "Completed", value: "22"),
                KeyValueRow(title: "Cancelled by User", value: "1"),
                KeyValueRow(title: "Cancelled by Helper", value: "0"),
                KeyValueRow(title: "Disputed", value: "2"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🟢 WALLET OVERVIEW CONTAINER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color:whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Wallet Overview",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 12),

                KeyValueRow(title: "Total Earned", value: "SAR 6,850"),
                KeyValueRow(title: "Current Balance", value: "SAR 1,240"),
                KeyValueRow(title: "Pending Withdrawals", value: "SAR 340"),
                KeyValueRow(title: "Penalties", value: "0"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
