import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_task_type_tabs.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/controller/active_task_controller.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/activity_task_tabs/activity_offline_task_tabs.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/activity_task_tabs/activity_online_task_tabs.dart';

class ActiveTaskTab extends StatelessWidget {
  const ActiveTaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActiveTaskController>(
      init: ActiveTaskController(),
      builder: (controller) {
        return Column(
          children: [
            // Custom Tab Bar
            Obx(
              () => CustomTaskTypeTabs(
                selectedIndex: controller.selectedTabIndex.value,
                onOfflineTap: () => controller.switchTab(0),
                onOnlineTap: () => controller.switchTab(1),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [ActivityOfflineTaskTabs(), ActivityOnlineTaskTabs()],
              ),
            ),
          ],
        );
      },
    );
  }
}
