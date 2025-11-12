import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? iconPath; // optional
  final bool isPassword;
  final Function(String)? onChanged;

  // 🔤 Keyboard / input options
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final Brightness? keyboardAppearance;

  // 🏷️ Optional label
  final String? label; // 👈 NEW (null => no label)
  final bool isRequired; // 👈 NEW (adds asterisk)
  final EdgeInsetsGeometry labelMargin; // 👈 NEW
  final TextStyle? labelTextStyle; // 👈 NEW

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.iconPath,
    this.isPassword = false,
    this.onChanged,

    // keyboard defaults
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.autocorrect,
    this.enableSuggestions,
    this.keyboardAppearance,

    // label defaults
    this.label,
    this.isRequired = false,
    this.labelMargin = const EdgeInsets.only(left: 8, bottom: 10),
    this.labelTextStyle,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final bool effectiveAutocorrect = widget.autocorrect ?? !widget.isPassword;
    final bool effectiveSuggestions = widget.enableSuggestions ?? !widget.isPassword;

    final bool showLabel = (widget.label != null && widget.label!.trim().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: widget.labelMargin,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  widget.label!,
                  fontWeight: FontVariant.semiBold,
                  fontSize: 12,
                  color: widget.labelTextStyle?.color ?? greyColor,
                  style: widget.labelTextStyle, // allows full override
                ),
                if (widget.isRequired) ...[
                  const SizedBox(width: 4),
                  const CustomText('*', fontSize: 12, color: Colors.red),
                ],
              ],
            ),
          ),

        CustomContainer(
          height: 55,
          conColor: textColor,
          borderRadius: BorderRadius.circular(10),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscure : false,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            autocorrect: effectiveAutocorrect,
            enableSuggestions: effectiveSuggestions,
            keyboardAppearance: widget.keyboardAppearance,
            style: const TextStyle(color: blackColor, fontSize: 13, fontWeight: FontWeight.w500),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: greyColor, fontSize: 13),
              border: InputBorder.none,

              // 🔴 Left circular icon (only if iconPath provided)
              prefixIcon: (widget.iconPath != null)
                  ? CustomContainer(
                      margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
                      width: 45,
                      height: 45,
                      conColor: redColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage(widget.iconPath!), scale: 4),
                    )
                  : null,

              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

              // 👁 Password toggle
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
