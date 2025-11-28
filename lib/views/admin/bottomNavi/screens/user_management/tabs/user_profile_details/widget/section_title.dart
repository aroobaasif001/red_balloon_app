import 'package:flutter/material.dart';

import '../../../../../../../../custom_widgets/customtext.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [
          const SizedBox(width: 8),
          CustomText(
            title,
            fontSize: 18,
            fontWeight: FontVariant.bold,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
