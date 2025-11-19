import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class OfferNotificationsTab extends StatelessWidget {
  const OfferNotificationsTab({super.key});

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
                    padding: EdgeInsets.symmetric(horizontal: 11, vertical: 16),
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
                              SizedBox(height: 5),
                              Align(alignment: Alignment.bottomRight, child: CustomText('2m ago')),
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
          SizedBox(height: 29),
          // Today title
          CustomText("Yesterday", fontSize: 20, fontWeight: FontVariant.bold),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
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
                    padding: EdgeInsets.symmetric(horizontal: 11, vertical: 16),
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
                              SizedBox(height: 5),
                              Align(alignment: Alignment.bottomRight, child: CustomText('2m ago')),
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
    );
  }
}
