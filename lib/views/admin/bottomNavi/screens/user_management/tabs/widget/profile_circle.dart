import 'package:flutter/material.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ProfileCircle extends StatelessWidget {
  final String initials;

  const ProfileCircle({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: redColor,
      child: Text(
        initials,
        style: const TextStyle(
          color: whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
