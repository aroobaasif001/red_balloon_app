import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminWalletTransactionCard(
  BuildContext context, {
  required String iconPath,
  required Color iconBg,
  required String id,
  required String amount,
  required String title,
  required String subtitle,
  required String timeAgo,
  bool isWithDrawal = false,
}) {
  return CustomContainer(
    padding: const EdgeInsets.all(14),
    conColor: whiteColor,
    borderRadius: BorderRadius.circular(16),
    border: Border(
      bottom: BorderSide(color: bordercol, width: 1),
      right: BorderSide(color: bordercol, width: 1),
      left: BorderSide(color: bordercol, width: 1),
    ),
    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.25),
        blurRadius: 1,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          height: 44,
          width: 44,
          borderRadius: BorderRadius.circular(12),
          conColor: iconBg,
          child: Center(child: Image.asset(iconPath, height: 22, width: 22)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                id,
                fontSize: 14,
                fontWeight: FontVariant.bold,
                color: textcolord,
              ),
              SizedBox(height: 8),

              CustomText(
                amount,
                fontSize: 18,
                fontWeight: FontVariant.bold,
                color: textcolord,
              ),
              const SizedBox(height: 12),
              CustomText(
                title,
                fontSize: 12,
                fontWeight: FontVariant.medium,
                color: walletGrey600Color,
              ),
              SizedBox(height: isWithDrawal ? 0 : 16),
              isWithDrawal
                  ? SizedBox()
                  : CustomText(
                      subtitle,
                      fontSize: 12,
                      fontWeight: FontVariant.medium,
                      color: walletGrey500Color,
                    ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 12,
                    color: walletTextGreyColor,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    timeAgo,
                    fontSize: 12,
                    fontWeight: FontVariant.regular,
                    color: walletTextGreyColor,
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
