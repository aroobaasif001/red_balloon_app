import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import 'package:red_balloon_app/model/banner_model.dart';
import '../../../../../../utils/colors.dart';
import '../tabs/add_new_banner_screen.dart';

import 'package:red_balloon_app/utils/dialog_helpers.dart';

Widget adminBannerCard(
  BuildContext context, {
  required BannerModel banner,
  required int index,
  required ValueChanged<bool> onToggle,
  required VoidCallback onDelete,
}) {
  final imagePath = banner.imageUrl;
  final title = banner.title;
  final description = banner.description;
  final isActive = banner.isActive;

  return CustomContainer(
    padding: const EdgeInsets.all(14),
    conColor: whiteColor,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: borderColor),
    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.25),
        blurRadius: 1,
        offset: const Offset(0, 3),
      ),
    ],
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/dots.png', height: 16, width: 16),
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          height: 120,
                          width: Get.width * 0.75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        )
                      : Image.asset(
                          imagePath,
                          height: 120,
                          width: Get.width * 0.75,
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(height: 12),
              CustomText(
                title,
                fontSize: 16,
                fontWeight: FontVariant.semiBold,
                color: textcolord,
              ),
              const SizedBox(height: 6),
              CustomText(
                description,
                fontSize: 14,
                fontWeight: FontVariant.regular,
                color: walletGrey500Color,
              ),
              const SizedBox(height: 14),
              CustomContainer(
                width: Get.width * 0.76,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        children: [
                          CustomText(
                            isActive ? 'Active' : 'Inactive',
                            fontSize: 13,
                            fontWeight: FontVariant.medium,
                            color: walletGrey600Color,
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: isActive,
                            onChanged: onToggle,
                            activeTrackColor: redColor,
                            activeThumbColor: whiteColor,
                            inactiveTrackColor: whiteColor,
                            inactiveThumbColor: redColor,
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Get.to(() => AddNewBannerScreen(banner: banner));
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: Image.asset(
                              'assets/icons/edit_3.png',
                              height: 16,
                              width: 16,
                              color: rbtxColor,
                            ),
                            label: const CustomText(
                              'Edit',
                              fontSize: 12,
                              fontWeight: FontVariant.semiBold,
                              color: rbtxColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              DialogHelpers.showDeleteBannerConfirmationDialog(
                                context: context,
                                onConfirm: onDelete,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: redColor,
                            ),
                            label: const CustomText(
                              'Delete',
                              fontSize: 12,
                              fontWeight: FontVariant.semiBold,
                              color: redColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
