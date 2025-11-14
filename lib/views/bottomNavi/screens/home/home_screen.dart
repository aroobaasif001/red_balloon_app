import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText('RED BALLOON', fontSize: 16, fontWeight: FontVariant.bold, color: redColor),
            Icon(Icons.account_circle, color: redColor, size: 28),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bonus Card
              CustomContainer(
                width: double.infinity,
                height: 140,
                conColor: redColor,
                borderRadius: BorderRadius.circular(12),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Earn 10 SAR Bonus',
                      fontSize: 18,
                      fontWeight: FontVariant.bold,
                      color: Colors.white,
                    ),
                    CustomText('Complete your first task', fontSize: 12, color: Colors.white70),
                    LinearProgressIndicator(value: 0.5, backgroundColor: Colors.white24, minHeight: 4),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Balance Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText('YOUR BALANCE', fontSize: 11, color: grey2Color),
                      CustomText('SAR 250.00', fontSize: 20, fontWeight: FontVariant.bold, color: redColor),
                    ],
                  ),
                  CustomButton(label: '+ Add Funds', onPressed: () {}, width: 120, height: 40),
                ],
              ),
              SizedBox(height: 16),
              // Task Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(label: 'Offline Task', onPressed: () {}, bgColor: redColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      label: 'Online Task',
                      onPressed: () {},
                      bgColor: Colors.white,
                      textColor: redColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Requests Near You
              CustomText('Requests Near You', fontSize: 14, fontWeight: FontVariant.bold),
              SizedBox(height: 12),
              _taskCard('Help move furniture', 'SAR 500', 'View Details'),
              _taskCard('Help move furniture', 'SAR 500', 'View Details'),
              _taskCard('Help move furniture', 'SAR 500', 'View Details'),
              SizedBox(height: 24),
              // Quick Actions
              CustomText('Quick Actions', fontSize: 14, fontWeight: FontVariant.bold),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _quickAction(Icons.person, 'Profile'),
                  _quickAction(Icons.history, 'History'),
                  _quickAction(Icons.wallet, 'Wallet'),
                  _quickAction(Icons.settings, 'Settings'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskCard(String title, String price, String btnText) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: greyLiteColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(title, fontSize: 13, fontWeight: FontVariant.semiBold),
              CustomText(price, fontSize: 12, color: redColor, fontWeight: FontVariant.bold),
            ],
          ),
          CustomButton(label: btnText, onPressed: () {}, width: 90, height: 32, bgColor: redColor),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: redColor.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: redColor, size: 24),
        ),
        SizedBox(height: 8),
        CustomText(label, fontSize: 11, color: grey1Color),
      ],
    );
  }
}
