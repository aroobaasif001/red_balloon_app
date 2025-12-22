import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_appbar.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../widgets/storeitemcard.dart';

import 'package:get/get.dart';
import '../controller/in_app_store_controller.dart';

class BadgeScreen extends StatelessWidget {
  BadgeScreen({super.key});

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
            CustomAppBar(titleText: 'User Badges'),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                children: [
                  /// 🔥 Grid of owned badges
                  Obx(() {
                    final ownedBadges = InAppStoreController.masterBadgeList
                        .where((b) => controller.isBadgeOwned(b['title']))
                        .toList();

                    if (ownedBadges.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: CustomText(
                            "You don't own any badges yet.",
                            fontSize: 16,
                            color: timeColor,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: ownedBadges.length,
                      itemBuilder: (context, index) {
                        final badge = ownedBadges[index];
                        final title = badge['title'] ?? '';
                        return Obx(
                          () => StoreItemCard(
                            title: title,
                            price: badge['price'] ?? 0,
                            image: badge['image'] ?? '',
                            isOwned: true,
                            isSelected: controller.isBadgeSelected(title),
                            onSelect: () {
                              controller.toggleBadgeSelection(title);
                            },
                          ),
                        );
                      },
                    );
                  }),
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
