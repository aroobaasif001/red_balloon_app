import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_appbar.dart';
import '../widgets/storeitemcard.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

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
                  /// 🔥 Grid of store badges
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: childAspectRatio,
                    children: const [
                      StoreItemCard(
                        title: "Elite Tasker",
                        price: 50,
                        image: 'assets/icons/image 51.png',
                        isOwned: true,
                      ),

                      StoreItemCard(
                        title: "Pro Performer",
                        price: 100,
                        image: 'assets/icons/image 49.png',
                        isOwned: true,
                      ),

                      // UserBadgeCard(
                      //   title: "Master Helper",
                      //   price: 200,
                      //   image: 'assets/icons/image 50.png',
                      // ),
                      //
                      // UserBadgeCard(
                      //   title: "Task Expert",
                      //   price: 250,
                      //   image: 'assets/icons/image 48.png',
                      // ),
                      //
                      // UserBadgeCard(
                      //   title: "Reliable Achiever",
                      //   price: 300,
                      //   image: 'assets/icons/image 52.png',
                      // ),
                      //
                      // UserBadgeCard(
                      //   title: "Task Veteran",
                      //   price: 350,
                      //   image: 'assets/icons/image 53.png',
                      // ),
                      // UserBadgeCard(
                      //   title: "Seasoned Helper",
                      //   price: 400,
                      //   image: 'assets/icons/leaf.png',
                      // ),
                      // UserBadgeCard(
                      //   title: "Highly Experienced",
                      //   price: 450,
                      //   image: 'assets/icons/flag.png',
                      // ),
                      // UserBadgeCard(
                      //   title: "Quality Assured",
                      //   price: 500,
                      //   image: 'assets/icons/micro.png',
                      // ),
                      // UserBadgeCard(
                      //   title: "Safety Certified",
                      //   price: 550,
                      //   image: 'assets/icons/safety.png',
                      // ),
                    ],
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
