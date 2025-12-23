import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/full_screen_image_viewer.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/validations_tab/validation_screen/controller/validation_screen_controller.dart';

import '../../../../../../../utils/dialog_helpers.dart';

class BeforeTab extends StatelessWidget {
  final bool isTask;
  const BeforeTab({super.key, required this.isTask});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ValidationScreenController>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// -------------------------------
          /// 📸 IMAGE (289 × 291)
          /// -------------------------------
          CustomContainer(
            height: 289,
            width: 291,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(15),
            conColor: whiteColor,
            alignment: Alignment.center,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.25),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
            child: Obx(() {
              final url = controller.beforePhotoUrl.value;
              return GestureDetector(
                onTap: () {
                  if (url.isNotEmpty) {
                    Get.to(() => FullScreenImageViewer(imageUrl: url));
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: url.isNotEmpty
                      ? Image.network(
                          url,
                          height: 289,
                          width: 291,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 289,
                              width: 291,
                              color: white2Color,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(color: redColor),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            "assets/images/Rectangle 34625290 (1).png",
                            height: 289,
                            width: 291,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          "assets/images/Rectangle 34625290 (1).png",
                          height: 289,
                          width: 291,
                          fit: BoxFit.cover,
                        ),
                ),
              );
            }),
          ),

          SizedBox(height: isTask == false ? 20 : 0),

          /// -------------------------------
          /// RED DESCRIPTION BOX
          /// -------------------------------
          isTask == false
              ? CustomContainer(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                  conColor: redColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 12,
                  ),
                  alignment: Alignment.center,
                  child: CustomText(
                    "Helper uploaded proof of completion.\n"
                    "Review if the task appears done properly.",
                    fontSize: 15,
                    textAlign: TextAlign.center,
                    fontWeight: FontVariant.semiBold,
                    color: whiteColor,
                  ),
                )
              : CustomContainer(),

          SizedBox(height: isTask == false ? 20 : 0),

          /// -------------------------------
          /// VOTING OPTIONS CARD
          /// -------------------------------
          isTask == false
              ? Obx(() => CustomContainer(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(16),
                  conColor: whiteColor,
                  padding: const EdgeInsets.all(20),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.25),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Voting Options Header
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/statistics.png",
                            height: 18,
                          ),
                          const SizedBox(width: 8),
                          const CustomText(
                            "Voting Options",
                            fontSize: 16,
                            fontWeight: FontVariant.semiBold,
                            color: lastTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Option 1: Support Helper
                      _buildVotingOption(
                        context,
                        "Support ${controller.helperName.value}",
                        controller.helperRating.value,
                        controller.myVote.value == 'helper',
                        () {
                          DialogHelpers.showVoteConfirmationDialog(
                            context: context,
                            voteType: 'helper',
                            onConfirm: () async {
                              await controller.submitVote('helper');
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Option 2: Support Requester
                      _buildVotingOption(
                        context,
                        "Support ${controller.requesterName.value}",
                        controller.requesterRating.value,
                        controller.myVote.value == 'requester',
                        () {
                          DialogHelpers.showVoteConfirmationDialog(
                            context: context,
                            voteType: 'requester',
                            onConfirm: () async {
                              await controller.submitVote('requester');
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ))
              : CustomContainer(),

          const SizedBox(height: 25),

          /// -------------------------------
          /// FOOTER NOTE
          /// -------------------------------
          CustomText(
            "Your vote must match community majority to earn\nrewards.",
            fontSize: 14,
            fontWeight: FontVariant.regular,
            textAlign: TextAlign.center,
            color: grey5Color,
          ),
          SizedBox(height: 40),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Helper function to build each voting option row
  Widget _buildVotingOption(
    BuildContext context,
    String label,
    double rating,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CustomText(
                  label,
                  fontSize: 15,
                  fontWeight: FontVariant.medium,
                  color: lastTextColor,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: dotColor, size: 16),
                const SizedBox(width: 4),
                CustomText(
                  rating.toStringAsFixed(1),
                  fontSize: 14,
                  fontWeight: FontVariant.bold,
                  color: textColor2,
                ),
              ],
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? redColor : Colors.transparent,
              border: Border.all(
                color: isSelected ? redColor : walletGrey600Color,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: whiteColor,
                    size: 16,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
