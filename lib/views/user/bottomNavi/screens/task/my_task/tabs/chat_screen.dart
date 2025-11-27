import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';

import '../../../../../../../utils/colors.dart';
import '../../../profile/widgets/chatinputbar.dart';

class chatScreen extends StatelessWidget {
  const chatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [

            /// 🔹 TOP APP BAR
            CustomAppBar1(
              title: 'Chat',

              showRightImage: false,
            ),

            /// 🔹 EMPTY SPACE (No messages here)
            Expanded(
              child: Container(
                color: whiteColor, // blank area
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
