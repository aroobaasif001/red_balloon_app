import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blackColor),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: CustomText(
          "Contact Us",
          fontSize: 24,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Get in Touch",
              fontSize: 20,
              fontWeight: FontVariant.bold,
              color: blackColor,
            ),
            const SizedBox(height: 10),
            CustomText(
              "Have questions or need help? Our team is here for you.",
              fontSize: 16,
              color: blackColor.withOpacity(0.7),
            ),
            const SizedBox(height: 30),
            _buildContactMethod(
              icon: Icons.email_outlined,
              title: "Email",
              subtitle: "support@redballoon.com",
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildContactMethod(
              icon: Icons.phone_outlined,
              title: "Phone",
              subtitle: "+1 (123) 456-7890",
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildContactMethod(
              icon: Icons.location_on_outlined,
              title: "Office",
              subtitle: "123 Business Street, Tech City, ST 12345",
              onTap: () {},
            ),
            const SizedBox(height: 40),
            CustomText(
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
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        padding: const EdgeInsets.all(16),
        conColor: rbcolor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Icon(icon, color: redColor, size: 28),
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
