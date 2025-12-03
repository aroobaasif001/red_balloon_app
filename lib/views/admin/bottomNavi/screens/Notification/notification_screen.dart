import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class AdminNotificationScreen extends StatelessWidget {
  const AdminNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Notifications'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 41),
            CustomText("Today", fontSize: 20, fontWeight: FontVariant.bold),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: CustomContainer(
                    conColor: white2Color,

                    borderRadius: BorderRadius.circular(15),
                    border: Border(
                      bottom: BorderSide(color: bordercol, width: 1),
                      right: BorderSide(color: bordercol, width: 1),
                      left: BorderSide(color: bordercol, width: 1),
                    ),                     boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.25),
                        blurRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 17,
                      ),
                      child: Row(
                        children: [
                          CustomContainer(
                            height: 80,
                            width: 80,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage('assets/images/sofa.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Help Move Furniture",
                                  fontSize: 20,
                                  fontWeight: FontVariant.bold,
                                ),
                                SizedBox(height: 5),
                                CustomText(
                                  'Validation of this task has been done, Please Review!',
                                  color: redColor,
                                  fontSize: 16,
                                  fontWeight: FontVariant.bold,
                                ),
                                SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomText(
                                    '2h ago',
                                    fontSize: 12,
                                    fontWeight: FontVariant.regular,
                                    color: blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
