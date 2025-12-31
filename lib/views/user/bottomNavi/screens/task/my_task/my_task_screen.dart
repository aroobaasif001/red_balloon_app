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
import 'controller/tasks_controller.dart';
import 'package:red_balloon_app/services/auth_service.dart';

class MyTaskScreen extends StatefulWidget {
  final int initialTab;
  const MyTaskScreen({super.key, this.initialTab = 0});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  late TaskTabsController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<TaskTabsController>()) {
      controller = Get.find<TaskTabsController>();
      // 🔥 Execute after build to avoid "markNeedsBuild() called during build" error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.resetTab(toIndex: widget.initialTab);
      });
    } else {
      controller = Get.put(TaskTabsController());
      // Handle initial tab if controller just created
      if (widget.initialTab != 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.changeTab(widget.initialTab);
        });
      }
    }

    // 🔥 Initialize TasksController here so it's ready for all tabs
    if (!Get.isRegistered<TasksController>()) {
      Get.put(TasksController());
    }
  }

  @override
  void dispose() {
    // Optional: Only delete if you want it to refresh every time user enters MyTaskScreen
    // Get.delete<TasksController>(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              color: whiteColor,
              child: TabBar(
                controller: controller.tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                dividerColor: Colors.transparent,
                indicatorAnimation: TabIndicatorAnimation.elastic,
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
                  color: whiteColor,
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
