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
          // ----------------- TITLE + EDIT BUTTON -----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // InkWell(
              //   onTap: onEdit,
              //   child: Image.asset('assets/icons/edit.png', height: 19),
              // ),
            ],
          ),

          const SizedBox(height: 16),

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

                    // CustomText(
                    //   'Amount Offered',
                    //   fontWeight: FontVariant.semiBold,
                    // ),
                    //
                    const SizedBox(height: 8),
                    CustomText(
                      amount,
                      fontWeight: FontVariant.bold,
                      fontSize: 18,
                      color: blackColor,
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        CustomContainer(
                          // padding: const EdgeInsets.all(8.5),
                          conColor: whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          child: CustomText(
                            distance,
                            fontSize: 14,
                            fontWeight: FontVariant.regular,
                          ),
                        ),
                        CustomContainer(
                          // padding: const EdgeInsets.all(8.5),
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
                    const SizedBox(height: 18),

                    showType == false
                        ? CustomContainer(
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
                            borderRadius: BorderRadius.circular(45),
                            conColor: white2Color,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: grey5Color,
                                  size: 13,
                                ),
                                SizedBox(width: 4),
                                CustomText(
                                  type,
                                  fontWeight: FontVariant.regular,
                                  fontSize: 14,
                                  color: walletGrey500Color,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),

              // IMAGE
              Expanded(
                child: CustomContainer(
                  height: 105,
                  // width: 101,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          // ----------------- OPTIONAL BUTTON -----------------
          if (showButton) ...[
            const SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showType == true
                    ? CustomContainer(
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
                        borderRadius: BorderRadius.circular(45),
                        conColor: white2Color,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: grey5Color,
                              size: 13,
                            ),
                            SizedBox(width: 7),
                            CustomText(
                              type,
                              fontWeight: FontVariant.regular,
                              fontSize: 14,
                              color: walletGrey500Color,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                // SizedBox(width: 5),
                CustomButton(
                  height: 40,
                  label: btnText ?? 'View Details',
                  onPressed: onViewDetails,
                  width: showType == true ? 140 : Get.width * 0.8523,
                  fontSize: 16,
                  fontWeight: FontVariant.semiBold,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
