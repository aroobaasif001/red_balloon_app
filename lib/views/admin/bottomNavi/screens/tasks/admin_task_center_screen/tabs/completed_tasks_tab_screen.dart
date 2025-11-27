import 'package:flutter/material.dart';
import '../../widget/completed_task_item_card.dart';
class CompletedTasksTab extends StatelessWidget {
  const CompletedTasksTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          CompletedTaskItemCard(
            title: "Deliver a car to my home",
            price: "SAR 450.00",
            completedAgo: "1h ago",
            image: "assets/images/Rectangle 34625307.png",
          ),
          const SizedBox(height: 16),
          CompletedTaskItemCard(
            title: "Shop some groceries from mart",
            price: "SAR 750.00",
            completedAgo: "3h ago",
            image: "assets/images/Rectangle 34625307.png",
          ),
        ],
      ),
    );
  }
}
