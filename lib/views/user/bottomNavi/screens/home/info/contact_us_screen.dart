import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/formatted_text.dart';
import 'package:red_balloon_app/utils/colors.dart';

import '../../profile/controllers/user_app_content_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Get.put(UserAppContentController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: blackColor, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Obx(
          () => CustomText(
            contentController.getTitle('contact_us', "Contact Us"),
            fontSize: 20,
            fontWeight: FontVariant.bold,
            color: blackColor,
          ),
        ),
      ),
      body: Obx(() {
        final contactInfo = contentController.getExtraData('contact_us');
        final dynamicContent = contentController.getContent('contact_us', '');

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  "Get in Touch",
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                  color: blackColor,
                ),
                const SizedBox(height: 10),
                if (dynamicContent.isNotEmpty)
                  FormattedText(
                    text: dynamicContent,
                    fontSize: 16,
                    color: blackColor.withOpacity(0.7),
                  ),
                const SizedBox(height: 30),
                _buildContactMethod(
                  icon: Icons.email_outlined,
                  title: "Email",
                  subtitle: contactInfo['email'] ?? "support@redballoon.com",
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _buildContactMethod(
                  isSocialIcon: true,
                  icon: 'assets/icons/whatsapp.png',
                  title: "WhatsApp",
                  subtitle: contactInfo['phone'] ?? "+1 (123) 456-7890",
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _buildContactMethod(
                  icon: Icons.location_on_outlined,
                  title: "Office",
                  subtitle:
                      contactInfo['address'] ??
                      "123 Business Street, Tech City, ST 12345",
                  onTap: () {},
                ),
                const SizedBox(height: 40),
                const CustomText(
                  "Follow Us",
                  fontSize: 18,
                  fontWeight: FontVariant.semiBold,
                  color: blackColor,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSocialIcon(Icons.facebook),
                    const SizedBox(width: 20),
                    _buildSocialIcon(Icons.camera_alt_outlined),
                    const SizedBox(width: 20),
                    _buildSocialIcon(Icons.alternate_email),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContactMethod({
    required dynamic icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool? isSocialIcon = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        padding: const EdgeInsets.all(16),
        conColor: rbcolor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            isSocialIcon == false
                ? Icon(icon, color: redColor, size: 28)
                : Image.asset(icon, height: 28, width: 28, color: redColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 14,
                    fontWeight: FontVariant.semiBold,
                    color: blackColor,
                  ),
                  CustomText(
                    subtitle,
                    fontSize: 16,
                    color: blackColor.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return CustomContainer(
      height: 50,
      width: 50,
      borderRadius: BorderRadius.circular(25),
      conColor: redColor,
      child: Icon(icon, color: whiteColor, size: 24),
    );
  }
}
