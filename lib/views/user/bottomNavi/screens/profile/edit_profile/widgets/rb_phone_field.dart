import 'package:flutter/material.dart';

import '../../../../../../../custom_widgets/customtext.dart';
import '../../../../../../../utils/colors.dart';

class RBPhoneField extends StatelessWidget {
  final String? countryCode;
  final TextEditingController? controller;
  final String? errorText;
  final Function(String)? onChanged;
  final List<String>? countryCodes;
  final Function(String)? onCountryCodeChanged;

  const RBPhoneField({
    super.key,
    this.countryCode = "+1",
    this.controller,
    this.errorText,
    this.onChanged,
    this.countryCodes,
    this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: rbcolor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? Colors.red : bordercol,
              width: 1,
            ),
          ),

          child: Row(
            children: [
              // ---------------- LEFT SIDE WHITE CAPSULE WITH DROPDOWN ----------------
              PopupMenuButton<String>(
                onSelected: (value) {
                  onCountryCodeChanged?.call(value);
                },
                itemBuilder: (BuildContext context) {
                  return (countryCodes ?? ['+1', '+44', '+91', '+92', '+94', '+971'])
                      .map((code) => PopupMenuItem<String>(
                            value: code,
                            child: CustomText(
                              code,
                              fontSize: 12,
                              fontWeight: FontVariant.regular,
                              color: blackColor,
                            ),
                          ))
                      .toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: whiteColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      // dropdown arrow
                      Image.asset(
                        "assets/icons/dropdown9.png",
                        height: 16,
                        width: 16,
                      ),

                      const SizedBox(width: 6),

                      // country code text
                      CustomText(
                        countryCode ?? '+1',
                        fontSize: 12,
                        fontWeight: FontVariant.regular,
                        color: blackColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ---------------- PHONE NUMBER TEXT FIELD ----------------
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 15, color: blackLightColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: "+966 50 123 4567",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: blackLightColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Error message
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
