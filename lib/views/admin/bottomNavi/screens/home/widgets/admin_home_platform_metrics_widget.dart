import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class admin_home_platform_metrics_widget extends StatelessWidget {
  final String iconPath;
  final String value;
  final String title;
  const admin_home_platform_metrics_widget({
    super.key,
    this.iconPath = 'assets/icons/task.png',
    this.value = '24',
    this.title = 'Active Tasks',
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomContainer(

        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        // height: 136,
        width: double.infinity,
        conColor: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: blackColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.25),
            offset: Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 1,
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              borderRadius: BorderRadius.circular(8),
              conColor: redColor,
              height: 40,
              width: 40,
              child: Center(
                child: Image.asset(
                  iconPath,
                  height: 18,
                  width: 18,
                  color: whiteColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomText(
              value,
              fontWeight: FontVariant.bold,
              fontSize: 24,
              color: blackColor,
            ),
            SizedBox(height: 10),
            CustomText(
              title,
              fontWeight: FontVariant.regular,
              fontSize: 12,
              color: txColor,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
