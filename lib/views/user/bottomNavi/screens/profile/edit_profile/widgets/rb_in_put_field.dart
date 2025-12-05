import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../../utils/colors.dart';

class RBInputField extends StatelessWidget {
  final String? hint;
  final int maxLines;
  final int? maxLength;
  final Widget? prefix;
  final TextEditingController? controller;
  final bool enabled;
  final TextInputType keyboardType;
  final String? errorText;
  final Function(String)? onChanged;

  const RBInputField({
    super.key,
    this.hint,
    this.prefix,
    this.controller,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: maxLines == 1 ? 52 : null,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: rbcolor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? Colors.red : bordercol,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment:
            maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              // ---------------- PREFIX ICON ----------------
              if (prefix != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: prefix!,
                ),
                const SizedBox(width: 10),
              ],

              // ---------------- TEXT FIELD ----------------
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  maxLengthEnforcement: maxLength != null
                      ? MaxLengthEnforcement.enforced
                      : MaxLengthEnforcement.none,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true, // Better alignment
                    border: InputBorder.none,
                    counterText: '', // Hide default counter
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: balanceconbgColor,
                      fontSize: 16,
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
