import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

import 'customtext.dart';

class CustomTextField extends StatefulWidget {
  final Widget? hintWidget;
  final TextEditingController? controller;
  final String? hintText;
  final String? iconPath;
  final bool isPassword;
  final Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  // 🔤 Keyboard
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final Brightness? keyboardAppearance;
  final border;
  // 🏷️ Label
  final String? label;
  final String? labelIcon;
  final bool isRequired;
  final EdgeInsetsGeometry labelMargin;
  final TextStyle? labelTextStyle;

  final int? maxLines;
  final int? maxLength;

  // ⭐ Optional Suffix / Prefix Widgets
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final borderColor;
  // ⭐ NEW: Optional Radius
  final double? radius;
  final prefixIcon;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.iconPath,
    this.isPassword = false,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.autocorrect,
    this.enableSuggestions,
    this.keyboardAppearance,
    this.labelIcon,
    this.label,
    this.isRequired = false,
    this.labelMargin = const EdgeInsets.only(left: 8, bottom: 10),
    this.labelTextStyle,
    this.maxLines,
    this.maxLength,
    this.hintWidget,
    this.suffixWidget,
    this.prefixWidget,

    /// ⭐ New optional radius
    this.radius,
    this.border,
    this.borderColor,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final bool showLabel =
        widget.label != null && widget.label!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- LABEL ----------
        if (showLabel)
          Padding(
            padding: widget.labelMargin,
            child: Row(
              children: [
                if (widget.labelIcon != null) ...[
                  Image(image: AssetImage(widget.labelIcon!), height: 20),
                  const SizedBox(width: 10),
                ],
                CustomText(
                  widget.label!,
                  fontWeight: FontVariant.semiBold,
                  fontSize: 20,
                  color: widget.labelTextStyle?.color ?? blackColor,
                  style: widget.labelTextStyle,
                ),
                if (widget.isRequired) ...[
                  const SizedBox(width: 4),
                  const CustomText("*", fontSize: 12, color: redColor),
                ],
              ],
            ),
          ),

        // ---------- FIELD ----------
        CustomContainer(
          conColor: white2Color,
          borderRadius: BorderRadius.circular(
            widget.radius ?? 15,
          ), // ⭐ Radius here
          boxShadow: [
            // BoxShadow(
            //   color: blackColor.withOpacity(0.25),
            //   offset: const Offset(0, 4),
            //   blurRadius: 4,
            // ),
          ],
          child: TextField(
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscure : false,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            maxLengthEnforcement: widget.maxLength != null
                ? MaxLengthEnforcement.enforced
                : MaxLengthEnforcement.none,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            autofillHints: widget.autofillHints,
            inputFormatters: widget.inputFormatters,
            autocorrect: widget.autocorrect ?? !widget.isPassword,
            enableSuggestions: widget.enableSuggestions ?? !widget.isPassword,
            keyboardAppearance: widget.keyboardAppearance,
            cursorColor: redColor,
            style: const TextStyle(
              color: blackColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),

            decoration: InputDecoration(
              hintText: widget.hintText,
              hint: widget.hintWidget,
              hintStyle: TextStyle(
                color: blackColor.withOpacity(0.50),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              border: InputBorder.none,
              counterText: '',

              prefixIcon: widget.prefixWidget != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1,
                        child: widget.prefixWidget!,
                      ),
                    )
                  : widget.iconPath != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10, right: 8),
                      child: CustomContainer(
                        width: 45,
                        height: 45,
                        conColor: redColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(widget.iconPath!),
                          scale: 4,
                        ),
                      ),
                    )
                  : null,

              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),

              suffixIcon: widget.suffixWidget != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Align(
                        alignment: Alignment.center,
                        widthFactor: 1,
                        child: widget.suffixWidget!,
                      ),
                    )
                  : widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: grey5Color,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,

              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
