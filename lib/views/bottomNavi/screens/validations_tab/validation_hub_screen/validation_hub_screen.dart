// lib/screens/validation/validation_hub_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import '../validation_history_screen/validation_history_screen.dart';
import 'tabs/offlinetasktab.dart';
import '../widgets/validationemptywidget.dart';

// YOUR WIDGETS

class ValidationHubScreen extends StatefulWidget {
  const ValidationHubScreen({super.key});

  @override
  State<ValidationHubScreen> createState() => _ValidationHubScreenState();
}
class _ValidationHubScreenState extends State<ValidationHubScreen> {
  int selectedTab = 0; // 0 = Offline, 1 = Online

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
           CustomAppBar1(
            title: 'Validation Hub',
            showLeftImage: false,
            onRightPressed: () {
              Get.to(()=>ValidationHistoryScreen());
            },
          ),

          const SizedBox(height: 25),

          /// -------------------------
          /// TABS + DIVIDER
          /// -------------------------
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Offline tab
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 0),
                      child: Column(
                        children: [
                          CustomText(
                            "Offline Tasks",
                            fontSize: 16,
                            fontWeight: FontVariant.medium,
                            fontType: AppFont.montserrat,
                            color:
                            selectedTab == 0 ? redColor : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 3,
                            width: 110,
                            decoration: BoxDecoration(
                              color: selectedTab == 0
                                  ? redColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          )
                        ],
                      ),
                    ),

                    /// Online tab
                    GestureDetector(
                      onTap: () => setState(() => selectedTab = 1),
                      child: Column(
                        children: [
                          CustomText(
                            "Online Task",
                            fontSize: 16,
                            fontWeight: FontVariant.medium,
                            fontType: AppFont.montserrat,
                            color:
                            selectedTab == 1 ? redColor : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 3,
                            width: 100,
                            decoration: BoxDecoration(
                              color: selectedTab == 1
                                  ? redColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 1,
              ),
            ],
          ),
          const SizedBox(height: 20),
          /// -------------------------
          /// MAIN CONTENT
          /// -------------------------
          Expanded(
            child: selectedTab == 0
            /// -------------------------
            /// OFFLINE TAB - DO NOT TOUCH
            /// -------------------------
                ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              itemBuilder: (_, index) => const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: OfflineTaskTab(),
              ),
            )
            /// -------------------------
            /// ONLINE TAB - NOW SHOWS EMPTY UI
            /// -------------------------
                : const ValidationEmptyWidget(),
          ),
        ],
      ),
    );
  }
}
