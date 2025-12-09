import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_task_details_tabs_screen/admin_task_details_tabs_screen.dart';

class TaskItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String distance;
  final String timeAgo;
  final String image;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.distance,
    required this.timeAgo,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      border: Border(
        bottom: BorderSide(color: bordercol, width: 1),
        right: BorderSide(color: bordercol, width: 1),
        left: BorderSide(color: bordercol, width: 1),
      ),       conColor: whiteColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP ROW — TEXT LEFT + IMAGE RIGHT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    CustomText(
                      price,
                      fontSize: 17,
                      fontWeight: FontVariant.bold,
                    ),

                    const SizedBox(height: 3),

                    CustomText(
                      "$distance · $timeAgo",
                      fontSize: 14,
                      color: timeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// IMAGE
              CustomContainer(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    image,
                    width: 105,
                    height: 105,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// BOTTOM ROW
          Row(
            children: [

              /// Offline Task Badge
              // CustomContainer(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 18,
              //     vertical: 8,
              //   ),
              //   borderRadius: BorderRadius.circular(30),
              //   conColor: conBgColor,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.20),
              //       blurRadius: 3,
              //       offset: const Offset(0, 2),
              //     ),
              //   ],
              //   child: const CustomText(
              //     "Offline Task",
              //     fontSize: 13,
              //     color: walletTextGreyColor,
              //   ),
              // ),

              const Spacer(),

              /// VIEW DETAILS BUTTON
              SizedBox(
                height: 40,
                width: 140,
                child: CustomButton(
                  label: "View Details",
                  textColor: whiteColor,
                  fontSize: 15,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
