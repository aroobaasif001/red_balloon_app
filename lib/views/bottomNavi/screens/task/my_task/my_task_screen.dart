import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/all_task_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/draft_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/in_progress_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/my_task_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/widgets/custom_tab_bar_task.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/post_new_task/post_new_task_screen.dart';

import 'controller/task_tabs_controller.dart';

class MyTaskScreen extends StatelessWidget {
  const MyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskTabsController controller = Get.put(TaskTabsController());
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Tasks', disableLeading: true),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 78.0),
          child: FloatingActionButton(
            backgroundColor: redColor,
            foregroundColor: whiteColor,
            child: Icon(Icons.add),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),

            // shape: BoxShape.circle,
            onPressed: () {
              Get.to(() => PostNewTaskScreen());
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Obx(
                () => CustomTabBarTask(
                  selectedIndex: controller.selectedTab.value, // ← your GetX or state variable
                  onAllTasksTap: () => controller.changeTab(0),
                  onPostedByMeTap: () => controller.changeTab(1),
                  onInProgressTap: () => controller.changeTab(2),
                  onDraftsTap: () => controller.changeTab(3),
                ),
              ),
              SizedBox(height: 35),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [AllTaskTab(), MyTaskTab(), InProgressTab(), DraftTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
