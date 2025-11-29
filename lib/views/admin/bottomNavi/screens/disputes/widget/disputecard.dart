import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/disputes/disputes/tabs/dispute_details_screen.dart';

import '../../../../../../custom_widgets/custom_button.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class DisputeCard extends StatelessWidget {
  const DisputeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomContainer(
        borderRadius: BorderRadius.circular(16),
        conColor: whiteColor,
        padding: const EdgeInsets.all(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4, offset: const Offset(0, 3)),
        ],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT SIDE TEXT AREA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("Wash and Clean my Car", fontSize: 15, fontWeight: FontVariant.bold),
                  const SizedBox(height: 4),

                  CustomText("Requester claims incomplete work", fontSize: 13, color: walletTextGreyColor),

                  const SizedBox(height: 10),

                  /// 🔴 Status + distance
                  Row(
                    children: [
                      /// Disputed tag
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        conColor: disBgColor,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, size: 14, color: redColor),
                            const SizedBox(width: 4),
                            CustomText("Disputed", fontSize: 12, color: redColor),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// Distance tag
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        conColor: disBgColor,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: redColor),
                            const SizedBox(width: 4),
                            CustomText("3.2 km", fontSize: 12, color: redColor),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Time tag
                  CustomContainer(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.20),
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    conColor: conBgColor,
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, size: 14, color: timeColor),
                        const SizedBox(width: 4),
                        CustomText("15 mins ago", fontSize: 12, color: timeColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  CustomText("SAR 500", fontSize: 18, fontWeight: FontVariant.bold, color: redColor),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// RIGHT SIDE AREA
            Column(
              children: [
                /// Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/images/Rectangle 34625307.png",
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 10),

                /// View Details Button
                CustomButton(
                  height: 40,
                  width: 130,
                  fontSize: 14,
                  label: 'View Details',
                  onPressed: () {
                    Get.to(() => DisputeDetailsScreen());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
