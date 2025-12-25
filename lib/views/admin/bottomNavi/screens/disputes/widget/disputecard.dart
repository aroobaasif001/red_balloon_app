import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/disputes/disputes/tabs/dispute_details_screen.dart';

import '../../../../../../custom_widgets/custom_button.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class DisputeCard extends StatelessWidget {
  final TaskModel task;
  final String timeAgo;

  const DisputeCard({super.key, required this.task, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    // Determine dispute reason based on who requested help
    String disputeReason = "Dispute in progress";
    if (task.requesterHelpRequested == true &&
        task.requesterHelpReason != null) {
      disputeReason = task.requesterHelpReason!;
    } else if (task.helperHelpRequested == true &&
        task.helperHelpReason != null) {
      disputeReason = task.helperHelpReason!;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomContainer(
        borderRadius: BorderRadius.circular(16),
        conColor: whiteColor,
        padding: const EdgeInsets.all(14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT SIDE TEXT AREA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    task.title,
                    fontSize: 15,
                    fontWeight: FontVariant.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  CustomText(
                    disputeReason,
                    fontSize: 13,
                    color: walletTextGreyColor,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  /// 🔴 Status + distance
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      /// Disputed tag
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        conColor: disBgColor,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 14,
                              color: redColor,
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              "Disputed",
                              fontSize: 12,
                              color: redColor,
                            ),
                          ],
                        ),
                      ),

                      /// Distance tag (if location available)
                      if (task.location != null && task.location!.isNotEmpty)
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          conColor: disBgColor,
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: redColor,
                              ),
                              const SizedBox(width: 4),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.35,
                                ),
                                child: CustomText(
                                  task.location!,
                                  fontSize: 12,
                                  color: redColor,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
                        color: blackColor.withOpacity(0.20),
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    conColor: conBgColor,
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: timeColor,
                        ),
                        const SizedBox(width: 4),
                        CustomText(timeAgo, fontSize: 12, color: timeColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  CustomText(
                    "SAR ${task.budget}",
                    fontSize: 18,
                    fontWeight: FontVariant.bold,
                    color: redColor,
                  ),
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
                  child: task.imageUrl != null && task.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: task.imageUrl!,
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SizedBox(
                            height: 110,
                            width: 110,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: redColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/Rectangle 34625307.png",
                            height: 110,
                            width: 110,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          "assets/images/Rectangle 34625307.png",
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                ),

                const SizedBox(height: 10),

                /// View Details Button
                CustomButton(
                  height: 38,
                  width: 110,
                  fontSize: 13,
                  label: 'View Details',
                  onPressed: () {
                    Get.to(() => DisputeDetailsScreen(task: task));
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
