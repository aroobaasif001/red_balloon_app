import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

class WithdrawFunds extends StatelessWidget {
  const WithdrawFunds({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Withdraw Funds'),
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          child: Column(children: []),
        ),
      ),
    );
  }
}
