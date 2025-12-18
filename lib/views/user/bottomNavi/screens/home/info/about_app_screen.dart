import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
          "About the app",
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
            Center(
              child: Image.asset(
                'assets/images/splash_logo.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 30),
            CustomText(
              "Red Balloon App",
              fontSize: 20,
              fontWeight: FontVariant.bold,
              color: redColor,
            ),
            const SizedBox(height: 15),
            CustomText(
              "Welcome to Red Balloon, your ultimate platform for connecting people who need tasks done with those who can do them. Whether you're looking for help with household chores, technical tasks, or professional services, Red Balloon makes it easy and secure.",
              fontSize: 16,
              color: blackColor.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            CustomText(
              "Our Mission",
              fontSize: 18,
              fontWeight: FontVariant.semiBold,
              color: blackColor,
            ),
            const SizedBox(height: 10),
            CustomText(
              "To empower individuals and communities by creating opportunities for work and collaboration, making life easier for everyone through technology.",
              fontSize: 16,
              color: blackColor.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            CustomText(
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
  }
}
