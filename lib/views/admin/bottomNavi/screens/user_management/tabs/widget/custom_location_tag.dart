import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

import '../../../../../../../utils/colors.dart';

class CustomLocationTag extends StatelessWidget {
  final String city;

  const CustomLocationTag(this.city, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      conColor: appbard,
      borderRadius: BorderRadius.circular(20),
      child: CustomText(
        city,
        fontSize: 12,
        fontWeight: FontVariant.regular,
        color: walletGrey600Color,
      ),
    );
  }
}
