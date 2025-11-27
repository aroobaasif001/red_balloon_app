import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminLogoutButton() {
  return Column(
    children: [
      CustomContainer(
        height: 48,
        borderRadius: BorderRadius.circular(15),
        conColor: redColor,
        child: const Center(
          child: CustomText(
            'Logout',
            fontSize: 16,
            fontWeight: FontVariant.semiBold,
            color: whiteColor,
          ),
        ),
      ),
    ],
  );
}
