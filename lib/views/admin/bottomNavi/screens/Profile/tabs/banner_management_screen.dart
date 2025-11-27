import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/Profile/tabs/add_new_banner_screen.dart';

import '../controllers/banner_management_controller.dart';
import '../widgets/admin_banner_card.dart';

class BannerManagementScreen extends StatelessWidget {
  const BannerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BannerManagementController controller = Get.put(
      BannerManagementController(),
      permanent: false,
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: const CustomAppBar(titleText: 'Banner Management'),
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Obx(
            () => ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: controller.banners.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final banner = controller.banners[index];
                return adminBannerCard(
                  context,
                  imagePath: banner.imagePath,
                  title: banner.title,
                  description: banner.description,
                  isActive: banner.isActive,
                  onToggle: (value) =>
                      controller.toggleBannerActive(banner.id, value),
                  onDelete: () => controller.deleteBanner(banner.id),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddNewBannerScreen());
          },
          backgroundColor: redColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.add, color: whiteColor),
        ),
      ),
    );
  }
}
