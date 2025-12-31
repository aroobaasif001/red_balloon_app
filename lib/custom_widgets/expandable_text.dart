import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final double fontSize;
  final Color color;
  final dynamic fontWeight; // Accepts FontVariant

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.fontSize = 14,
    this.color = Colors.black,
    this.fontWeight = FontVariant.regular,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Create a TextSpan with similar properties to CustomText defaults
        // Note: Assuming 'Outfit' or default font. If CustomText adds specific padding or style, it might vary.
        final span = TextSpan(
          text: widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.color,
            fontFamily: 'Outfit', // Common font in this project
          ),
        );

        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constraints.maxWidth);

        if (tp.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                widget.text,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                color: widget.color,
                maxLines: isExpanded ? null : widget.maxLines,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: CustomText(
                  isExpanded ? "Show Less" : "Show More",
                  fontSize: widget.fontSize,
                  fontWeight: FontVariant.bold,
                  color: redColor,
                ),
              )
            ],
          );
        } else {
          return CustomText(
            widget.text,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.color,
            maxLines: widget.maxLines, // Just in case
          );
        }
      },
    );
  }
}
