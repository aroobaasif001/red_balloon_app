import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../controllers/add_new_banner_controller.dart';
import '../widgets/admin_banner_detail_card.dart';
import '../widgets/admin_banner_image_card.dart';
import '../widgets/admin_banner_status_card.dart';
import '../widgets/admin_save_button.dart';

class AddNewBannerScreen extends StatelessWidget {
  const AddNewBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNewBannerController controller =
        Get.put(AddNewBannerController(), permanent: false);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: const CustomAppBar(titleText: 'Add New Banner'),
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
                      adminBannerImageCard(context),
                      const SizedBox(height: 16),
                      adminBannerDetailsCard(
                        context,
                        onTitleChanged: controller.setBannerTitle,
                        onSubtitleChanged: controller.setSubtitle,
                        onCtaChanged: controller.setCtaText,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => adminBannerStatusCard(
                          context,
                          isActive: controller.isActive.value,
                          onToggle: controller.toggleActive,
                        ),
                      ),
                      const SizedBox(height: 80),
                      adminSaveButton(onTap: controller.saveBanner),
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
