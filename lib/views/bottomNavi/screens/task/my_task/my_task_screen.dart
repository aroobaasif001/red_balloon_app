import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/active_task_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/all_task_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/draft_tab.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/my_task_tab.dart';

class MyTaskScreen extends StatelessWidget {
  const MyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Tasks', disableLeading: true),
        body: SafeArea(
          child: Column(
            children: [
              CustomContainer(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 15),
                conColor: whiteColor,
                padding: EdgeInsets.all(7),
                // boxShadow: [
                //   BoxShadow(
                //     color: blackColor.withOpacity(0.25),
                //     offset: const Offset(0, 4),
                //     blurRadius: 4,
                //   ),
                // ],
                borderRadius: BorderRadius.circular(15),

                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  labelStyle: GoogleFonts.montserrat(
                    color: whiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                  ),
                  indicator: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(40),
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
              Expanded(
                child: TabBarView(
                  children: [
                    AllTaskTab(),
                    MyTaskTab(),
                    ActiveTaskTab(),
                    DraftTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
