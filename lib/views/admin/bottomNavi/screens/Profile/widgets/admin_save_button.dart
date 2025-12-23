import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminSaveButton({required VoidCallback onTap, bool isLoading = false}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: CustomContainer(
      height: 48,
      width: double.infinity,
      borderRadius: BorderRadius.circular(15),
      conColor: redColor,
      child: Center(
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: whiteColor,
                  strokeWidth: 2,
                ),
              )
            : const CustomText(
                'Save Banner',
                fontSize: 16,
                fontWeight: FontVariant.semiBold,
                color: whiteColor,
              ),
      ),
    ),
  );
}
