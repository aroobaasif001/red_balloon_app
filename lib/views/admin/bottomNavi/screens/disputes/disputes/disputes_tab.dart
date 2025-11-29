import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/disputes/widget/disputecard.dart';
class AdminDisputesTab extends StatelessWidget {
  const AdminDisputesTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔴 TOP APP BAR
            CustomAppBar1(
              title: 'Disputes',
              showLeftImage: false,
              showRightImage: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: CustomText(
                "Active Disputes (3)",
                fontSize: 20,
                fontWeight: FontVariant.bold,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: CustomText(
                "Requires admin review and resolution",
                fontSize: 13,
                color: walletTextGreyColor,
              ),
            ),
            const SizedBox(height: 10),
            /// 🔵 DISPUTE LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return DisputeCard();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 DISPUTE CARD — UI EXACTLY LIKE SCREENSHOT

}
