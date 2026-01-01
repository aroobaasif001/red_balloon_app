import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import 'admin_info_row.dart';

Widget adminUserOverviewCard() {
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          'User Overview',
          fontSize: 16,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
        const SizedBox(height: 22),
        adminInfoRow(
          icon: 'assets/icons/wallet_3.png',
          label: 'Wallet Balance',
          value: '\$1,247.50',
          isEmphasized: true,
          isImage: true,
        ),
        const SizedBox(height: 22),
        adminInfoRow(
          icon: 'assets/icons/shield.png',
          label: 'Warnings Issued',
          value: '0',
          isImage: true,
        ),
      ],
    ),
  );
}
