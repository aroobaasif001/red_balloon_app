import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
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
          child: Obx(() {
            if (controller.banners.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const CustomText(
                      'No banners added yet',
                      fontSize: 16,
                      fontWeight: FontVariant.medium,
                      color: walletGrey600Color,
                    ),
                    const SizedBox(height: 8),
                    const CustomText(
                      'Tap the + button to add your first banner',
                      fontSize: 14,
                      fontWeight: FontVariant.regular,
                      color: walletGrey500Color,
                    ),
                  ],
                ),
              );
            }
            return ReorderableListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: controller.banners.length,
              onReorder: controller.reorderBanners,
              itemBuilder: (context, index) {
                final banner = controller.banners[index];
                return Padding(
                  key: ValueKey(banner.id),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: adminBannerCard(
                    context,
                    banner: banner,
                    index: index,
                    onToggle: (value) =>
                        controller.toggleBannerActive(banner.id, value),
                    onDelete: () => controller.deleteBanner(banner.id),
                  ),
                );
              },
            );
          }),
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
