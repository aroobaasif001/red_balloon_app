import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminSaveButton({required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: CustomContainer(
      height: 48,
      width: double.infinity,
      borderRadius: BorderRadius.circular(15),
      conColor: redColor,
      child: const Center(
        child: CustomText(
          'Save Banner',
          fontSize: 16,
          fontWeight: FontVariant.semiBold,
          color: whiteColor,
        ),
      ),
    ),
  );
}
