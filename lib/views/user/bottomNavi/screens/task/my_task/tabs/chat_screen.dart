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
            CustomAppBar1(
              title: 'Zernosh Haider',
              showRightImage: false,
            ),
            Expanded(
              child: Container(
                color: whiteColor, // blank area
              ),
            ),
            const ChatInputBar(),
          ],
        ),
      ),
    );
  }
}
