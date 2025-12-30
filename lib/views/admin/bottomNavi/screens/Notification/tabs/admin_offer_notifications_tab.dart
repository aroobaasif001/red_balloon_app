import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/Notification/controller/admin_notification_controller.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/notification/widgets/notification_item.dart';

class AdminOfferNotificationsTab extends StatelessWidget {
  const AdminOfferNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminNotificationController controller = Get.find<AdminNotificationController>();

    return Obx(() {
      if (controller.offerNotifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const CustomText("No offer updates", color: Colors.grey),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: controller.offerNotifications.length,
        itemBuilder: (context, index) {
          final item = controller.offerNotifications[index];
          return NotificationItem(
            title: item['title'] ?? 'Offer Update',
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
