import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_new_banner_controller.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/custom_dotted_border.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

Widget adminBannerImageCard(BuildContext context) {
  final controller = Get.find<AddNewBannerController>();

  return CustomContainer(
    padding: const EdgeInsets.all(16),
    conColor: whiteColor,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: beforecolor),
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
          'Banner Image',
          fontSize: 14,
          fontWeight: FontVariant.semiBold,
          color: blackColor,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: controller.pickImage,
          child: DottedBorderContainer(
            borderRadius: 16,
            color: borderColor,
            strokeWidth: 2,
            dashWidth: 2,
            dashSpace: 2,
            child: Obx(
              () => CustomContainer(
                height: 140,
                width: double.infinity,
                conColor: whiteColor,
                borderRadius: BorderRadius.circular(16),
                child: controller.selectedImage.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          controller.selectedImage.value!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : (controller.isEditing.value &&
                            controller.imageUrl.value.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              controller.imageUrl.value,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          CustomContainer(
                            height: 44,
                            width: 44,
                            borderRadius: BorderRadius.circular(12),
                            conColor: pinkColor,
                            child: Center(
                              child: Icon(Icons.cloud_upload,
                                  color: redColor, size: 24),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const CustomText(
                            'Upload Banner Image',
                            fontSize: 14,
                            fontWeight: FontVariant.medium,
                            color: walletGrey700Color,
                          ),
                          const SizedBox(height: 4),
                          const CustomText(
                            'Recommended: 3:1 ratio, max 5MB',
                            fontSize: 12,
                            fontWeight: FontVariant.regular,
                            color: walletTransactionDateColor,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
