import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../controller/upload_proof_controller.dart';
import '../widgets/build_add_photo_box.dart';
import '../widgets/build_before_after_toggle.dart';
import '../widgets/build_camera_gallery_box.dart';
import '../widgets/build_note_field.dart';
import '../widgets/build_submit_button.dart';
import '../widgets/build_task_card.dart';

class UploadProof extends StatelessWidget {
  const UploadProof({super.key});

  @override
  Widget build(BuildContext context) {
    final UploadProofController controller = Get.put(UploadProofController());
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: const CustomAppBar(titleText: 'Upload Proof'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTaskCard(controller),
              const SizedBox(height: 20),
              Obx(
                () => CustomText(
                  controller.infoText.value,
                  fontSize: 14,
                  color: walletGrey600Color,
                  fontWeight: FontVariant.regular,
                ),
              ),
              const SizedBox(height: 20),
              buildBeforeAfterToggle(controller),
              const SizedBox(height: 20),
              buildAddPhotoBox(),
              const SizedBox(height: 16),
              buildCameraGalleryRow(),
              const SizedBox(height: 24),
              const CustomText(
                'Add a note (optional)',
                fontSize: 14,
                fontWeight: FontVariant.semiBold,
                color: rbtxColor,
              ),
              const SizedBox(height: 10),
              buildNoteField(controller),
              const SizedBox(height: 28),
              buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
