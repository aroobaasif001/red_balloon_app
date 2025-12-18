import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

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
          "FAQ's",
          fontSize: 24,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildFAQItem(
            "How do I post a task?",
            "To post a task, click on the '+' button on the home screen, fill in the details like title, description, budget, and location, then submit.",
          ),
          _buildFAQItem(
            "Is my payment secure?",
            "Yes, we use secure payment gateways to ensure your transactions are safe. Funds are held in escrow until the task is completed and approved.",
          ),
          _buildFAQItem(
            "How do I become a helper?",
            "Simply complete your profile and start browsing available tasks. You can place offers on tasks that match your skills.",
          ),
          _buildFAQItem(
            "What if I'm not satisfied with the work?",
            "You can communicate with the helper through our chat system. If the issue persists, our support team can assist with dispute resolution.",
          ),
          _buildFAQItem(
            "How do I change my location?",
            "You can update your location settings in your profile section to find tasks near you.",
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: rbcolor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rbcolor.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        title: CustomText(
          question,
          fontSize: 16,
          fontWeight: FontVariant.semiBold,
          color: blackColor,
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        expandedAlignment: Alignment.topLeft,
        tilePadding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          CustomText(answer, fontSize: 14, color: blackColor.withOpacity(0.7)),
        ],
      ),
    );
  }
}
