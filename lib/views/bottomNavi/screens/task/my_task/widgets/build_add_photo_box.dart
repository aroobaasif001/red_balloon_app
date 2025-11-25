import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/custom_dotted_border.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

/// Add Photo box with plus icon and text
Widget buildAddPhotoBox() {
  return DottedBorderContainer(
    strokeWidth: 2,
    borderRadius: 18,
    color: borderColor,
    dashSpace: 2,
    child: CustomContainer(
      width: double.infinity,
      conColor: white2Color,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: bordercolor1, width: 1),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircleAvatar(
            radius: 24,
            backgroundColor: whiteColor,
            child: Icon(Icons.add, color: walletTextGreyColor, size: 30),
          ),
          SizedBox(height: 12),
          CustomText(
            'Add Photo',
            fontSize: 14,
            fontWeight: FontVariant.semiBold,
            color: walletGrey700Color,
          ),
          SizedBox(height: 4),
          CustomText(
            'Tap to upload',
            fontSize: 12,
            color: walletGrey500Color,
            fontWeight: FontVariant.regular,
          ),
        ],
      ),
    ),
  );
}
