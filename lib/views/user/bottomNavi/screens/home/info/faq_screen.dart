import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/formatted_text.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../../profile/controllers/user_app_content_controller.dart';

import '../../profile/widgets/faqtile.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  /// Track dropdown open/close states
  List<bool> isOpenList = [false, false, false, false, false];

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
          contentController.getTitle('faq', "FAQ's"),
          fontSize: 20,
          fontWeight: FontVariant.bold,
          color: blackColor,
        )),
      ),
      body: Obx(() {
        final faqItems = contentController.getList('faq', 'items');
        final dynamicContent = contentController.getContent('faq', '');
        
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (dynamicContent.isNotEmpty) ...[
              FormattedText(
                text: dynamicContent,
                fontSize: 14,
                color: blackColor.withOpacity(0.7),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
            ],
            
            ...List.generate(faqItems.length, (index) {
              final item = faqItems[index];
              // Use a local state for each item if needed, but since FAQ list can change, 
              // we might need a better way to track isOpen states.
              // For now, let's just use the index if it exists in isOpenList.
              if (isOpenList.length <= index) {
                isOpenList.add(false);
              }
              
              return Column(
                children: [
                  FaqTile(
                    index: index,
                    question: item['question'] ?? '',
                    isOpen: isOpenList[index],
                    answer: item['answer'] ?? '',
                    onTap: () {
                      setState(() {
                        isOpenList[index] = !isOpenList[index];
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
            
            if (faqItems.isEmpty && dynamicContent.isEmpty)
              const Center(child: CustomText('No FAQ items found.')),
          ],
        );
      }),
    );
  }
}
