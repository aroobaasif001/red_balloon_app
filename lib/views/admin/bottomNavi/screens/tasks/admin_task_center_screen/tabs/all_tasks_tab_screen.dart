import 'package:flutter/material.dart';
import '../../widget/task_item_card.dart';
class AllTasksTab extends StatelessWidget {
  const AllTasksTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          TaskItemCard(
            title: "Deliver a car to my home",
            price: "SAR 450.00",
            distance: "2.5 km away",
            timeAgo: "3 hours ago",
            image: "assets/images/Rectangle 34625307.png",
          ),
          const SizedBox(height: 16),
          TaskItemCard(
            title: "Shop some groceries from mart",
            price: "SAR 750.00",
            distance: "1.5 km away",
            timeAgo: "7 hours ago",
            image: "assets/images/Rectangle 34625307.png",
          ),
        ],
      ),
    );
  }
}
