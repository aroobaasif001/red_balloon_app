import 'package:flutter/material.dart';

import '../../../../../custom_widgets/custom_container.dart';
import '../../../../../custom_widgets/customtext.dart';

class FaqTile extends StatelessWidget {
  final int index;
  final String question;
  final bool isOpen;
  final String answer;
  final VoidCallback onTap;

  const FaqTile({
    super.key,
    required this.index,
    required this.question,
    required this.isOpen,
    required this.answer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        conColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.all(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  question,
                  fontSize: 14,
                  fontWeight: FontVariant.medium,
                  color: Colors.black,
                ),
                Icon( isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black, )

              ],
            ),

            /// ANSWER WHEN OPEN
            if (isOpen) ...[
              const SizedBox(height: 10),
              CustomText(
                answer,
                fontSize: 13,
                fontWeight: FontVariant.regular,
                color: Colors.black87,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
