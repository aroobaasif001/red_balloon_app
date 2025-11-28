import 'package:flutter/material.dart';

import '../../../../../../../../utils/colors.dart';

class KeyValueRow extends StatelessWidget {
  final String title;
  final String value;

  const KeyValueRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color:blackColor,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
