import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/edit_profile/widgets/rb_in_put_field.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/profile/edit_profile/widgets/rb_phone_field.dart';

import '../../../../../../utils/dialog_helpers.dart';
import 'controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        titleText: 'Edit Profile',
        titleFontSize: 20,
        titleFontWeight: FontVariant.bold,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Column(
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: controller.pickProfileImage,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 🔴 BIG RED CIRCLE WITH IMAGE
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: redColor,
                            shape: BoxShape.circle,
                          ),
                          child: controller.imagePreviewUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: controller.selectedImage.value != null
                                      ? Image.file(
                                          controller.selectedImage.value!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          controller.imagePreviewUrl.value,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 60,
                                                color: whiteColor,
                                              ),
                                            );
                                          },
                                        ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: whiteColor,
                                  ),
                                ),
                        ),

                        // 📸 SMALL CAMERA BUTTON (white border like screenshot)
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: redColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: whiteColor, width: 3),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/camera4.png',
                                height: 18,
                                width: 18,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const CustomText(
                  'Change Profile Picture',
                  fontSize: 14,
                  color: redColor,
                  fontWeight: FontVariant.bold,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Form Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: bordercol),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME
                  const CustomText(
                    'Full Name',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => RBInputField(
                      hint: 'Enter your name',
                      controller: controller.displayNameController,
                      keyboardType: TextInputType.name,
                      errorText: controller.displayNameError.value,
                      onChanged: (value) => controller.validateDisplayName(value),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // USER ID
                  const CustomText(
                    'User-ID',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  const SizedBox(height: 4),
                  RBInputField(
                    hint: 'RB-102',
                    controller: TextEditingController(text: 'RB-102'),
                    enabled: false,
                  ),
                  const SizedBox(height: 15),

                  // CITY
                  const CustomText(
                    'City',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => RBInputField(
                      hint: 'Enter your city',
                      controller: controller.cityController,
                      keyboardType: TextInputType.text,
                      errorText: controller.cityError.value,
                      onChanged: (value) => controller.validateCity(value),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // COUNTRY
                  const CustomText(
                    'Country',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => RBInputField(
                      hint: 'Enter your country',
                      controller: controller.countryController,
                      keyboardType: TextInputType.text,
                      errorText: controller.countryError.value,
                      onChanged: (value) => controller.validateCountry(value),
                      prefix: Image.asset(
                        'assets/icons/country.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // PHONE
                  const CustomText(
                    'Phone Number',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  SizedBox(height: 4),

                  Obx(
                    () => RBPhoneField(
                      countryCode: controller.selectedCountryCode.value,
                      controller: controller.phoneController,
                      errorText: controller.phoneError.value,
                      onChanged: (value) => controller.validatePhone(value),
                      countryCodes: controller.countryCodes,
                      onCountryCodeChanged: (code) {
                        controller.selectedCountryCode.value = code;
                      },
                    ),
                  ),

                  const SizedBox(height: 4),
                  const SizedBox(height: 15),

                  // WORK EXPERIENCE
                  const CustomText(
                    'Work Experience',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => RBInputField(
                      hint: 'Tell us about your experience (optional)',
                      controller: controller.workExperienceController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      errorText: controller.workExperienceError.value,
                      onChanged: (value) => controller.validateWorkExperience(value),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Obx(
              () => CustomButton(
                label: controller.isLoading.value ? 'Saving...' : 'Save Changes',
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        final success = await controller.updateProfile();
                        if (success) {
                          Future.delayed(Duration(seconds: 1), () {
                            Get.back();
                          });
                        }
                      },
                bgColor: redColor,
                height: 52,
                borderRadius: BorderRadius.circular(16),
                textColor: whiteColor,
                fontSize: 15,
                fontWeight: FontVariant.bold,
              ),
            ),
            const SizedBox(height: 15),

            CustomButton(
              label: 'Cancel',
              onPressed: () {
                Get.back();
              },
              bgColor: whiteColor,
              height: 52,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: bordercol),
              textColor: lastTextColor,
              fontSize: 14,
              fontWeight: FontVariant.bold,
            ),
          ],
        ),
      ),
    );
  }
}
