import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_appbar.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../widgets/storeitemcard.dart';

import 'package:get/get.dart';
import '../controller/in_app_store_controller.dart';

class InAppStoreScreen extends StatelessWidget {
  InAppStoreScreen({super.key});

  final InAppStoreController controller = Get.put(InAppStoreController());

  @override
  Widget build(BuildContext context) {
    // Calculate responsive aspect ratio using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final childAspectRatio = (screenWidth / 2 - 21) / (screenHeight * 0.25);

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(titleText: 'In-App Store', disableLeading: true),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                children: [
                  /// 🔥 Screen subtitle
                  CustomText(
                    "Unlock collectible badges with every purchase.",
                    fontSize: 14,
                    color: timeColor,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  /// 🔥 Grid of store badges
                  Obx(
                    () => GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: childAspectRatio,
                      children: [
                        StoreItemCard(
                          title: "Elite Tasker",
                          price: 50,
                          image: 'assets/icons/image 51.png',
                          isOwned: controller.isBadgeOwned("Elite Tasker"),
                        ),
                        StoreItemCard(
                          title: "Pro Performer",
                          price: 100,
                          image: 'assets/icons/image 49.png',
                          isOwned: controller.isBadgeOwned("Pro Performer"),
                        ),
                        StoreItemCard(
                          title: "Master Helper",
                          price: 200,
                          image: 'assets/icons/image 50.png',
                          isOwned: controller.isBadgeOwned("Master Helper"),
                        ),
                        StoreItemCard(
                          title: "Task Expert",
                          price: 250,
                          image: 'assets/icons/image 48.png',
                          isOwned: controller.isBadgeOwned("Task Expert"),
                        ),
                        StoreItemCard(
                          title: "Reliable Achiever",
                          price: 300,
                          image: 'assets/icons/image 52.png',
                          isOwned: controller.isBadgeOwned("Reliable Achiever"),
                        ),
                        StoreItemCard(
                          title: "Task Veteran",
                          price: 350,
                          image: 'assets/icons/image 53.png',
                          isOwned: controller.isBadgeOwned("Task Veteran"),
                        ),
                        StoreItemCard(
                          title: "Seasoned Helper",
                          price: 400,
                          image: 'assets/icons/leaf.png',
                          isOwned: controller.isBadgeOwned("Seasoned Helper"),
                        ),
                        StoreItemCard(
                          title: "Highly Experienced",
                          price: 450,
                          image: 'assets/icons/flag.png',
                          isOwned:
                              controller.isBadgeOwned("Highly Experienced"),
                        ),
                        StoreItemCard(
                          title: "Quality Assured",
                          price: 500,
                          image: 'assets/icons/micro.png',
                          isOwned: controller.isBadgeOwned("Quality Assured"),
                        ),
                        StoreItemCard(
                          title: "Safety Certified",
                          price: 550,
                          image: 'assets/icons/safety.png',
                          isOwned: controller.isBadgeOwned("Safety Certified"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
