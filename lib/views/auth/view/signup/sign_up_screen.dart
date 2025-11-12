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
import 'package:red_balloon_app/views/auth/view/verify/email_verify_screen.dart';
import 'package:red_balloon_app/views/auth/widgets/social_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

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
                      height: 208,
                      width: 208,
                      image: DecorationImage(image: AssetImage('assets/images/img.png'), fit: BoxFit.fill),
                    ),
                  ),
                  Center(
                    child: CustomText(
                      'Register',
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
                          hintText: 'Full Name',
                          iconPath: 'assets/icons/name.png',
                          controller: authController.signupNameController,
                          onChanged: (value) => authController.clearSignupErrors(),
                        ),
                        if (authController.signupNameError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: CustomText(
                              authController.signupNameError.value,
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
                          hintText: 'Email Address',
                          iconPath: 'assets/icons/email.png',
                          controller: authController.signupEmailController,
                          onChanged: (value) => authController.clearSignupErrors(),
                        ),
                        if (authController.signupEmailError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: CustomText(
                              authController.signupEmailError.value,
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
                          hintText: 'Phone Number',
                          iconPath: 'assets/icons/phone.png',
                          keyboardType: TextInputType.phone,
                          controller: authController.signupPhoneController,
                          onChanged: (value) => authController.clearSignupErrors(),
                        ),
                        if (authController.signupPhoneError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: CustomText(
                              authController.signupPhoneError.value,
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
                          controller: authController.signupPasswordController,
                          onChanged: (value) => authController.clearSignupErrors(),
                        ),
                        if (authController.signupPasswordError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: CustomText(
                              authController.signupPasswordError.value,
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
                          hintText: 'Re-enter Password',
                          iconPath: 'assets/icons/pwd.png',
                          isPassword: true,
                          controller: authController.signupConfirmPasswordController,
                          onChanged: (value) => authController.clearSignupErrors(),
                        ),
                        if (authController.signupConfirmPasswordError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: CustomText(
                              authController.signupConfirmPasswordError.value,
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Obx(
                    () => CustomButton(
                      label: authController.isLoading.value ? 'Creating account...' : 'Sign up',
                      onPressed: authController.isLoading.value
                          ? null
                          : () async {
                              // First validate fields
                              final bool fieldsValid = authController.validateSignupFields();
                              
                              // If fields are valid, then check consent
                              if (fieldsValid) {
                                if (!authController.signupConsentChecked.value) {
                                  DialogHelpers.showConsentRequiredSnackBar();
                                  return;
                                }
                                
                                await authController.signup();
                                if (authController.signupNameError.isEmpty &&
                                    authController.signupEmailError.isEmpty &&
                                    authController.signupPhoneError.isEmpty &&
                                    authController.signupPasswordError.isEmpty &&
                                    authController.signupConfirmPasswordError.isEmpty) {
                                  Get.to(() => EmailVerifyScreen());
                                }
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
                      CustomText('Already have an account?', color: grey1Color, fontSize: 12),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: CustomText('Login', fontWeight: FontVariant.semiBold, color: redLightColor),
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
                          value: authController.signupConsentChecked.value,
                          checkSize: 16,
                          onChanged: (v) => authController.signupConsentChecked.value = v,
                          onTapTerms: () => print('open terms'),
                          onTapPrivacy: () => print('open privacy'),
                        ),
                        if (authController.signupConsentError.isNotEmpty) ...[  
                          CustomText(authController.signupConsentError.value, fontSize: 12, color: Colors.red),
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
