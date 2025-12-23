import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_tab_controller.dart';
import '../widgets/admin_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:intl/intl.dart';

class HomeTaskScreen extends StatelessWidget {
  final String type;

  const HomeTaskScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final HomeTabsController controller = Get.find<HomeTabsController>();

    return Obx(() {
      List<Map<String, dynamic>> alerts;
      String emptyMessage;

      if (type == 'validation') {
        alerts = controller.validationAlerts;
        emptyMessage = "No recent validation alerts (last 4 mins)";
      } else if (type == 'wallet') {
        alerts = controller.walletAlerts;
        emptyMessage = "No recent wallet alerts (last 4 mins)";
      } else {
        alerts = controller.taskAlerts;
        emptyMessage = "No recent task alerts (last 4 mins)";
      }

      if (alerts.isEmpty) {
        return Center(
          child: CustomText(
            emptyMessage,
            fontSize: 14,
            color: Colors.grey,
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: alerts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final alert = alerts[index];
          
          String title = "";
          String description = "";
          String iconPath = alert['iconPath'] ?? 'assets/icons/delay.png';

          if (type == 'wallet') {
            title = "Withdrawal #${(alert['id'] ?? '').toString().toUpperCase().substring(0, 5)} Pending";
            description = "${alert['method'] ?? 'Bank'} transfer of SAR ${alert['amount']} requested by user.";
          } else {
            String taskCode = (alert['id'] ?? '').toString().toUpperCase().substring(0, 5);
            title = "Task #$taskCode ${alert['alertType'] ?? ''}";
            description = alert['title'] ?? alert['description'] ?? "Action required on this task.";
          }

          return adminTaskCard(
            context,
            iconPath: iconPath,
            title: title,
            description: description,
            timeAgo: _getTimeAgo(alert['eventTime']),
          );
        },
      );
    });
  }

  String _getTimeAgo(dynamic eventTime) {
    if (eventTime == null) return "Unknown";
    DateTime time;
    if (eventTime is DateTime) {
      time = eventTime;
    } else {
      return "Just now";
    }

    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return "Just now";
    return "${diff.inMinutes} mins ago";
  }
}
