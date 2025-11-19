import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/active_task_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/all_task_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/draft_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/my_task_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/post_new_task/post_new_task_screen.dart';

class MyTaskScreen extends StatelessWidget {
  const MyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          title: CustomText('Tasks', fontSize: 24, fontWeight: FontVariant.bold),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => PostNewTaskScreen());
              },
              icon: Image(image: AssetImage('assets/icons/plus.png'), height: 38),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              CustomContainer(
                margin: EdgeInsets.symmetric(horizontal: 15),
                conColor: whiteColor,
                padding: EdgeInsets.all(7),
                boxShadow: [
                  BoxShadow(color: blackColor.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4),
                ],
                borderRadius: BorderRadius.circular(15),

                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  labelStyle: GoogleFonts.montserrat(
                    color: whiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  indicator: BoxDecoration(
                    gradient: redOrangeGradientColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'ALL TASKS'),
                    Tab(text: 'MY TASKS'),
                    Tab(text: 'ACTIVE TASKS'),
                    Tab(text: 'DRAFTS'),
                  ],
                ),
              ),
              SizedBox(height: 35),
              Expanded(child: TabBarView(children: [AllTaskTab(), MyTaskTab(), ActiveTaskTab(), DraftTab()])),
            ],
          ),
        ),
      ),
    );
  }
}
