import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';

import '../widgets/messagetile.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar1(title: 'Messages', showRightImage: false),
            // 🔹 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Search conversations',
                    prefixWidget: Image(
                      image: AssetImage('assets/icons/i (5).png'),
                      height: 25,
                      width: 25,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 MESSAGE LIST (Added)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  MessageTile(
                    name: "Mike Johnson",
                    subtitle: "Furniture Assembly - IKEA",
                    message: "I can help with that! I've assembled lots…",
                    time: "15m",
                    image: "assets/images/user1.png",
                  ),

                  MessageTile(
                    name: "Emma Wilson",
                    subtitle: "Furniture Assembly - IKEA",
                    message: "I can help with that! I've assembled lots…",
                    time: "1h",
                    image: "assets/images/user1.png",
                  ),

                  MessageTile(
                    name: "Lisa Martinez",
                    subtitle: "House Cleaning - 2 Bedroom",
                    message: "Perfect, See You Tomorrow!",
                    time: "2h",
                    image: "assets/images/user1.png",
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
