import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../widgets/custom_wallet_balance_card.dart';
import '../widgets/withdrawal_details_card.dart';
import '../widgets/past_withdrawal_requests.dart';

class WithdrawFunds extends StatefulWidget {
  const WithdrawFunds({super.key});

  @override
  State<WithdrawFunds> createState() => _WithdrawFundsState();
}

class _WithdrawFundsState extends State<WithdrawFunds> {
  late TextEditingController _amountController;
  late TextEditingController _paymentMethodController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _paymentMethodController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }

  void _handleWithdrawalRequest() {
    // Handle withdrawal request logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Withdrawal request submitted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Withdraw Funds'),
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  custom_withdraw_balance_card(),
                  SizedBox(height: 20),
                  WithdrawalDetailsCard(
                    amountController: _amountController,
                    paymentMethodController: _paymentMethodController,
                    onButtonPressed: _handleWithdrawalRequest,
                  ),
                  SizedBox(height: 20),
                  PastWithdrawalRequests(
                    withdrawalRequests: [
                      WithdrawalRequest(
                        date: 'Nov 3, 2025',
                        amount: 'SAR 150.00',
                        status: 'Completed',
                      ),
                      WithdrawalRequest(
                        date: 'Oct 31, 2025',
                        amount: 'SAR 100.00',
                        status: 'Pending',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
