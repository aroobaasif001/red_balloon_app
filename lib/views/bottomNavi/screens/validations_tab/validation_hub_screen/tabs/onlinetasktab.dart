// lib/screens/validation/online_task_empty_state.dart

import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

class OnlineTaskTab extends StatelessWidget {
  const OnlineTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(
        "No Online Tasks Available",
        fontSize: 20,
        fontWeight: FontVariant.bold,
      ),
    );
  }
}
