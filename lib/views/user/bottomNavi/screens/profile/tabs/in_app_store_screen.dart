import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customappbar.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../widgets/storeitemcard.dart';

class InAppStoreScreen extends StatelessWidget {
  const InAppStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar1(title: 'In-App Store', showRightImage: false),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                children: [
                  /// 🔥 Screen subtitle
                  CustomText(
                    "Turn your loyalty points into collectible badges.",
                    fontSize: 14,
                    color: timeColor,
                  ),
                  const SizedBox(height: 20),

                  /// 🔥 Title + Points badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "Your Loyalty Points",
                        fontSize: 18,
                        fontWeight: FontVariant.semiBold,
                        color:blackColor,
                      ),
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        conColor: white2Color,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/Mask group.png",
                              height: 18,
                            ),
                            const SizedBox(width: 6),
                            CustomText(
                              "0 Points",
                              fontSize: 13,
                              fontWeight: FontVariant.bold,
                              color: red2Color,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// 🔥 Grid of store badges
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.90,
                    children: const [
                      StoreItemCard(
                        title: "Elite Tasker",
                        price: 50,
                        image: 'assets/icons/image 51.png',
                      ),

                      StoreItemCard(
                        title: "Pro Performer",
                        price: 100,
                        image: 'assets/icons/image 49.png',
                      ),

                      StoreItemCard(
                        title: "Master Helper",
                        price: 200,
                        image: 'assets/icons/image 50.png',
                      ),

                      StoreItemCard(
                        title: "Task Expert",
                        price: 250,
                        image: 'assets/icons/image 48.png',
                      ),

                      StoreItemCard(
                        title: "Reliable Achiever",
                        price: 300,
                        image: 'assets/icons/image 52.png',
                      ),

                      StoreItemCard(
                        title: "Task Veteran",
                        price: 350,
                        image: 'assets/icons/image 53.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
