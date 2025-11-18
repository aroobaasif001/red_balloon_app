import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class PostNewTaskScreen extends StatelessWidget {
  const PostNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        title: CustomText('Post New Task', fontSize: 24, fontWeight: FontVariant.bold),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(image: AssetImage('assets/icons/category-solid.png'), height: 20),
                    SizedBox(width: 10),
                    CustomText(
                      'Task Type',
                      fontWeight: FontVariant.semiBold,
                      fontSize: 20,
                      color: blackColor,
                    ),
                  ],
                ),
              ),
              CustomTextField(
                labelIcon: 'assets/icons/pen-line.png',
                label: 'Task Title',
                hintText: 'What do you need help with?',
              ),
              SizedBox(height: 17),
              CustomTextField(
                maxLines: 5,
                labelIcon: 'assets/icons/pen-line.png',
                label: 'Description',
                hintText: 'Provide more details about your task...',
              ),
              SizedBox(height: 34),
              CustomTextField(
                labelIcon: 'assets/icons/pen-line.png',
                label: 'Task Budget',
                hintWidget: Row(
                  children: [
                    CustomText('SAR', fontSize: 16, fontWeight: FontVariant.medium),
                    SizedBox(width: 4),
                    CustomText(
                      '15',
                      color: blackColor.withOpacity(0.50),
                      fontSize: 16,
                      fontWeight: FontVariant.light,
                    ),
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
