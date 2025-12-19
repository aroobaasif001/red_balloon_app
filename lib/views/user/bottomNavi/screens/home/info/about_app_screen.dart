import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/formatted_text.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../../profile/controllers/user_app_content_controller.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
        title: Obx(() => CustomText(
          contentController.getTitle('about_app', "About the app"),
          fontSize: 20,
          fontWeight: FontVariant.bold,
          color: blackColor,
        )),
      ),
      body: Obx(() {
        final dynamicContent = contentController.getContent('about_app', '');
        final extraData = contentController.getExtraData('about_app');
        final sections = extraData['sections'] as List? ?? [];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/images/splash_logo.png', height: 120),
                ),
                const SizedBox(height: 30),
                const CustomText(
                  "Red Balloon App",
                  fontSize: 20,
                  fontWeight: FontVariant.bold,
                  color: redColor,
                ),
                const SizedBox(height: 15),
                if (dynamicContent.isNotEmpty)
                  FormattedText(
                    text: dynamicContent,
                    fontSize: 16,
                    color: blackColor.withOpacity(0.7),
                  ),
                
                ...sections.map((section) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      CustomText(
                        section['title'] ?? '',
                        fontSize: 18,
                        fontWeight: FontVariant.semiBold,
                        color: blackColor,
                      ),
                      const SizedBox(height: 10),
                      FormattedText(
                        text: section['content'] ?? '',
                        fontSize: 16,
                        color: blackColor.withOpacity(0.7),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 25),
                const CustomText(
                  "Version",
                  fontSize: 18,
                  fontWeight: FontVariant.semiBold,
                  color: blackColor,
                ),
                const SizedBox(height: 10),
                CustomText(
                  "1.0.0",
                  fontSize: 16,
                  color: blackColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
