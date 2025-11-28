import 'package:flutter/material.dart';

import '../../../../../../../../utils/colors.dart';

class DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DangerButton({
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
          color:redColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: MaterialButton(
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
