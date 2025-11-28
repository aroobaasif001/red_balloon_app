import 'package:flutter/material.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.hint = "Search users",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: white2Color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: taskstatus3),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: const TextStyle(color: taskstatus3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
