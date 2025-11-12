import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ⬅️ add this
import 'package:red_balloon_app/utils/colors.dart';

class CustomConsentTerm extends StatefulWidget {
  final String appName;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTapTerms;
  final VoidCallback? onTapPrivacy;

  // styling
  final Color? accentColor;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final EdgeInsets padding;

  // checkbox sizing
  final double checkSize;
  final double borderWidth;

  const CustomConsentTerm({
    super.key,
    required this.appName,
    this.value = false,
    this.onChanged,
    this.onTapTerms,
    this.onTapPrivacy,
    this.accentColor,
    this.textStyle,
    this.linkStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    this.checkSize = 16,
    this.borderWidth = 2,
  });

  @override
  State<CustomConsentTerm> createState() => _CustomConsentTermState();
}

class _CustomConsentTermState extends State<CustomConsentTerm> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomConsentTerm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _checked = widget.value;
    }
  }

  void _toggle() {
    setState(() => _checked = !_checked);
    widget.onChanged?.call(_checked);
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.accentColor ?? purpleColor;

    // ✅ Poppins, medium (w500), size 12
    final TextStyle baseStyle = widget.textStyle ?? GoogleFonts.poppins(fontSize: 12, color: greyColor);

    final TextStyle linkStyle =
        widget.linkStyle ?? GoogleFonts.poppins(fontSize: 12, decoration: TextDecoration.underline);

    return Padding(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ◯ circular checkbox
          InkWell(
            onTap: _toggle,
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              width: widget.checkSize,
              height: widget.checkSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _checked ? accent : Colors.transparent,
                border: Border.all(color: accent, width: widget.borderWidth),
              ),
              child: _checked
                  ? Icon(Icons.check_rounded, size: widget.checkSize * 0.65, color: whiteColor)
                  : null,
            ),
          ),
          const SizedBox(width: 10),

          // 📝 rich text with links
          Flexible(
            child: RichText(
              textAlign: TextAlign.center, // ⬅️ yahi chahiye
              text: TextSpan(
                style: baseStyle,
                children: [
                  const TextSpan(text: 'By using '),
                  TextSpan(text: widget.appName, style: baseStyle),
                  const TextSpan(text: ', you agree to the '),
                  TextSpan(
                    text: 'Terms Of Services',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = widget.onTapTerms,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = widget.onTapPrivacy,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
