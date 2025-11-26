import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
// IMPORT YOUR NEW SEPARATE CLASS HERE
import '../../../../../../utils/dialog_helpers.dart';
import '../widgets/providercard.dart';

class TaskDetails2Screen extends StatelessWidget {
  const TaskDetails2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar1(title: 'Task Details', showRightImage: false),

              const SizedBox(height: 20),

              /// ===========================
              /// TOP TASK SUMMARY CARD
              /// ===========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomContainer(
                  conColor: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(18),
                  padding: const EdgeInsets.all(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          "assets/images/sofa.png",
                          height: 70,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "Help Move Furniture",
                              fontSize: 18,
                              fontWeight: FontVariant.bold,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                CustomText(
                                  "500 SAR",
                                  fontSize: 16,
                                  fontWeight: FontVariant.bold,
                                  color: redColor,
                                ),
                                const SizedBox(width: 14),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 15,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 5),
                                    CustomText(
                                      "2 min ago",
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
              /// ===========================
              /// PROVIDER LIST CARDS
              /// ===========================
              ProviderCard(
                initials: "A",
                name: "Anton Furnitures",
                id: "RB-452",
                rating: "4.9",
                description: "(25 Tasks Completed)",
                price: "SAR 650",
                distance: "34.5 km away",

                onViewProfile: () {
                  DialogHelpers.showHelperProfileDialog(context);
                },

                onAccept: () {
                  DialogHelpers.showOfferAcceptedDialog(context: context);
                },

              ),

              ProviderCard(
                initials: "A",
                name: "Anton Furnitures",
                id: "RB-452",
                rating: "4.9",
                description: "(25 Tasks Completed)",
                price: "SAR 650",
                distance: "34.5 km away",
              ),

              ProviderCard(
                initials: "A",
                name: "Anton Furnitures",
                id: "RB-452",
                rating: "4.9",
                description: "(25 Tasks Completed)",
                price: "SAR 650",
                distance: "34.5 km away",
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
