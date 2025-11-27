import 'package:flutter/material.dart';

import '../widgets/admin_task_card.dart';

class HomeTaskScreen extends StatelessWidget {
  final String type;

  const HomeTaskScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    List<Widget> items;

    if (type == 'validation') {
      items = [
        adminTaskCard(
          context,
          iconPath: 'assets/icons/delay.png',
          title: 'Validation #2847 In Progress',
          description:
              "Validator has not completed checks within the expected timeframe.",
          timeAgo: '10 mins ago',
        ),
        const SizedBox(height: 16),
        adminTaskCard(
          context,
          iconPath: 'assets/icons/delay.png',
          title: 'KYC Review Pending',
          description: "New worker KYC documents waiting for admin validation.",
          timeAgo: '25 mins ago',
        ),
      ];
    } else if (type == 'wallet') {
      items = [
        adminTaskCard(
          context,
          iconPath: 'assets/icons/wallet_3.png',
          title: 'Withdrawal RB-445 Flagged',
          description:
              "Large withdrawal request exceeds daily limit. Manual approval required.",
          timeAgo: '10 mins ago',
        ),
        const SizedBox(height: 16),
        adminTaskCard(
          context,
          iconPath: 'assets/icons/wallet_3.png',
          title: 'Payout Batch #102 Pending',
          description:
              "Scheduled payout requires final confirmation before release.",
          timeAgo: '30 mins ago',
        ),
      ];
    } else {
      items = [
        adminTaskCard(
          context,
          iconPath: 'assets/icons/delay.png',
          title: 'Task #2847 Delayed',
          description:
              "Worker hasn't updated progress in 48hrs. Check status immediately.",
          timeAgo: '25 mins ago',
        ),
      ];
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: items,
    );
  }
}
