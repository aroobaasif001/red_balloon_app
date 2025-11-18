import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/views/bottomNavi/screens/wallet/controller/add_funds_controller.dart';

class PaymentMethodsList extends StatelessWidget {
  final AddFundsController controller;

  const PaymentMethodsList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Column(
          children: controller.paymentMethods.map((method) {
            final isSelected =
                controller.selectedPaymentMethod.value == method['id'];
            return GestureDetector(
              onTap: () {
                controller.selectPaymentMethod(method['id']);
              },
              child: CustomContainer(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                conColor: walletCardBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? walletPrimaryColor : fundCardBorderColor,
                  width: isSelected ? 2 : 1,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Center(
                        child: Image.asset(
                          method['icon'],
                          height: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            method['title'],
                            fontSize: 14,
                            fontWeight: FontVariant.bold,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            method['subtitle'],
                            color: walletTransactionDescColor,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: method['id'],
                      groupValue: controller.selectedPaymentMethod.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectPaymentMethod(value);
                        }
                      },
                      activeColor: walletPrimaryColor,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
