import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../widgets/offer_card.dart';
import '../widgets/refresh_button.dart';
import '../widgets/task_info_top_row.dart';
import '../widgets/task_owner_tile.dart';

class Cleanmysolarpanels extends StatelessWidget {
  final String? appBarTitle;
  final String? taskType;
  const Cleanmysolarpanels({super.key, this.taskType, this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              titleText: appBarTitle ?? "Clean my Solar Panels",
              // titleFontSize: 16,
              // titleFontWeight: FontVariant.semiBold,
            ),

            const SizedBox(height: 20),

            Divider(color: bordercolor1, thickness: 1.5, height: 1),

            const SizedBox(height: 20),

            TaskInfoTopRow(),
            const SizedBox(height: 15),

            Divider(color: bordercolor1, thickness: 1.5, height: 1),
            const SizedBox(height: 12),

            const TaskOwnerTile(),

            const SizedBox(height: 10),
            Divider(color: bordercolor1, thickness: 1.5, height: 1),
            const SizedBox(height: 10),

            /// Description
            const CustomText(
              "Description",
              fontSize: 14,
              color: textcolord,
              fontWeight: FontVariant.semiBold,
            ),
            const SizedBox(height: 8),
            const CustomText(
              "Need help cleaning my solar panels. Roof access available. "
              "Should take around 30–40 minutes.",
              fontSize: 14,
              color: rbtxColor,
              fontWeight: FontVariant.regular,
            ),
            const SizedBox(height: 20),

            /// Images
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/homedetail.png",
                      height: 160,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset("assets/images/map.png", height: 160),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  "Offers Received",
                  fontSize: 16,
                  fontWeight: FontVariant.semiBold,
                ),
                CustomContainer(
                  height: 35,
                  conColor: bordercolor1,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.25),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CustomText(
                        taskType ?? '',
                        color: walletGrey600Color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            /// Offers
            const OfferCard(
              name: "Mohammed Saeed",
              stars: 5,
              ratingCount: 17,
              price: "45",
            ),
            const OfferCard(
              name: "Mohammed Saeed",
              stars: 5,
              ratingCount: 17,
              price: "45",
            ),
            const OfferCard(
              name: "Mohammed Saeed",
              stars: 5,
              ratingCount: 17,
              price: "45",
            ),

            const RefreshButton(),
          ],
        ),
      ),
    );
  }
}
