import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  maxLength: _getMaxPhoneLength(countryCode ?? '+1'),
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 15, color: blackLightColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    counterText: '', // Hide default counter
                    hintText: _getPhoneHint(countryCode ?? '+1'),
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

  // Helper function to get max phone length based on country code
  int _getMaxPhoneLength(String countryCode) {
    switch (countryCode) {
      case '+91': return 10; // India
      case '+92': return 10; // Pakistan
      case '+94': return 9;  // Sri Lanka
      case '+971': return 9; // UAE
      case '+966': return 9; // Saudi Arabia
      case '+86': return 11; // China
      case '+81': return 10; // Japan
      case '+880': return 10; // Bangladesh
      case '+977': return 10; // Nepal
      case '+93': return 9;  // Afghanistan
      case '+975': return 8;  // Bhutan
      case '+960': return 7;  // Maldives
      case '+95': return 9;   // Myanmar
      case '+66': return 9;   // Thailand
      case '+84': return 10;  // Vietnam
      case '+63': return 10;  // Philippines
      case '+62': return 11;  // Indonesia
      case '+60': return 10;  // Malaysia
      case '+65': return 8;   // Singapore
      case '+82': return 10;  // South Korea
      case '+886': return 9;  // Taiwan
      case '+852': return 8;  // Hong Kong
      case '+98': return 10;  // Iran
      case '+964': return 10; // Iraq
      case '+962': return 9;  // Jordan
      case '+965': return 8;  // Kuwait
      case '+961': return 8;  // Lebanon
      case '+968': return 8;  // Oman
      case '+974': return 8;  // Qatar
      case '+973': return 8;  // Bahrain
      case '+967': return 9;  // Yemen
      case '+90': return 10;  // Turkey
      case '+1': return 10;   // USA/Canada
      case '+44': return 10;  // UK
      case '+33': return 9;   // France
      case '+49': return 11;  // Germany
      case '+39': return 10;  // Italy
      case '+34': return 9;   // Spain
      case '+61': return 9;   // Australia
      case '+64': return 9;   // New Zealand
      case '+27': return 9;   // South Africa
      default: return 15;     // Default
    }
  }

  // Helper function to get phone hint based on country code
  String _getPhoneHint(String countryCode) {
    switch (countryCode) {
      // Asia
      case '+91':
        return '98765 43210'; // India (10 digits)
      case '+92':
        return '300 1234567'; // Pakistan (10 digits)
      case '+94':
        return '77 123 4567'; // Sri Lanka (9 digits)
      case '+971':
        return '50 123 4567'; // UAE (9 digits)
      case '+966':
        return '50 123 4567'; // Saudi Arabia (9 digits)
      case '+86':
        return '138 0013 8000'; // China (11 digits)
      case '+81':
        return '90 1234 5678'; // Japan (10 digits)
      case '+880':
        return '1812 345678'; // Bangladesh (10 digits)
      case '+977':
        return '98 1234 5678'; // Nepal (10 digits)
      case '+93':
        return '70 123 4567'; // Afghanistan (9 digits)
      case '+975':
        return '17 12 34 56'; // Bhutan (8 digits)
      case '+960':
        return '771 2345'; // Maldives (7 digits)
      case '+95':
        return '9 123 456 789'; // Myanmar (9-10 digits)
      case '+66':
        return '81 234 5678'; // Thailand (9 digits)
      case '+84':
        return '91 234 5678'; // Vietnam (9 digits)
      case '+63':
        return '917 123 4567'; // Philippines (10 digits)
      case '+62':
        return '812 3456 7890'; // Indonesia (10-11 digits)
      case '+60':
        return '12 345 6789'; // Malaysia (9-10 digits)
      case '+65':
        return '8123 4567'; // Singapore (8 digits)
      case '+82':
        return '10 1234 5678'; // South Korea (10 digits)
      case '+886':
        return '912 345 678'; // Taiwan (9 digits)
      case '+852':
        return '5123 4567'; // Hong Kong (8 digits)
      case '+98':
        return '912 345 6789'; // Iran (10 digits)
      case '+964':
        return '790 123 4567'; // Iraq (10 digits)
      case '+962':
        return '79 123 4567'; // Jordan (9 digits)
      case '+965':
        return '5123 4567'; // Kuwait (8 digits)
      case '+961':
        return '71 123 456'; // Lebanon (8 digits)
      case '+968':
        return '9123 4567'; // Oman (8 digits)
      case '+974':
        return '3312 3456'; // Qatar (8 digits)
      case '+973':
        return '3612 3456'; // Bahrain (8 digits)
      case '+967':
        return '712 345 678'; // Yemen (9 digits)
      case '+90':
        return '531 234 5678'; // Turkey (10 digits)
      // North America
      case '+1':
        return '(555) 123-4567'; // USA/Canada (10 digits)
      // Europe
      case '+44':
        return '7400 123456'; // UK (10 digits)
      case '+33':
        return '6 12 34 56 78'; // France (9 digits)
      case '+49':
        return '151 2345678'; // Germany (10-11 digits)
      case '+39':
        return '312 345 6789'; // Italy (10 digits)
      case '+34':
        return '612 34 56 78'; // Spain (9 digits)
      // Oceania
      case '+61':
        return '412 345 678'; // Australia (9 digits)
      case '+64':
        return '21 123 4567'; // New Zealand (9 digits)
      // Africa
      case '+27':
        return '71 123 4567'; // South Africa (9 digits)
      default:
        return '123 456 7890'; // Default
    }
  }
}
