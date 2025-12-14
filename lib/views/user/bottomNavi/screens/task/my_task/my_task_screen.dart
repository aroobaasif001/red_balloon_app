import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/active_task_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/all_task_tab.dart';
import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/tabs/history_tab.dart';

// import 'package:red_balloon_app/views/user/bottomNavi/screens/task/my_task/widgets/custom_tab_bar_task.dart';

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
            Container(
              child: TabBar(
                controller: controller.tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start, // <-- Add this
                padding: const EdgeInsets.symmetric(horizontal: 15),
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: whiteColor,
                unselectedLabelColor: blackColor,
                labelStyle: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.instrumentSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                onTap: (index) {
                  controller.changeTab(index);
                },
                tabs: const [
                  Tab(text: "TASKS NEAR ME"),
                  Tab(text: "MY TASKS"),
                  Tab(text: "HISTORY"),
                ],
              ),
            ),
            SizedBox(height: 35),
            Expanded(
              child: GetBuilder<TaskTabsController>(
                builder: (ctrl) {
                  return TabBarView(
                    controller: ctrl.tabController,
                    children: [ActiveTab(), AllTaskTab(), HistoryTab()],
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
