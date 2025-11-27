import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import '../widgets/chatinputbar.dart';

class contactsupportScreen extends StatelessWidget {
  const contactsupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [

            /// 🔹 TOP APP BAR
            CustomAppBar1(
              title: 'Customer Support',

              showRightImage: false,
            ),

            /// 🔹 EMPTY SPACE (No messages here)
            Expanded(
              child: Container(
                color: Colors.white, // blank area
              ),
            ),

            /// 🔹 CHAT INPUT BAR FIXED AT BOTTOM
            const ChatInputBar(),
          ],
        ),
      ),
    );
  }
}
