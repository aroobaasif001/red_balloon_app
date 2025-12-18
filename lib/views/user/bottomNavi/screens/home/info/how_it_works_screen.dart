import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

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
          "How it works",
          fontSize: 24,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStep(
              number: "1",
              title: "Post a Task",
              description:
                  "Tell us what you need help with. Describe the task, set your budget, and choose a time.",
              icon: Icons.edit_note_outlined,
            ),
            _buildStep(
              number: "2",
              title: "Receive Offers",
              description:
                  "Skilled helpers will browse your task and place offers. You can check their profiles and reviews.",
              icon: Icons.local_offer_outlined,
            ),
            _buildStep(
              number: "3",
              title: "Choose your Helper",
              description:
                  "Select the best helper for your task. Once you accept an offer, the funds are securely held.",
              icon: Icons.person_search_outlined,
            ),
            _buildStep(
              number: "4",
              title: "Get it Done",
              description:
                  "Your helper completes the task. You approve the work, and the payment is released.",
              icon: Icons.task_alt_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CustomContainer(
                height: 40,
                width: 40,
                borderRadius: BorderRadius.circular(20),
                conColor: redColor,
                child: Center(
                  child: CustomText(
                    number,
                    fontSize: 18,
                    fontWeight: FontVariant.bold,
                    color: whiteColor,
                  ),
                ),
              ),
              if (number != "4")
                Container(
                  width: 2,
                  height: 100,
                  color: redColor.withOpacity(0.3),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: redColor, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomText(
                        title,
                        fontSize: 18,
                        fontWeight: FontVariant.bold,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomText(
                  description,
                  fontSize: 15,
                  color: blackColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
