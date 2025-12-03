import 'package:flutter/material.dart';

import '../../widget/validation_task_item_card.dart';
class ValidationTasksTab extends StatelessWidget {
  const ValidationTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      child: Column(
        children: [

          ValidationTaskItemCard(
            title: "Deliver a car to my home",
            price: "SAR 450.00",
            startedAgo: "Started 15 mins ago",
            image: "assets/images/Rectangle 34625307.png",
          ),
        ],
      ),
    );
  }
}
