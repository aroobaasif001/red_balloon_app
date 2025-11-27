import 'package:flutter/material.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';

/// ROUTE TO DESTINATION CARD: title + map + button
Widget buildRouteCard() {
  return CustomContainer(
    conColor: white2Color,
    borderRadius: BorderRadius.circular(16),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          'Route to Destination',
          fontSize: 14,
          fontWeight: FontVariant.semiBold,
          color: textcolord,
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            'assets/images/location.png',
            height: 170,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        CustomContainer(
          height: 46,
          conColor: whiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: redColor, width: 1.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: 560,
                child: Icon(
                  Icons.navigation_outlined,
                  color: redColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              CustomText(
                'Open Navigation',
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
                color: redColor,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
