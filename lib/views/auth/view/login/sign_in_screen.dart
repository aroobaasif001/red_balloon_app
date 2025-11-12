import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_consent_term.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/custom_textfield.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/auth/controller/auth_controller.dart';
import 'package:red_balloon_app/views/auth/view/forgot_pwd/forgot_pwd_screen.dart';
import 'package:red_balloon_app/views/auth/view/signup/sign_up_screen.dart';
import 'package:red_balloon_app/views/auth/widgets/social_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CustomContainer(
                      height: 250,
                      width: 250,
                      image: DecorationImage(image: AssetImage('assets/images/img.png'), fit: BoxFit.fill),
                    ),
                  ),
                  Center(
                    child: CustomText(
                      'Login',
                      fontSize: 28,
                      fontWeight: FontVariant.semiBold,
                      color: redColor,
                    ),
                  ),
                  SizedBox(height: 25),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: 'Email/Phone Number',
                          iconPath: 'assets/icons/email.png',
                          controller: authController.loginEmailController,
                          onChanged: (value) => authController.clearLoginErrors(),
                        ),
                        if (authController.loginEmailError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: CustomText(
                              authController.loginEmailError.value,
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          hintText: 'Password',
                          iconPath: 'assets/icons/pwd.png',
                          isPassword: true,
                          controller: authController.loginPasswordController,
                          onChanged: (value) => authController.clearLoginErrors(),
                        ),
                        if (authController.loginPasswordError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: CustomText(
                              authController.loginPasswordError.value,
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Get.to(() => ForgotPwdScreen()),
                      child: CustomText('Forgot Password?', fontSize: 10),
                    ),
                  ),
                  SizedBox(height: 25),
                  Obx(
                    () => CustomButton(
                      label: authController.isLoading.value ? 'Logging in...' : 'Login',
                      onPressed: authController.isLoading.value ? null : () {
                        // First validate fields
                        final bool fieldsValid = authController.validateLoginFields();
                        
                        // If fields are valid, then check consent
                        if (fieldsValid) {
                          if (!authController.loginConsentChecked.value) {
                            DialogHelpers.showConsentRequiredSnackBar();
                            return;
                          }
                          authController.login();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(child: Divider(thickness: 1, color: greyLiteColor)),
                      CustomText('OR', color: blueBlackColor),
                      Expanded(child: Divider(thickness: 1, color: greyLiteColor)),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(child: SocialButton.google(onPressed: () {})),
                  SizedBox(height: 8),
                  Center(child: SocialButton.apple(onPressed: () {})),
                  SizedBox(height: 31),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText("Don't have an account?", color: grey1Color, fontSize: 12),
                      IconButton(
                        onPressed: () => Get.to(() => SignUpScreen()),
                        icon: CustomText('Register', fontWeight: FontVariant.semiBold, color: redLightColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 17),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomConsentTerm(
                          appName: 'Red Balloon',
                          value: authController.loginConsentChecked.value,
                          checkSize: 16,
                          onChanged: (v) => authController.loginConsentChecked.value = v,
                          onTapTerms: () => print('open terms'),
                          onTapPrivacy: () => print('open privacy'),
                        ),
                        if (authController.loginConsentError.isNotEmpty) ...[
                          CustomText(authController.loginConsentError.value, fontSize: 12, color: Colors.red),
                          SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
