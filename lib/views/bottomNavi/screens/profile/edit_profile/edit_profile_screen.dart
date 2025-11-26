import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/profile/edit_profile/widgets/rb_in_put_field.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/profile/edit_profile/widgets/rb_phone_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: CustomAppBar(
        titleText: 'Edit Profile',
        titleFontSize: 20,
        titleFontWeight: FontVariant.bold,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [

                    // 🔴 BIG RED CIRCLE
                    CustomContainer(
                      width: 120,
                      height: 120,
                      conColor: redColor,
                      shape: BoxShape.circle,
                    ),

                    // 📸 SMALL CAMERA BUTTON (white border like screenshot)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: redColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: whiteColor,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/camera4.png',
                            height: 18,
                            width: 18,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const CustomText(
                  'Change Profile Picture',
                  fontSize: 14,
                  color: redColor,
                  fontWeight: FontVariant.bold,
                ),
              ],
            ),


            const SizedBox(height: 30),

            // Form Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color:bordercol),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME
                  const CustomText(
                    'Full Name',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  const SizedBox(height: 4),
                  const RBInputField(hint: 'Enter your name'),
                  const SizedBox(height: 15),

                  // USER ID
                  const CustomText(
                    'User-ID',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,

                  ),
                  const SizedBox(height: 4),
                  RBInputField(
                    hint: 'RB-102',
                    controller: TextEditingController(text: 'RB-102'),
                    enabled: false,
                  ),
                  const SizedBox(height: 15),

                  // CITY
                  const CustomText(
                    'City',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,

                  ),
                  const SizedBox(height: 4),
                  const RBInputField(hint: ''),
                  const SizedBox(height: 15),

                  // COUNTRY
                  const CustomText(
                    'Country',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,

                  ),
                  const SizedBox(height: 4),
                  RBInputField(
                    hint: '',
                    prefix: Image.asset(
                      'assets/icons/country.png',
                      height: 20,
                      width: 20,
                    ),

                  ),
                  const SizedBox(height: 15),

                  // PHONE
                  const CustomText(
                    'Phone Number',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,
                  ),
                  SizedBox(height: 4),

                  RBPhoneField(
                    countryCode: "+094",


                    controller: TextEditingController(),
                  ),


                  const SizedBox(height: 4),
                  const SizedBox(height: 15),

                  // WORK EXPERIENCE
                  const CustomText(
                    'Work Experience',
                    fontSize: 14,
                    color: blackLightColor,
                    fontWeight: FontVariant.regular,

                  ),
                  const SizedBox(height: 4),
                  const RBInputField(hint: '', maxLines: 5),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              label: 'Save Changes',
              onPressed: () {},
              bgColor: redColor,
              height: 52,
              borderRadius: BorderRadius.circular(16),
              textColor: whiteColor,
              fontSize: 15,
              fontWeight: FontVariant.bold,
            ),
            const SizedBox(height: 15),

            CustomButton(
              label: 'Cancel',
              onPressed: () {},
              bgColor:whiteColor,
              height: 52,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: bordercol),
              textColor: lastTextColor,
              fontSize: 14,
              fontWeight: FontVariant.bold,
            ),
          ],
        ),
      ),
    );
  }
}
