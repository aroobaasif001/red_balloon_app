import 'package:flutter/material.dart';

import '../../../../../../../../utils/colors.dart';

class OutlineBlackButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const OutlineBlackButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color:blackColor),
        ),
        child: MaterialButton(
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
              color:blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
