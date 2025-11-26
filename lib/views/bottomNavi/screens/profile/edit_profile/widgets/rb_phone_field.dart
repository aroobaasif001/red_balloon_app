import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';

class RBPhoneField extends StatelessWidget {
  final String countryCode;
  final TextEditingController? controller;

  const RBPhoneField({
    super.key,
    this.countryCode = "+094",
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E5EA),
          width: 1,
        ),
      ),

      child: Row(
        children: [

          // ---------------- LEFT SIDE WHITE CAPSULE ----------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: whiteColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // dropdown arrow
                Image.asset(
                  "assets/icons/dropdown9.png", // your PNG arrow
                  height: 16,
                  width: 16,
                ),

                const SizedBox(width: 6),

                // country code text
                CustomText(
                  countryCode,

                    fontSize: 10,
                    fontWeight: FontVariant.regular,
                    color: Colors.black,

                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ---------------- PHONE NUMBER TEXT FIELD ----------------
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
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
    );
  }
}
