import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/formatted_text.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../profile/controllers/user_app_content_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchEmail(String? email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email ?? 'support@redballoon.com',
      query: 'subject=Support Request&body=Hi Red Balloon Team,',
    );
    try {
      if (!await canLaunchUrl(params)) {
        await launchUrl(params);
      } else {
        Get.snackbar("Error", "Could not launch email app");
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  Future<void> _launchWhatsApp(String? phone) async {
    final cleanPhone = (phone ?? "+966500000000").replaceAll(
      RegExp(r'[^\d+]'),
      '',
    );
    final whatsappUrl = Uri.parse(
      "https://wa.me/${cleanPhone.replaceAll('+', '')}",
    );
    try {
      if (!await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "WhatsApp is not installed");
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }

  Future<void> _launchMaps(String? address) async {
    final query = Uri.encodeComponent(address ?? "Riyadh, Saudi Arabia");
    final googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$query",
    );
    final appleMapsUrl = Uri.parse("http://maps.apple.com/?q=$query");

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not launch maps");
      }
    } catch (e) {
      debugPrint('Error launching maps: $e');
    }
  }

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
        final email = contactInfo['email'] as String?;
        final phone = contactInfo['phone'] as String?;
        final address = contactInfo['address'] as String?;

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
                  subtitle: email ?? "support@redballoon.com",
                  onTap: () => _launchEmail(email),
                ),
                const SizedBox(height: 20),
                _buildContactMethod(
                  isSocialIcon: true,
                  icon: 'assets/icons/whatsapp.png',
                  title: "WhatsApp",
                  subtitle: phone ?? "+966 50 000 0000",
                  onTap: () => _launchWhatsApp(phone),
                ),
                const SizedBox(height: 20),
                _buildContactMethod(
                  icon: Icons.location_on_outlined,
                  title: "Office",
                  subtitle: address ?? "Riyadh, Saudi Arabia",
                  onTap: () => _launchMaps(address),
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
      borderRadius: BorderRadius.circular(12),
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
                    overflow: TextOverflow.ellipsis,
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
    return GestureDetector(
      onTap: () async {
        Uri? url;
        if (icon == Icons.facebook) {
          url = Uri.parse("https://www.facebook.com/redballoonapp");
        } else if (icon == Icons.camera_alt_outlined) {
          url = Uri.parse("https://www.instagram.com/redballoonapp");
        } else if (icon == Icons.alternate_email) {
          final Uri emailUri = Uri(
            scheme: 'mailto',
            path: 'support@redballoon.app',
            query: 'subject=Support Inquiry',
          );
          url = emailUri;
        }

        if (url != null) {
          try {
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              // For mailto, sometimes canLaunchUrl returns false but launchUrl works
              await launchUrl(url);
            }
          } catch (e) {
            debugPrint('Could not launch $url : $e');
            Get.snackbar("Error", "Could not open link");
          }
        }
      },
      child: CustomContainer(
        height: 50,
        width: 50,
        borderRadius: BorderRadius.circular(25),
        conColor: redColor,
        child: Icon(icon, color: whiteColor, size: 24),
      ),
    );
  }
}
