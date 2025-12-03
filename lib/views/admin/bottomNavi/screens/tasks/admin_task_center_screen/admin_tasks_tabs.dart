import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/tabs/all_tasks_tab_screen.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/tabs/completed_tasks_tab_screen.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/tabs/validation_tasks_tab_screen.dart';
import '../../../../../../custom_widgets/custom_container.dart';


class AdminTaskCenterScreen extends StatefulWidget {
  const AdminTaskCenterScreen({super.key});

  @override
  State<AdminTaskCenterScreen> createState() => _AdminTaskCenterScreenState();
}

class _AdminTaskCenterScreenState extends State<AdminTaskCenterScreen> {
  int selectedTab = 0; // 0 = All Tasks, 1 = Validations, 2 = Completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,

      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar1(title: 'Task Center',showRightImage: false,showLeftImage: false,),

            const SizedBox(height: 10),

            /// 🔴 TOP TABS (All Tasks | Validations | Completed)
            /// 🔴 TOP TABS (All Tasks | Validations | Completed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomContainer(
                height: 44,
                borderRadius: BorderRadius.circular(14),
                conColor: conBgColor,
                padding: const EdgeInsets.all(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Row(
                  children: [
                    _buildTopTab("All Tasks", 0),
                    const SizedBox(width: 4),
                    _buildTopTab("Validations", 1),
                    const SizedBox(width: 4),
                    _buildTopTab("Completed", 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// 🔵 TAB CONTENT
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: const [
                  AllTasksTab(),
                  ValidationTasksTab(),
                  CompletedTasksTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TOP TAB BUTTON UI
  /// TOP TAB BUTTON UI
  Widget _buildTopTab(String title, int index) {
    final bool isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: CustomContainer(
          height: 36,
          borderRadius: BorderRadius.circular(10),
          conColor: isActive ? redColor : Colors.transparent,
          alignment: Alignment.center,
          child: CustomText(
            title,
            fontSize: 14,
            fontWeight: FontVariant.semiBold,
            color: isActive ? whiteColor : blackColor,
          ),
        ),
      ),
    );
  }
}
