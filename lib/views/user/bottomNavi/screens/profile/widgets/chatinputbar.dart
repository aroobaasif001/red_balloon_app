import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../../../../../../utils/colors.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Image.asset(
              'assets/icons/attach-btn1.png',
              height: 22,
              width: 19,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: CustomContainer(
              height: 46,
              conColor: whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Color(0xffE0E0E0),
                width: 1,
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          InkWell(
            onTap: () {},
            child: Image.asset(
              'assets/icons/iconchat.png',
              height: 45,
              width: 45,
            ),
          ),
        ],
      ),
    );
  }
}
