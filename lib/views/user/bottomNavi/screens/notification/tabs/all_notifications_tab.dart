import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class AllNotificationsTab extends StatelessWidget {
  const AllNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 41),

          // Today title
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
                  boxShadow: [
                    BoxShadow(color: blackColor.withOpacity(0.15), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11, vertical: 17),
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
                              CustomText("Help Move Furniture", fontSize: 20, fontWeight: FontVariant.bold),
                              SizedBox(height: 5),
                              CustomText(
                                'Your task has been completed',
                                color: redColor,
                                fontSize: 16,
                                fontWeight: FontVariant.bold,
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
          SizedBox(height: 10),
          Center(child: CustomText("Wallet Transaction", fontSize: 18, fontWeight: FontVariant.bold)),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return CustomContainer(
                padding: EdgeInsets.all(18),
                conColor: white1Color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: blackColor.withOpacity(0.15), blurRadius: 5, offset: Offset(0, 2)),
                ],
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(color: white3Color, shape: BoxShape.circle),
                      child: Icon(Icons.expand_less, color: Colors.green),
                    ),
                    SizedBox(width: 12.43),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText("Funds Added Successfully", fontWeight: FontVariant.bold),
                          SizedBox(height: 1),
                          CustomText("Bank Transfer • 1 week ago", fontSize: 12, color: grey4Color),
                        ],
                      ),
                    ),
                    CustomText(
                      "+SAR 200.00",
                      fontSize: 15,
                      fontType: AppFont.poppins,
                      fontWeight: FontVariant.bold,
                      color: greenColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
