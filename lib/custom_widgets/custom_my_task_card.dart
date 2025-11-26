import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final String type;

  final String? btnText;
  final VoidCallback? onEdit;
  final VoidCallback? onViewDetails;
  final bool showButton; // 🔥 NEW OPTIONAL BUTTON
  final bool showType;
  final String buttonText;

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
    this.showButton = false, // default -> hidden
    this.distance = '2.5 km away',
    this.type = 'Location-based Task',
    this.showType = true,
    this.buttonText = 'View Details',
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
                        CustomContainer(
                          conColor: whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          child: CustomText(
                            distance,
                            fontSize: 14,
                            fontWeight: FontVariant.regular,
                          ),
                        ),
                        CustomContainer(
                          conColor: whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          child: CustomText(
                            ' • ${postedTime}',
                            fontSize: 14,
                            fontWeight: FontVariant.regular,
                          ),
                        ),
                      ],
                    ),

                    if (showType == false) ...[
                      SizedBox(height: 9),
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        conColor: white2Color,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              type,
                              fontWeight: FontVariant.regular,
                              fontSize: 14,
                              color: walletGrey500Color,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ],
                ),
              ),

              Expanded(
                child: CustomContainer(
                  height: 100,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          if (showButton) ...[
            const SizedBox(height: 9),
            Row(
              children: [
                if (showType == true) ...[
                  Flexible(
                    flex: 0,
                    child: CustomContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                      conColor: white2Color,
                      child: Row(
                        children: [
                          CustomText(
                            type,
                            fontWeight: FontVariant.regular,
                            fontSize: 14,
                            color: walletGrey500Color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 70),
                ],

                /// BUTTON FIX
                Expanded(
                  child: CustomButton(
                    height: 40,
                    borderRadius: BorderRadius.circular(5),
                    label: btnText ?? 'View Details',
                    onPressed: onViewDetails,
                    width: showType == true ? 140 : Get.width * 0.8523,
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
