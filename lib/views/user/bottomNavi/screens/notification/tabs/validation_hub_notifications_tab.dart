import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/controller/notification_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/widgets/notification_item.dart';

class ValidationHubNotificationsTab extends StatelessWidget {
  const ValidationHubNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.find<NotificationController>();

    return Obx(() {
      if (controller.validationNotifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fact_check_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const CustomText("No validation hub alerts", color: Colors.grey),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: controller.validationNotifications.length,
        itemBuilder: (context, index) {
          final item = controller.validationNotifications[index];
          return NotificationItem(
            title: item['title'] ?? 'Validation Hub',
            body: item['body'] ?? '',
            time: controller.formatTimeAgo(item['createdAt']),
            isRead: item['read'] ?? false,
            type: item['type'],
            onTap: () {
              controller.markAsRead(item['id']);
            },
          );
        },
      );
    });
  }
}
