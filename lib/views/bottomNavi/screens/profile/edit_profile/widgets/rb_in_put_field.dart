import 'package:flutter/material.dart';

class RBInputField extends StatelessWidget {
  final String? hint;
  final int maxLines;
  final Widget? prefix;
  final TextEditingController? controller;
  final bool enabled;

  const RBInputField({
    super.key,
    this.hint,
    this.prefix,
    this.controller,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: maxLines == 1 ? 52 : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E5EA),
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                isCollapsed: true, // Better alignment
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
