import 'package:flutter/material.dart';

import '../../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../../utils/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [
          CustomText(
            title,
            fontSize: 18,
            color: black4Color,
            fontWeight: FontVariant.bold,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
