import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:red_balloon_app/model/banner_model.dart';
import 'package:red_balloon_app/services/banner_service.dart';
import 'banner_management_controller.dart';

class AddNewBannerController extends GetxController {
  final BannerService _bannerService = BannerService();
  final ImagePicker _picker = ImagePicker();

  // Controllers for text fields
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final ctaController = TextEditingController();

  final isActive = true.obs;
  final selectedImage = Rxn<File>();
  final imageUrl = ''.obs; // For existing images
  final isLoading = false.obs;
  
  final isEditing = false.obs;
  String? bannerId;
  int existingIndex = 0;

  @override
  void onClose() {
    titleController.dispose();
    subtitleController.dispose();
    ctaController.dispose();
    super.onClose();
  }

  void toggleActive(bool value) => isActive.value = value;

  void initForEdit(BannerModel banner) {
    if (isEditing.value) return; // Already initialized
    
    isEditing.value = true;
    bannerId = banner.id;
    imageUrl.value = banner.imageUrl;
    isActive.value = banner.isActive;
    existingIndex = banner.index;
    
    // Fill controllers
    titleController.text = banner.title;
    subtitleController.text = banner.description;
    ctaController.text = banner.cta;
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> saveBanner() async {
    // Image is mandatory. For new banner, selectedImage must be non-null.
    // For edit, if selectedImage is null, it should fallback to existing imageUrl.
    if (!isEditing.value && selectedImage.value == null) {
      Get.snackbar('Error', 'Please select a banner image');
      return;
    }

    // In edit mode, if they somehow cleared everything
    if (isEditing.value && selectedImage.value == null && imageUrl.value.isEmpty) {
      Get.snackbar('Error', 'Banner image is required');
      return;
    }

    try {
      isLoading.value = true;
      
      String? finalImageUrl = imageUrl.value;
      
      // 1. Upload new image if selected
      if (selectedImage.value != null) {
        final uploadedUrl = await _bannerService.uploadBannerImage(selectedImage.value!);
        if (uploadedUrl == null) {
          Get.snackbar('Error', 'Failed to upload image');
          return;
        }
        finalImageUrl = uploadedUrl;
      }

      // 2. Save/Update in Firestore
      final banner = BannerModel(
        id: bannerId,
        title: titleController.text.trim(),
        description: subtitleController.text.trim(),
        imageUrl: finalImageUrl,
        cta: ctaController.text.trim(),
        isActive: isActive.value,
        createdAt: DateTime.now(),
        index: isEditing.value ? existingIndex : 0, // Service will handle shifting for new banners
      );

      if (isEditing.value) {
        await _bannerService.updateBanner(banner);
        Get.back();
        Get.snackbar('Success', 'Banner updated successfully');
      } else {
        await _bannerService.addBanner(banner);
        Get.back();
        Get.snackbar('Success', 'Banner added successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save banner: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
