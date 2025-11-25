import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/task/my_task/tabs/task_details2_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar1(title: 'Task Details', showRightImage: false),

              const SizedBox(height: 20),

              /// -----------------------
              /// TASK IMAGE
              /// -----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  "Task Image",
                  fontSize: 24,
                  fontWeight: FontVariant.bold,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomContainer(
                  borderRadius: BorderRadius.circular(14),
                  conColor: Colors.white,
                  height: 150,
                  width: double.infinity,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 2,
                      offset: const Offset(0, 3),
                    )
                  ],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      "assets/images/sofa.png",          // <— replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              /// -----------------------
              /// MAIN CARD SECTION
              /// -----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomContainer(
                  conColor: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.all(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      CustomText(
                        "Help Move Furniture",
                        fontSize: 20,
                        fontWeight: FontVariant.bold,
                      ),
                      const SizedBox(height: 12),
                      /// PRICE + TAG
                      Row(
                        children: [
                          CustomText(
                            "SAR 500",
                            fontSize: 28,
                            fontWeight: FontVariant.bold,
                            color: redColor,
                          ),
                          const SizedBox(width: 10),

                          CustomContainer(
                            conColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.20),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            child: Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: redColor),
                                const SizedBox(width: 6),
                                CustomText(
                                  "Location-based Task",
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      /// DESCRIPTION LABEL
                      CustomText(
                        "DESCRIPTION",
                        fontSize: 15,
                        fontWeight: FontVariant.regular,
                        color: walletTextGreyColor,
                      ),
                      const SizedBox(height: 10),
                      /// DESCRIPTION TEXT
                      CustomText(
                        "Need help moving furniture from my apartment to a new location. Items include a sofa, dining table, and several boxes. Helper should have a truck or van. Estimated time: 2-3 hours.",
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 25),
                      /// LOCATION NEARBY LABEL
                      CustomText(
                        "LOCATION NEAR BY",
                        fontSize: 14,
                        fontWeight: FontVariant.regular,
                        color: walletTextGreyColor,
                      ),
                      const SizedBox(height: 10),
                      /// MAP CARD
                      CustomContainer(
                        height: 150,
                        conColor: mapBgColor,
                        borderRadius: BorderRadius.circular(22),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: 1,),

                            /// 📍 Center Pin (Emoji Style)
                            Image(image: AssetImage('assets/icons/map-pin1.png'),height: 40,width: 40,),

                            /// White Input Box
                            CustomContainer(
                              conColor: Colors.white,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: CustomText(
                                "Riyadh, King Fahd Road",
                                fontSize: 13,
                                fontWeight: FontVariant.regular,
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              /// VIEW OFFERS BUTTON
              Center(
                child: CustomButton(
                  width: 263,
                  label: 'View Offers', onPressed: () {
                    Get.to(()=>TaskDetails2Screen());

                },),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
