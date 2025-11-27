import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../tabs/banner_management_screen.dart';
import 'admin_setting_row.dart';

Widget adminSettingsCard(
  bool notificationToggle, {
  required ValueChanged<bool> onToggle,
}) {
  return CustomContainer(
    padding: const EdgeInsets.all(16),
    conColor: white2Color,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 4,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          'General Settings',
          fontSize: 16,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
        const SizedBox(height: 14),
        adminSettingsRow(
          label: 'Notifications',
          trailing: Switch(
            value: notificationToggle,
            onChanged: onToggle,
            activeTrackColor: redColor,
            activeThumbColor: whiteColor,
            inactiveTrackColor: whiteColor,
            inactiveThumbColor: redColor,
          ),
        ),
        const SizedBox(height: 10),
        adminSettingsRow(
          label: 'Banner Management',
          trailing: const Icon(
            Icons.chevron_right,
            color: arrowColor,
            size: 30,
          ),
          onTap: () {
            Get.to(() => BannerManagementScreen());
          },
        ),
      ],
    ),
  );
}
