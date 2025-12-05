import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/custom_dotted_border.dart';
import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/upload_proof_controller.dart';

/// Add Photo Box - displays selected image or placeholder
Widget buildAddPhotoBox() {
  final controller = Get.find<UploadProofController>();
  
  return Obx(() {
    final isBeforeTab = controller.selectedTab.value == ProofTab.before;
    final selectedImage = isBeforeTab ? controller.beforePhoto.value : controller.afterPhoto.value;

    return DottedBorderContainer(
      strokeWidth: 2,
      borderRadius: 18,
      color: borderColor,
      dashSpace: 2,
      child: CustomContainer(
        height: 200,
        width: double.infinity,
        conColor: white2Color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: bordercolor1, width: 1),
        child: selectedImage != null
            ? Stack(
                children: [
                  // Display selected image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      selectedImage,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Remove button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        if (isBeforeTab) {
                          controller.removeBeforePhoto();
                        } else {
                          controller.removeAfterPhoto();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: walletGrey600Color,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      'Add Photo',
                      fontSize: 14,
                      color: walletGrey600Color,
                      fontWeight: FontVariant.regular,
                    ),
                  ],
                ),
              ),
      ),
    );
  });
}
