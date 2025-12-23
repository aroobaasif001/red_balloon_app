import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import 'package:red_balloon_app/model/banner_model.dart';
import '../controllers/add_new_banner_controller.dart';
import '../widgets/admin_banner_detail_card.dart';
import '../widgets/admin_banner_image_card.dart';
import '../widgets/admin_banner_status_card.dart';
import '../widgets/admin_save_button.dart';

class AddNewBannerScreen extends StatelessWidget {
  final BannerModel? banner;
  const AddNewBannerScreen({super.key, this.banner});

  @override
  Widget build(BuildContext context) {
    // Initialize controller only once
    final AddNewBannerController controller = Get.put(AddNewBannerController());
    
    // Initialize for edit if banner is provided and not already initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (banner != null && !controller.isEditing.value) {
        controller.initForEdit(banner!);
      }
    });

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          titleText: banner != null ? 'Edit Banner' : 'Add New Banner',
        ),
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
                        titleController: controller.titleController,
                        subtitleController: controller.subtitleController,
                        ctaController: controller.ctaController,
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
                      Obx(
                        () => adminSaveButton(
                          onTap: controller.saveBanner,
                          isLoading: controller.isLoading.value,
                        ),
                      ),
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
