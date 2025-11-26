import 'package:flutter/material.dart';

/// ✅ Reusable overflow-safe container with gradient, shadow, and rounded corners
class CustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? conColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final DecorationImage? image;
  final BoxBorder? border;
  final BoxShape shape;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final backgroundColor;
  final color;


  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.conColor,
    this.borderRadius,
    this.child,
    this.image,
    this.border,
    this.shape = BoxShape.rectangle,
    this.alignment,
    this.boxShadow,
    this.gradient,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.color,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      alignment: alignment,
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: gradient,
        image: image,
        color: conColor,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        shape: shape,
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
