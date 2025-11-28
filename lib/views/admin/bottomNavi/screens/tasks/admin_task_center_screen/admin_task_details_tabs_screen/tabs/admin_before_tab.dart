import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
class AdminBeforeTab extends StatelessWidget {
  const AdminBeforeTab({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomContainer(
              padding: const EdgeInsets.all(0),
              height: 320,
              width: double.infinity,
              borderRadius: BorderRadius.circular(20),
              conColor: whiteColor,
              image: DecorationImage(image: AssetImage('assets/images/Rectangle 34625290 (1).png'),scale: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const CustomText(
            "User Votes",
            fontSize: 18,
            fontWeight: FontVariant.bold,
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 12),
          CustomContainer(
            borderRadius: BorderRadius.circular(16),
            conColor: whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  "Voting Poll",
                  fontSize: 16,
                  fontWeight: FontVariant.semiBold,
                ),
                SizedBox(height: 5,),
                Divider(thickness: 0.5,),
                SizedBox(height: 5,),
              Row(
                children: [
                  /// LEFT TILE
                  Expanded(
                    child: CustomContainer(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      borderRadius: BorderRadius.circular(12),
                      conColor: conBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      child: Row(
                        children: [
                          Icon(Icons.arrow_upward, color: redColor, size: 30),
                          const SizedBox(width: 3),
                         Column(children: [
                           const CustomText(
                             "Support\nRequester",
                             fontSize: 16,
                             maxLines: 2,
                             fontWeight: FontVariant.medium,
                             color: timeColor,
                           ),
                           const SizedBox(height: 2),
                           const CustomText(
                             "Total Votes: 06",
                             fontSize: 14,
                             color: timeColor,
                           ),
                         ],)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// RIGHT TILE
                  Expanded(
                    child: CustomContainer(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      borderRadius: BorderRadius.circular(12),
                      conColor: conBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      child: Row(
                        children: [
                          Icon(Icons.arrow_downward, color: redColor, size: 30),
                          const SizedBox(width: 3),
                         Column(children: [
                           const CustomText(
                             "Support\nHelper",
                             fontSize: 16,
                             fontWeight: FontVariant.medium,
                             color: timeColor,
                           ),
                           const SizedBox(height: 2),
                           const CustomText(
                             "Total Votes: 05",
                             fontSize: 14,
                             color: timeColor,
                           ),
                         ],)
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

                const CustomText(
                  "Voting is being done by the users, please wait!",
                  fontSize: 13,
                  fontWeight: FontVariant.bold,
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          const CustomText(
            "Task Details",
            fontSize: 18,
            fontWeight: FontVariant.bold,
          ),
          const SizedBox(height: 15),
          CustomContainer(
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(20),
            conColor: whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  "Description",
                  fontSize: 16,
                  fontWeight: FontVariant.semiBold,
                ),

                const SizedBox(height: 5),
              Divider(thickness: 0.5,),
                const SizedBox(height: 8),
                const CustomText(
                  "Need help moving furniture from my old apartment to new one. "
                      "Items include sofa, dining table, chairs, and some boxes. "
                      "Helper should have transport.",
                  fontSize: 14,
                ),
                const SizedBox(height: 5),
                Divider(thickness: 0.5,),
                SizedBox(height: 10,),
                /// GRID ROW 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText("Escrow Amount",
                            fontSize: 13, color: timeColor),
                        SizedBox(height: 3),
                        CustomText("SAR 650",
                            fontSize: 15, fontWeight: FontVariant.semiBold),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText("Time Taken",
                            fontSize: 13, color: timeColor),
                        SizedBox(height: 3),
                        CustomText("3h 20m",
                            fontSize: 15, fontWeight: FontVariant.semiBold),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// GRID ROW 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText("Task Category",
                            fontSize: 13, color: timeColor),
                        SizedBox(height: 3),
                        CustomText("Offline Task",
                            fontSize: 15, fontWeight: FontVariant.semiBold),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText("Posted At",
                            fontSize: 13, color: timeColor),
                        SizedBox(height: 3),
                        CustomText("Today, 8:30 AM",
                            fontSize: 15, fontWeight: FontVariant.semiBold),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

    /// ▪ HOLD PAYMENT BUTTON (LEFT)
    Expanded(
    child: CustomContainer(
    height: 56,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: blackColor, width: 1),
    alignment: Alignment.center,
    child: const CustomText(
    "Hold Payment",
    fontSize: 14,
    fontWeight: FontVariant.semiBold,
    ),
    ),
    ),

    const SizedBox(width: 14),

    /// ▪ APPROVE PAYMENT BUTTON (RIGHT)
    Expanded(
    child: CustomButton(
    height: 56,
    label: "Approve Payment",
    fontSize: 14,
    fontWeight: FontVariant.semiBold,
    bgColor: redColor,
    onPressed: () {},
    ),
    ),

    ],
    ),
    const SizedBox(height: 5),
        ],
      ),
    );
  }
}
