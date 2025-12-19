import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/formatted_text.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../../profile/controllers/user_app_content_controller.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

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
          contentController.getTitle('how_it_works', "How it works"),
          fontSize: 20,
          fontWeight: FontVariant.bold,
          color: blackColor,
        )),
      ),
      body: Obx(() {
        final steps = contentController.getList('how_it_works', 'steps');
        final dynamicContent = contentController.getContent('how_it_works', '');
        
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (dynamicContent.isNotEmpty)
                  FormattedText(
                    text: dynamicContent,
                    fontSize: 15,
                    color: blackColor.withOpacity(0.7),
                  ),
                const SizedBox(height: 30),
                ...List.generate(steps.length, (index) {
                  final step = steps[index];
                  return _buildStep(
                    number: (index + 1).toString(),
                    title: step['title'] ?? '',
                    description: step['description'] ?? '',
                    isLast: index == steps.length - 1,
                  );
                }),
                if (steps.isEmpty && dynamicContent.isEmpty)
                  const Center(child: CustomText('No items found.')),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    bool isLast = false,
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
              if (!isLast)
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
