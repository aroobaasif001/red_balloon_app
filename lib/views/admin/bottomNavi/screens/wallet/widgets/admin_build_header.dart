import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminBuildHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const SizedBox(width: 24),
      const CustomText(
        'Platform Wallet',
        fontSize: 18,
        fontWeight: FontVariant.semiBold,
        color: blackColor,
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.refresh, color: blackColor, size: 20),
      ),
    ],
  );
}
