import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminProfileHeaderCard() {
  return CustomContainer(
    padding: const EdgeInsets.all(16),
    conColor: white2Color,
    borderRadius: BorderRadius.circular(20),
    border: Border(
      bottom: BorderSide(color: bordercol, width: 1),
      right: BorderSide(color: bordercol, width: 1),
      left: BorderSide(color: bordercol, width: 1),
    ),
    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.25),
        blurRadius: 1,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar circle
        Column(
          children: [
            CustomContainer(
              height: 64,
              width: 64,
              borderRadius: BorderRadius.circular(999),
              conColor: redColor,
              child: const Center(
                child: CustomText(
                  'SM',
                  color: whiteColor,
                  fontWeight: FontVariant.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 5),
            Image.asset(
              'assets/appLogo/White Minimalist Jumma Mubarak Instagram Post (2) 1.png',
              height: 45,
              width: 79,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Sarah Mitchell',
                    fontSize: 18,
                    fontWeight: FontVariant.bold,
                    color: blackColor,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/icons/edit_3.png',
                      height: 18,
                      width: 18,
                      color: pricecolor2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const CustomText(
                    'ARB-0987',
                    fontSize: 12,
                    fontWeight: FontVariant.regular,
                    color: walletGrey500Color,
                  ),
                  const SizedBox(width: 8),
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    borderRadius: BorderRadius.circular(999),
                    conColor: pinkColor,
                    child: const CustomText(
                      'ADMIN',
                      fontSize: 10,
                      fontWeight: FontVariant.semiBold,
                      color: redColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    borderRadius: BorderRadius.circular(999),
                    conColor: pinkColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.verified, size: 14, color: redColor),
                        SizedBox(width: 4),
                        CustomText(
                          'Verified',
                          fontSize: 10,
                          fontWeight: FontVariant.semiBold,
                          color: redColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
