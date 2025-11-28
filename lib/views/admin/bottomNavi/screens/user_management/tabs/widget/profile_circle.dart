import 'package:flutter/material.dart';

class ProfileCircle extends StatelessWidget {
  final String initials;

  const ProfileCircle({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.red,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
