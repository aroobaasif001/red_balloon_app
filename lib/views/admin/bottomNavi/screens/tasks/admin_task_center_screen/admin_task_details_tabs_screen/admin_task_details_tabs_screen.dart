import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_task_details_tabs_screen/tabs/admin_after_tab.dart';
import 'package:red_balloon_app/views/admin/bottomNavi/screens/tasks/admin_task_center_screen/admin_task_details_tabs_screen/tabs/admin_before_tab.dart';
class AdminTaskDetailsTabsScreen extends StatefulWidget {
  const AdminTaskDetailsTabsScreen({super.key});
  @override
  State<AdminTaskDetailsTabsScreen> createState() => _AdminTaskDetailsTabsScreenState();
}
class _AdminTaskDetailsTabsScreenState extends State<AdminTaskDetailsTabsScreen> {
  int selectedTab = 0; // 0 = BEFORE, 1 = AFTER
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar1(
              title: 'Task Details',
              rightImageHeight: 50,
              rightImageWidth: 20,
              showRightImage: false,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: CustomContainer(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                borderRadius: BorderRadius.circular(20),
                conColor: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 3,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 15, color: walletTextGreyColor),
                          const SizedBox(width: 1),
                          CustomText(
                            "Al Malaz, Riyadh",
                            fontSize: 12,
                            color: timeColor,
                            fontWeight: FontVariant.medium,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomContainer(
                          height: 40,
                          width: 33,
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(14),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/icons/div (3).png",
                            height: 28,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),

                              /// TITLE
                              CustomText(
                                "Help Move Furniture",
                                fontSize: 15,
                                fontWeight: FontVariant.semiBold,
                              ),
                              const SizedBox(height: 6),
                              CustomText(
                                "Helper moved the furniture in the wrong place",
                                fontSize: 14,
                                color: timeColor,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              CustomText(
                                "Completed 10 minutes ago",
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              CustomText(
                                "Task ID: RBT-204",
                                fontSize: 12,
                                color: timeColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                "Participants",
                fontSize: 20,
                fontWeight: FontVariant.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                conColor: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage:
                          AssetImage("assets/images/prof.png"),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    "Ahmad Hassan",
                                    fontSize: 16,
                                    fontWeight: FontVariant.semiBold,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.check_circle,
                                      color: historyGreenColor, size: 18),
                                ],
                              ),
                              CustomText(
                                "Helper ID: RB-452",
                                fontSize: 12,
                                color: timeColor,
                              ),
                            ],
                          ),
                        ),
                        CustomContainer(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          borderRadius: BorderRadius.circular(10),
                          conColor:  helpBgColor,
                          child: CustomText(
                            "Helper",
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Column(
                          children: [
                            CustomText("124",
                                fontSize: 16, fontWeight: FontVariant.semiBold),
                            CustomText("Tasks", fontSize: 12,color: timeColor,),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText("4.8",
                                fontSize: 16, fontWeight: FontVariant.semiBold),
                            CustomText("Rating", fontSize: 12,color: timeColor,),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText("5 min",
                                fontSize: 16, fontWeight: FontVariant.semiBold),
                            CustomText("Response", fontSize: 12,color: timeColor,),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                conColor: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage:
                          AssetImage("assets/images/Rectangle 34625307.png"),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Sarah Al-Rashid",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                              CustomText(
                                "Requester ID: RB-891",
                                fontSize: 12,
                                color: timeColor,
                              ),
                            ],
                          ),
                        ),
                        CustomContainer(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          borderRadius: BorderRadius.circular(10),
                          conColor: helpBgColor,
                          child: CustomText(
                            "Requester",
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Column(
                          children: [
                            CustomText("Riyadh",
                                fontSize: 16, fontWeight: FontVariant.semiBold),
                            CustomText("Location", fontSize: 12,color: timeColor,),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText("8",
                                fontSize: 16, fontWeight: FontVariant.semiBold),
                            CustomText("Posted", fontSize: 12,color: timeColor,),
                          ],
                        ),
                        Column(
                          children: [
                            CustomText("2 yrs",
                                fontSize: 16, fontWeight: FontVariant.semiBold),
                            CustomText("Member", fontSize: 12,color: timeColor,),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomText(
                "Before & After Evidence",
                fontSize: 20,
                fontWeight: FontVariant.bold,
              ),
            ),
            SizedBox(height: 25,),
            /// 🔥 -------------------- BEFORE / AFTER TABS --------------------
            Center(
              child: CustomContainer(
                height: 44,
                width: 173,
                borderRadius: BorderRadius.circular(14),
                conColor: beforecolor,
                padding: const EdgeInsets.all(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = 0),
                        child: CustomContainer(
                          height: 36,
                          borderRadius: BorderRadius.circular(10),
                          conColor: selectedTab == 0 ? redColor : Colors.transparent,
                          alignment: Alignment.center,
                          child: CustomText(
                            "BEFORE",
                            fontSize: 14,
                            fontWeight: FontVariant.semiBold,
                            color: selectedTab == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = 1),
                        child: CustomContainer(
                          height: 36,
                          borderRadius: BorderRadius.circular(10),
                          conColor: selectedTab == 1 ? redColor : Colors.transparent,
                          alignment: Alignment.center,
                          child: CustomText(
                            "AFTER",
                            fontSize: 14,
                            fontWeight: FontVariant.semiBold,
                            color: selectedTab == 1 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            selectedTab == 0 ? const AdminBeforeTab() : const AdminAfterTab(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
