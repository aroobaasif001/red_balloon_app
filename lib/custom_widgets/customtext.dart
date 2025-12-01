import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

/// Supported fonts
enum AppFont { instrumentSans, lora, poppins, manrope, montserrat, inter }

/// Font weight variants
enum FontVariant { light, regular, medium, semiBold, bold, normal }

/// A customizable text widget with Google Fonts support (no GetX).
class CustomText extends StatelessWidget {
  final String text;

  // 🧩 Font styling
  final AppFont fontType;
  final FontVariant fontWeight;
  final double? fontSize;
  final Color? color;
  final double? letterSpacing;
  final double? lineHeight;
  final FontStyle? fontStyle;
  final List<Shadow>? shadows;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final Color? backgroundColor;
  final TextStyle? style;

  // 🧱 Layout
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final EdgeInsets? padding;

  // 🌍 Extras
  final TextDirection? textDirection;
  final Locale? locale;
  final double? textScaleFactor;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final String? semanticsLabel;
  final double? height;

  // Optional semantic fields
  final String? title;
  final String? shortDescription;
  final String? detailedText;
  final alignment;
  final CrossAxisAlignment;

  const CustomText(
    this.text, {
    super.key,
    this.fontType = AppFont.instrumentSans,
    this.fontWeight = FontVariant.regular,
    this.fontSize,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.lineHeight,
    this.decoration,
    this.style,
    this.padding,
    this.softWrap = true,
    this.fontStyle,
    this.shadows,
    this.decorationColor,
    this.decorationThickness,
    this.decorationStyle,
    this.backgroundColor,
    this.textDirection,
    this.locale,
    this.textScaleFactor,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.semanticsLabel,
    this.title,
    this.shortDescription,
    this.detailedText,
    this.height,
        this.alignment,
        this.CrossAxisAlignment,
  });

  /// 🔹 Map FontVariant → FontWeight
  FontWeight get _mappedWeight {
    switch (fontWeight) {
      case FontVariant.light:
        return FontWeight.w300;
      case FontVariant.medium:
        return FontWeight.w500;
      case FontVariant.semiBold:
        return FontWeight.w600;
      case FontVariant.bold:
        return FontWeight.w700;
      case FontVariant.regular:
      case FontVariant.normal:
      default:
        return FontWeight.w400;
    }
  }

  /// 🔹 Map AppFont → Google Font
  TextStyle _mappedFont(AppFont fontType) {
    final weight = _mappedWeight;
    switch (fontType) {
      case AppFont.lora:
        return GoogleFonts.lora(fontWeight: weight);
      case AppFont.poppins:
        return GoogleFonts.poppins(fontWeight: weight);
      case AppFont.manrope:
        return GoogleFonts.manrope(fontWeight: weight);
      case AppFont.montserrat:
        return GoogleFonts.montserrat(fontWeight: weight);
      case AppFont.inter:
        return GoogleFonts.inter(fontWeight: weight);
      case AppFont.instrumentSans:
      default:
        return GoogleFonts.instrumentSans(fontWeight: weight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = DefaultTextStyle.of(context).style;
    final googleFont = _mappedFont(fontType);

    // 🔹 Use theme-aware text color fallback
    final effectiveColor = color ?? theme.textTheme.bodyMedium?.color ?? blackColor;

    // 🔹 Use theme or provided font size
    final effectiveFontSize = fontSize ?? theme.textTheme.bodyMedium?.fontSize ?? 14.0;

    // 🔹 Merge styles efficiently
    final mergedStyle = baseStyle
        .merge(
          googleFont.copyWith(
            fontSize: effectiveFontSize,
            color: effectiveColor,
            letterSpacing: letterSpacing,
            height: lineHeight,
            fontStyle: fontStyle,
            shadows: shadows,
            decoration: decoration,
            decorationColor: decorationColor,
            decorationThickness: decorationThickness,
            decorationStyle: decorationStyle,
            backgroundColor: backgroundColor,
          ),
        )
        .merge(style);

    final textWidget = Text(
      text,
      style: mergedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      textScaleFactor: textScaleFactor ?? MediaQuery.textScaleFactorOf(context),
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior:
          textHeightBehavior ??
          const TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
      semanticsLabel: semanticsLabel,
    );

    return (padding != null && padding != EdgeInsets.zero)
        ? Padding(padding: padding!, child: textWidget)
        : textWidget;
  }
}
