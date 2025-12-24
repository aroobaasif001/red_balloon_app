import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/model/task_model.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/disputes/disputes/tabs/dispute_details_screen.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_all_task_details_screen.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_task_details_tabs_screen/admin_task_details_tabs_screen.dart';
import '../controllers/home_tab_controller.dart';
import '../widgets/admin_task_card.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';

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
        emptyMessage = "No recent validation alerts (last 20 mins)";
      } else if (type == 'wallet') {
        alerts = controller.walletAlerts;
        emptyMessage = "No recent wallet alerts (last 20 mins)";
      } else {
        alerts = controller.taskAlerts;
        emptyMessage = "No recent task alerts (last 20 mins)";
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
        padding: const EdgeInsets.only(bottom: 116),
        itemCount: alerts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final alert = alerts[index];

          String title = "";
          String description = "";
          String iconPath = alert['iconPath'] ?? 'assets/icons/delay.png';

          if (type == 'wallet') {
            title =
                "Withdrawal #${(alert['id'] ?? '').toString().toUpperCase().substring(0, 5)} Pending";
            description =
                "${alert['method'] ?? 'Bank'} transfer of SAR ${alert['amount']} requested by user.";
          } else {
            String taskCode =
                (alert['id'] ?? '').toString().toUpperCase().substring(0, 5);
            title = "Task #$taskCode ${alert['alertType'] ?? ''}";
            description = alert['title'] ??
                alert['description'] ??
                "Action required on this task.";
          }

          return adminTaskCard(
            context,
            iconPath: iconPath,
            title: title,
            description: description,
            timeAgo: _getTimeAgo(alert['eventTime']),
            onViewDetails: () {
              if (type == 'task') {
                if (alert['alertType'] == 'Dispute') {
                  Get.to(() => DisputeDetailsScreen(
                        task: TaskModel(
                          id: alert['id'],
                          uid: alert['uid'] ?? '',
                          taskType: alert['taskType'] ?? '',
                          title: alert['title'] ?? '',
                          description: alert['description'] ?? '',
                          budget: (alert['budget'] ?? 0).toDouble(),
                          createdAt: alert['eventTime'] ?? DateTime.now(),
                        ),
                      ));
                } else {
                  Get.to(() => AdminAllTaskDetailsScreen(taskId: alert['id']));
                }
              } else if (type == 'validation') {
                Get.to(() => AdminTaskDetailsTabsScreen(
                      validationId: alert['id'],
                    ));
              }
            },
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
