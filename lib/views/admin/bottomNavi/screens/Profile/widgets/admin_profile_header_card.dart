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
                  'AP',
                  color: whiteColor,
                  fontWeight: FontVariant.bold,
                  fontSize: 22,
                ),
              ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Admin Profile',
                    fontSize: 18,
                    fontWeight: FontVariant.bold,
                    color: blackColor,
                  ),
                  Image.asset(
                    'assets/appLogo/White Minimalist Jumma Mubarak Instagram Post (2) 1.png',
                    height: 40,
                    width: 70,
                  ),
                ],
              ),
           //   const SizedBox(height: 2),
              Row(
                children: [
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
            ],
          ),
        ),
      ],
    ),
  );
}
