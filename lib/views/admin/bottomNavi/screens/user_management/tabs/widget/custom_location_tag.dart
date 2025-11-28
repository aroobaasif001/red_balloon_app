import 'package:flutter/material.dart';

class CustomLocationTag extends StatelessWidget {
  final String city;

  const CustomLocationTag(this.city, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        city,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
