import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomMyTaskCard extends StatelessWidget {
  final String title;
  final String amount;
  final String status;
  final String postedTime;
  final String image;
  final String distance;
  final bool isNetworkImage;
  final String? taskType; // 🔥 NEW: To check if online or offline

  final String? btnText;
  final VoidCallback? onEdit;
  final VoidCallback? onViewDetails;
  final bool showButton;
  final bool showType;
  final String buttonText;
  final Color? buttonColor; // 🔥 NEW: Custom button color
  final bool isButtonEnabled; // 🔥 NEW: To disable button

  const CustomMyTaskCard({
    super.key,
    required this.title,
    required this.amount,
    required this.status,
    required this.postedTime,
    required this.image,
    this.onEdit,
    this.btnText,
    this.onViewDetails,
    this.showButton = false,
    this.distance = '2.5 km away',
    this.isNetworkImage = false,
    this.taskType, // 🔥 NEW
    this.showType = true,
    this.buttonText = 'View Details',
    this.buttonColor, // 🔥 NEW
    this.isButtonEnabled = true, // 🔥 NEW - default enabled
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.maxFinite,
      padding: const EdgeInsets.all(14),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.25),
          offset: const Offset(0, 4),
          blurRadius: 4,
        ),
      ],

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- AMOUNT + IMAGE -----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      amount,
                      fontWeight: FontVariant.bold,
                      fontSize: 18,
                      color: blackColor,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        // 🔥 Only show distance if NOT Online Task
                        if (taskType != 'Online Task') ...[
                          CustomContainer(
                            conColor: whiteColor,
                            borderRadius: BorderRadius.circular(15),
                            child: CustomText(
                              distance,
                              fontSize: 14,
                              fontWeight: FontVariant.regular,
                            ),
                          ),
                          // Add dot separator only if distance is shown
                          CustomText(
                            ' • ',
                            fontSize: 14,
                            fontWeight: FontVariant.regular,
                          ),
                        ],

                        Expanded(
                          child: CustomContainer(
                            // width: Get.width*0.33, // Removed fixed width to avoid overflow
                            conColor: whiteColor,
                            borderRadius: BorderRadius.circular(15),
                            child: CustomText(
                              postedTime, // Removed ' • ' prefix as it is handled above
                              fontSize: 14,
                              fontWeight: FontVariant.regular,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // if (showType == false) ...[
                    //   SizedBox(height: 9),
                    //   CustomContainer(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 14,
                    //       vertical: 8,
                    //     ),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: blackColor.withOpacity(0.25),
                    //         offset: const Offset(0, 4),
                    //         blurRadius: 4,
                    //       ),
                    //     ],
                    //     borderRadius: BorderRadius.circular(12),
                    //     conColor: white2Color,
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         // CustomText(
                    //         //   // type,
                    //         //   fontWeight: FontVariant.regular,
                    //         //   fontSize: 14,
                    //         //   color: walletGrey500Color,
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    //   SizedBox(height: 8),
                    // ],
                  ],
                ),
              ),

              Expanded(
                child: CustomContainer(
                  height: 100,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: isNetworkImage
                        ? NetworkImage(image) as ImageProvider
                        : AssetImage(image),
                    fit: BoxFit.cover,
                    onError: isNetworkImage
                        ? (exception, stackTrace) {
                            // Handle network image error
                            print('Error loading network image: $exception');
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),
          if (showButton) ...[
            const SizedBox(height: 9),
            Row(
              children: [
                // if (showType == true) ...[const SizedBox(width: 70)],

                /// BUTTON FIX
                Expanded(
                  child: CustomButton(
                    height: 40,
                    borderRadius: BorderRadius.circular(5),
                    label: btnText ?? 'View Details',
                    onPressed: isButtonEnabled
                        ? onViewDetails
                        : null, // 🔥 Disable if needed
                    bgColor:
                        buttonColor ??
                        redColor, // 🔥 Use custom color or default red
                    // width: showType == true ? 140 : Get.width * 0.8523,
                    fontSize: 16,
                    fontWeight: FontVariant.semiBold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
