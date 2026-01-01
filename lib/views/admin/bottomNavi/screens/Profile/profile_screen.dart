import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import 'controllers/profile_controller.dart';
import 'widgets/admin_logout_button.dart';
import 'widgets/admin_profile_header_card.dart';
import 'widgets/admin_setting_card.dart';
import 'widgets/admin_user_overall_view_card.dart';

class AdminProfileScreen extends StatelessWidget {
  AdminProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final AdminProfileController controller = Get.put(
      AdminProfileController(),
      permanent: false,
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: const CustomAppBar(titleText: 'Profile Section'),
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      adminProfileHeaderCard(),
                      const SizedBox(height: 16),
                      Obx(() => adminUserOverviewCard(
                        walletBalance: controller.walletBalance.value,
                        warningsCount: controller.warningsIssued.value.toString(),
                        onWalletTap: controller.navigateToTransactions,
                      )),
                      const SizedBox(height: 16),
                      Obx(
                        () => adminSettingsCard(
                          controller.notificationsEnabled.value,
                          onToggle: controller.toggleNotifications,
                        ),
                      ),
                      const SizedBox(height: 26),
                      adminLogoutButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
