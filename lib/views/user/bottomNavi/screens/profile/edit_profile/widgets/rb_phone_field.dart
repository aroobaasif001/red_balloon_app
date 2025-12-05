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
                color: whiteColor, // Set dropdown background to white
                onSelected: (value) {
                  onCountryCodeChanged?.call(value);
                },
                itemBuilder: (BuildContext context) {
                  return (countryCodes ?? ['+1', '+44', '+91', '+92', '+94', '+971'])
                      .map((code) => PopupMenuItem<String>(
                            value: code,
                            child: Row(
                              children: [
                                Text(
                                  _getCountryFlag(code),
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(width: 8),
                                CustomText(
                                  code,
                                  fontSize: 12,
                                  fontWeight: FontVariant.regular,
                                  color: blackColor,
                                ),
                              ],
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
                      // Country flag
                      Text(
                        _getCountryFlag(countryCode ?? '+1'),
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(width: 6),

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

  // Helper function to get country flag emoji based on country code
  String _getCountryFlag(String countryCode) {
    switch (countryCode) {
      // Asia
      case '+91':
        return '🇮🇳'; // India
      case '+92':
        return '🇵🇰'; // Pakistan
      case '+94':
        return '🇱🇰'; // Sri Lanka
      case '+971':
        return '🇦🇪'; // UAE
      case '+966':
        return '🇸🇦'; // Saudi Arabia
      case '+86':
        return '🇨🇳'; // China
      case '+81':
        return '🇯🇵'; // Japan
      case '+880':
        return '🇧🇩'; // Bangladesh
      case '+977':
        return '🇳🇵'; // Nepal
      case '+93':
        return '🇦🇫'; // Afghanistan
      case '+975':
        return '🇧🇹'; // Bhutan
      case '+960':
        return '🇲🇻'; // Maldives
      case '+95':
        return '🇲🇲'; // Myanmar
      case '+66':
        return '🇹🇭'; // Thailand
      case '+84':
        return '🇻🇳'; // Vietnam
      case '+63':
        return '🇵🇭'; // Philippines
      case '+62':
        return '🇮🇩'; // Indonesia
      case '+60':
        return '🇲🇾'; // Malaysia
      case '+65':
        return '🇸🇬'; // Singapore
      case '+82':
        return '🇰🇷'; // South Korea
      case '+886':
        return '🇹🇼'; // Taiwan
      case '+852':
        return '🇭🇰'; // Hong Kong
      case '+98':
        return '🇮🇷'; // Iran
      case '+964':
        return '🇮🇶'; // Iraq
      case '+962':
        return '🇯🇴'; // Jordan
      case '+965':
        return '🇰🇼'; // Kuwait
      case '+961':
        return '🇱🇧'; // Lebanon
      case '+968':
        return '🇴🇲'; // Oman
      case '+974':
        return '🇶🇦'; // Qatar
      case '+973':
        return '🇧🇭'; // Bahrain
      case '+967':
        return '🇾🇪'; // Yemen
      case '+90':
        return '🇹🇷'; // Turkey
      case '+972':
        return '🇮🇱'; // Israel
      // North America
      case '+1':
        return '🇺🇸'; // USA/Canada
      // Europe
      case '+44':
        return '🇬🇧'; // UK
      case '+33':
        return '🇫🇷'; // France
      case '+49':
        return '🇩🇪'; // Germany
      case '+39':
        return '🇮🇹'; // Italy
      case '+34':
        return '🇪🇸'; // Spain
      // Oceania
      case '+61':
        return '🇦🇺'; // Australia
      case '+64':
        return '🇳🇿'; // New Zealand
      // Africa
      case '+27':
        return '🇿🇦'; // South Africa
      default:
        return '🌍'; // Default globe icon
    }
  }
}
