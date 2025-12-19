import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/formatted_text.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../controllers/user_app_content_controller.dart';

import '../controller/terms_policy_controller.dart';
import '../widgets/terms_policy_widgets.dart';

class TermsAndPolicyScreen extends StatelessWidget {
  const TermsAndPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Get.put(UserAppContentController());

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: CustomAppBar(
          titleText: contentController.getTitle('terms_privacy', 'Terms & Privacy Policy'),
        ),
        body: GetBuilder<TermsPolicyController>(
          init: TermsPolicyController(),
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final dynamicContent = contentController.getContent('terms_privacy', '');
                    if (dynamicContent.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormattedText(
                          text: dynamicContent,
                          fontSize: 14,
                          color: blackColor.withOpacity(0.7),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                  buildHeading("1. Introduction"),

                  buildBodyRichText(
                    "Welcome to Red Balloon! We are delighted to have you as part of our community. These Terms of Service and Privacy Policy (\"Terms\") govern your access to and use of the Red Balloon mobile application, website, and related services.",
                  ),
                  buildBodyRichText(
                    "Red Balloon connects individuals seeking assistance (",
                    boldWord: "Requesters",
                    endText: ") with individuals offering services (",
                    boldWord2: "Helpers",
                    endText2:
                        ") for various micro-tasks and provides a platform for community validation.",
                  ),
                  const SizedBox(height: 20),
                  buildHeading("2. User Responsibilities"),
                  buildBulletPoints([
                    "Provide accurate and complete information during registration.",
                    "Maintain confidentiality of login credentials.",
                    "Use the Service lawfully and respectfully.",
                    "Treat all users with kindness. Harassment and discrimination lead to suspension.",
                    "Ensure the safety and legality of tasks posted (Requesters) or performed (Helpers).",
                  ]),
                  buildBodyText(
                    "Red Balloon reserves the right to suspend accounts involved in harmful activity.",
                  ),
                  const SizedBox(height: 20),
                  buildHeading("3. Escrow & Payment Rules"),
                  buildSubHeading("Task Budget"),
                  buildBodyRichText(
                    "Users fund the task budget into escrow where both ",
                    boldWord: "Requesters",
                    endText: " and ",
                    boldWord2: "Helpers",
                    endText2: " remain protected.",
                  ),
                  buildSubHeading("Task Completion"),
                  buildBodyText(
                    "Once a Helper marks a task as complete, the Requester has a short review period to approve or dispute.",
                  ),
                  buildSubHeading("Community Validation"),
                  buildBodyText(
                    "If a Requester disputes or does not act, the task is sent to community validation.",
                  ),
                  buildSubHeading("Payment Release"),
                  buildBodyText(
                    "Funds are released to the Helper after validation approval.",
                  ),
                  buildSubHeading("Penalties"),
                  buildBodyText(
                    "Validators may incur penalties for inaccurate decisions.",
                  ),
                  buildSubHeading("Withdrawals"),
                  buildBodyText(
                    "Helpers can withdraw funds from their Red Balloon wallet based on withdrawal policy.",
                  ),
                  const SizedBox(height: 20),
                  buildHeading("4. Data Privacy & Security"),
                  buildSubHeading("Information Collection"),
                  buildBodyText(
                    "We collect information you provide and automatic usage data needed to operate the platform.",
                  ),
                  buildSubHeading("Use of Information"),
                  buildBodyText(
                    "We use your data to operate, maintain, and enhance our services.",
                  ),
                  buildSubHeading("Data Sharing"),
                  buildBodyText(
                    "We never sell your data. Only anonymized or necessary data is shared with trusted processors.",
                  ),
                  buildSubHeading("Security Measures"),
                  buildBodyText(
                    "We use encryption, firewalls, and strong safeguards to protect your information.",
                  ),
                  buildSubHeading("Your Choices"),
                  buildBodyText(
                    "You can manage your privacy settings in the app.",
                  ),
                  buildSubHeading("Children's Privacy"),
                  buildBodyText(
                    "Red Balloon does not serve or collect data from children under 18.",
                  ),
                  const SizedBox(height: 20),
                  buildHeading("5. Contact Information"),
                  RichText(
                    text: TextSpan(
                      text: "If you have any questions, please ",
                      style: const TextStyle(fontSize: 14, color: textColor2),
                      children: [
                        TextSpan(
                          text: "contact us",
                          style: const TextStyle(
                            color: redColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ":"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      text: "Email: ",
                      style: TextStyle(fontSize: 14, color: textColor2),
                      children: [
                        TextSpan(
                          text: "support@redballoon.app",
                          style: TextStyle(
                            color: redColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Address: Red Balloon HQ, Riyadh, Saudi Arabia",
                    style: TextStyle(fontSize: 14, color: textColor2),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
