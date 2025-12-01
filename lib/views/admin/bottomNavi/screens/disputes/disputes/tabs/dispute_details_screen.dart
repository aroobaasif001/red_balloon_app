import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customappbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/utils/colors.dart';

class DisputeDetailsScreen extends StatelessWidget {
  const DisputeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔴 TOP BAR
              CustomAppBar1(
                title: 'Dispute Details',
                showRightImage: false,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ////////////////////////////////////////////////////////
                    /// 🔴 1 — MAIN DISPUTE CARD (Help Move Furniture)
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border.all(color: bordercolor1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        )
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Icon
                              CustomContainer(
                                padding: const EdgeInsets.all(8),
                                borderRadius: BorderRadius.circular(12),
                                conColor: rdBgColor,
                                height: 40,
                                width: 32,
                                image: const DecorationImage(
                                  image: AssetImage("assets/icons/svg.png"),
                                  scale: 4
                                ),
                              ),


                              const SizedBox(width: 12),

                              /// Title + Subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      "Help Move Furniture",
                                      fontSize: 16,
                                      fontWeight: FontVariant.semiBold,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      "Helper is not responding",
                                      fontSize: 14,
                                      color: timeColor,
                                    ),
                                    const SizedBox(height: 14),
                                    CustomText(
                                      "Submitted 12 minutes ago",
                                      fontSize: 13,
                                      color: timeColor,
                                    ),
                                    const SizedBox(height: 6),
                                    CustomText(
                                      "User: RB-104 (Requester)",
                                      fontSize: 13,
                                      color: timeColor,
                                    ),
                                  ],
                                ),
                              ),

                              /// Open Badge
                              CustomContainer(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                  conColor: rdBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                child: CustomText(
                                  "Open",
                                  fontSize: 13,
                                  color: redColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ////////////////////////////////////////////////////////
                    /// 🔵 2 — REQUESTER INFORMATION CARD
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border.all(color: bordercolor1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Requester Information",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                              CustomContainer(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                  conColor: greenBg,
                                  borderRadius: BorderRadius.circular(20),
                                child: CustomText(
                                  "Verified",
                                  fontSize: 12,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(Icons.person, color: redColor, size: 20),
                              const SizedBox(width: 10),
                              CustomText("User Name:   Ahmed Al-Harbi",
                                  fontSize: 14),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Icon(Icons.location_on, color: redColor, size: 20),
                              const SizedBox(width: 10),
                              CustomText("City:   Riyadh", fontSize: 14),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Icon(Icons.tag, color: redColor, size: 20),
                              const SizedBox(width: 10),
                              CustomText("Request ID:   RB-445", fontSize: 14),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ////////////////////////////////////////////////////////
                    /// 🟣 3 — HELPER INFORMATION CARD
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border.all(color: bordercolor1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        )
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "Helper Information",
                                fontSize: 16,
                                fontWeight: FontVariant.semiBold,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: rdBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomText(
                                  "Verified Helper",
                                  fontSize: 12,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          CustomText("Anton Furnitures     RB-420",
                              fontSize: 15),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: redColor, size: 18),
                              const SizedBox(width: 4),
                              CustomText(
                                "4.9",
                                fontSize: 14,
                              ),
                              SizedBox(width:2,),
                              CustomText(
                                "(25 tasks completed)",
                                fontSize: 14,
                                color: timeColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "Validation Accuracy",
                                    fontSize: 14,
                                    color: timeColor,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    "96%",
                                    fontSize: 14,
                                    fontWeight: FontVariant.medium,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "Response Time",
                                    fontSize: 14,
                                    color: timeColor,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    "<5 min",
                                    fontSize: 14,
                                    fontWeight: FontVariant.medium,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ////////////////////////////////////////////////////////
                    /// 🟡 4 — REQUEST REPORTS CARD
                    ////////////////////////////////////////////////////////
                    CustomContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      conColor: whiteColor,
                      border: Border.all(color: bordercolor1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        )
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          CustomText(
                            "Requester’s Report",
                            fontSize: 16,
                            fontWeight: FontVariant.semiBold,
                          ),
                          SizedBox(height: 5,),
                          Divider(thickness: 0.5,),
                          SizedBox(height: 5,),
                          CustomText(
                            "No update received from the helper after task was marked ‘On the Way.’ Requester reported unusual delay.",
                            fontSize: 14,
                            color: timeColor,
                          ),
                          const SizedBox(height: 15),
                          Divider(thickness: 0.5,),
                          const SizedBox(height: 10),
                          CustomText(
                            "Helper’s Report",
                            fontSize: 15,
                            fontWeight: FontVariant.semiBold,
                          ),

                          const SizedBox(height: 10),
                          Divider(thickness: 0.5,),
                          const SizedBox(height: 10),

                          CustomText(
                            "Helper arrived near the requester’s location but was unable to establish contact. Multiple attempts were made to reach the requester, but no response was received.",
                            fontSize: 14,
                            color: timeColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    ////////////////////////////////////////////////////////
                    /// 🔴 BOTTOM ACTION BUTTONS
                    ////////////////////////////////////////////////////////

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Warn Helper",
                            fontSize: 15,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Warn Requester",
                            fontSize: 15,
                            onPressed: () {},
                            bgColor: whiteColor,
                            textColor: walletBlackColor,
                            border: Border.all(color: walletBlackColor),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Refund Payment",
                            fontSize: 15,
                            onPressed: () {},
                            bgColor: whiteColor,
                            textColor: blackColor,
                            border: Border.all(color: blackColor),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            height: 50,
                            label: "Dismiss Dispute",
                            fontSize: 15,
                            onPressed: () {},
                            bgColor: whiteColor,
                            textColor: blackColor,
                            border: Border.all(color: blackColor),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
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
