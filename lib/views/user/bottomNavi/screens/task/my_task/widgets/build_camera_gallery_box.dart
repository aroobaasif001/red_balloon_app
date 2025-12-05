import 'package:flutter/material.dart';

import '../../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../../custom_widgets/custom_dotted_border.dart';
import '../../../../../../../utils/colors.dart';
import '../controller/upload_proof_controller.dart';
import 'icon_with_label.dart';

/// Camera / Gallery options row
Widget buildCameraGalleryRow(UploadProofController controller) {
  return DottedBorderContainer(
    strokeWidth: 2,
    borderRadius: 18,
    color: borderColor,
    dashSpace: 2,
    child: CustomContainer(
      conColor: white2Color,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: bordercolor1, width: 1),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => controller.pickImageFromCamera(),
            child: IconWithLabel(icon: Icons.camera_alt, label: 'Camera'),
          ),
          GestureDetector(
            onTap: () => controller.pickImageFromGallery(),
            child: IconWithLabel(icon: Icons.photo, label: 'Gallery'),
          ),
        ],
      ),
    ),
  );
}
