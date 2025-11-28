import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

class StatsSmallCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatsSmallCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130, // 🔥 FIXED HEIGHT → All equal size
      width: (MediaQuery.of(context).size.width / 2) - 22, // 🔥 PERFECT GRID WIDTH
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(height: 10),

          CustomText(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              height: 1.2,
            ),
          ),

          const Spacer(), // 🔥 Forces value to bottom → PERFECT alignment

          CustomText(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
