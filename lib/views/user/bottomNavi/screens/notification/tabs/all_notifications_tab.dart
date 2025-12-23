import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/controller/notification_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/widgets/notification_item.dart';

class AllNotificationsTab extends StatelessWidget {
  const AllNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.find<NotificationController>();

    return Obx(() {
      if (controller.allNotifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const CustomText("No notifications yet", color: Colors.grey),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: controller.allNotifications.length,
        itemBuilder: (context, index) {
          final item = controller.allNotifications[index];
          return NotificationItem(
            title: item['title'] ?? 'Notification',
            body: item['body'] ?? '',
            time: controller.formatTimeAgo(item['createdAt']),
            isRead: item['read'] ?? false,
            type: item['type'],
            onTap: () {
              controller.markAsRead(item['id']);
              // Navigation can be added here if needed based on item['category']
            },
          );
        },
      );
    });
  }
}
