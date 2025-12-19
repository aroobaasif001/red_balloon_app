import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormattedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;

  const FormattedText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.instrumentSans(
      fontSize: fontSize ?? 14,
      color: color ?? Colors.black,
    );

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        style: baseStyle,
        children: _parseText(text, baseStyle),
      ),
    );
  }

  List<TextSpan> _parseText(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'(<b>.*?</b>|<i>.*?</i>|<u>.*?</u>|[^<>]+)', dotAll: true);
    final matches = regex.allMatches(text);

    for (final match in matches) {
      String part = match.group(0)!;
      if (part.startsWith('<b>')) {
        spans.add(TextSpan(
          text: part.replaceAll('<b>', '').replaceAll('</b>', ''),
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ));
      } else if (part.startsWith('<i>')) {
        spans.add(TextSpan(
          text: part.replaceAll('<i>', '').replaceAll('</i>', ''),
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
        ));
      } else if (part.startsWith('<u>')) {
        spans.add(TextSpan(
          text: part.replaceAll('<u>', '').replaceAll('</u>', ''),
          style: baseStyle.copyWith(decoration: TextDecoration.underline),
        ));
      } else {
        spans.add(TextSpan(text: part, style: baseStyle));
      }
    }

    if (spans.isEmpty && text.isNotEmpty) {
      spans.add(TextSpan(text: text, style: baseStyle));
    }

    return spans;
  }
}
