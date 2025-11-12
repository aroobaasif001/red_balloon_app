import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';

class ForgotPwdScreen extends StatelessWidget {
  const ForgotPwdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: blackColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomText(
                  'Forgot Password?',
                  fontSize: 28,
                  fontWeight: FontVariant.semiBold,
                  color: redColor,
                ),
              ),
              SizedBox(height: 26),
              Center(
                child: CustomContainer(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomText(
                    'Enter your email address/phone number to reset your password',
                    fontSize: 16,
                    fontWeight: FontVariant.regular,
                    color: greyColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 34),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'Enter Your Email',
                      iconPath: 'assets/icons/email.png',
                      controller: authController.forgotPasswordEmailController,
                      onChanged: (value) => authController.clearForgotPasswordErrors(),
                    ),
                    if (authController.forgotPasswordEmailError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: CustomText(
                          authController.forgotPasswordEmailError.value,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 41),
              CustomButton(
                label: 'Reset Password', 
                onPressed: () => authController.forgotPassword()
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText("Remembered it?", color: grey1Color, fontSize: 18),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: CustomText(
                      'Sign In',
                      fontWeight: FontVariant.semiBold,
                      color: redLightColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 49),
            ],
          ),
        ),
      ),
    );
  }
}
