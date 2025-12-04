import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/all_task_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/history_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/custom_tab_bar_task.dart';

import '../post_new_task/post_new_task_screen.dart';
import 'controller/task_tabs_controller.dart';

class MyTaskScreen extends StatelessWidget {
  const MyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskTabsController controller = Get.isRegistered<TaskTabsController>()
        ? Get.find<TaskTabsController>()
        : Get.put(TaskTabsController());
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Tasks', disableLeading: true),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 78.0),
        child: FloatingActionButton(
          backgroundColor: redColor,
          foregroundColor: whiteColor,
          child: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),

          // shape: BoxShape.circle,
          onPressed: () {
            Get.to(() => PostNewTaskScreen());
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => CustomTabBarTask(
                selectedIndex: controller
                    .selectedTab
                    .value, // ← your GetX or state variable
                onPostedByMeTap: () => controller.changeTab(0),
                onInProgressTap: () => controller.changeTab(1),
              ),
            ),
            SizedBox(height: 35),
            Expanded(
              child: GetBuilder<TaskTabsController>(
                builder: (ctrl) {
                  return TabBarView(
                    controller: ctrl.tabController,
                    children: [AllTaskTab(), HistoryTab()],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
