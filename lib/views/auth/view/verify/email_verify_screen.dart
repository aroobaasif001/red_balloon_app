import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/auth/view/login/sign_in_screen.dart';

class EmailVerifyScreen extends StatelessWidget {
  final bool isShowBackBtn;
  final TextEditingController? emailController;
  const EmailVerifyScreen({super.key, this.isShowBackBtn = false, this.emailController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: CustomContainer(
                    height: 264,
                    width: 264,
                    image: DecorationImage(image: AssetImage('assets/images/img1.png'), fit: BoxFit.fill),
                  ),
                ),
                Center(
                  child: CustomText(
                    'Verify Your Email',
                    fontSize: 28,
                    fontWeight: FontVariant.semiBold,
                    color: redColor,
                  ),
                ),
                SizedBox(height: 11),
                CustomText(
                  "We've sent a verification link to your email address. Please check your inbox and click the link to continue.",
                  fontSize: 16,
                  fontWeight: FontVariant.regular,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                CustomContainer(
                  width: double.maxFinite,
                  conColor: textColor,
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 17),
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      CustomText(
                        "Email sent to:",
                        fontSize: 20,
                        fontWeight: FontVariant.semiBold,
                        color: redColor,
                        textAlign: TextAlign.center,
                      ),
                      CustomText(
                        emailController?.text ?? "example@email.com",
                        fontSize: 20,
                        fontWeight: FontVariant.semiBold,
                        color: redColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                CustomContainer(
                  width: double.maxFinite,
                  conColor: textColor,
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 17),
                  borderRadius: BorderRadius.circular(10),
                  child: CustomText(
                    "Didn't get the email? Check your spam folder or request a new link.                          ",
                    fontSize: 16,
                    fontWeight: FontVariant.regular,
                    color: grey50Color,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 22),
                CustomButton(
                  leading: Image(image: AssetImage('assets/icons/resend.png'), height: 16, width: 16),
                  label: 'Resend Verification Email',
                  onPressed: () {},
                ),
                if (isShowBackBtn) ...[
                  Spacer(),
                  CustomButton(label: 'Back to login', onPressed: () => Get.offAll(() => SignInScreen())),
                  SizedBox(height: 38),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
