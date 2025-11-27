import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: redColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: redColor, size: 24),
          ),
          SizedBox(height: 8),
          CustomText(label, fontSize: 11, color: grey1Color),
        ],
      ),
    );
  }
}
