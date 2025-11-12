import 'package:flutter/material.dart';
import 'package:red_balloon_app/utils/colors.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback? onPressed;

  // Text
  final String label;
  final String? emphasize; // e.g. "Google" / "Apple"

  // Icon on the left (asset or Icon)
  final Widget? icon;
  final double leftSlotWidth;

  // Sizing & style
  final double height;
  final double? width; // optional fixed width
  final bool fullWidth; // 👈 NEW: control full width vs shrink
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? bgColor; // surface color
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.emphasize,
    this.icon,
    this.leftSlotWidth = 48,
    this.height = 56,
    this.width,
    this.fullWidth = false, // 👈 default: not full width
    this.radius = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
    this.bgColor,
    this.textColor = Colors.black87,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.isLoading = false,
  });

  /// Quick factories
  factory SocialButton.google({
    Key? key,
    required VoidCallback? onPressed,
    double height = 50,
    bool fullWidth = false,
    double? width,
  }) {
    return SocialButton(
      key: key,
      label: 'Continue with Google',
      emphasize: 'Google',
      onPressed: onPressed,
      height: height,
      fullWidth: fullWidth,
      width: width,
      bgColor: const Color(0xFFF5F6FA),
      textColor: blackColor,
      icon: Image.asset('assets/icons/Google.png', width: 30, height: 30),
    );
  }

  factory SocialButton.apple({
    Key? key,
    required VoidCallback? onPressed,
    double height = 50,
    bool fullWidth = false,
    double? width,
  }) {
    return SocialButton(
      key: key,
      label: 'Continue with Apple',
      emphasize: 'Apple',
      onPressed: onPressed,
      height: height,
      fullWidth: fullWidth,
      width: width,
      bgColor: Colors.black,
      textColor: Colors.white,
      icon: Image.asset('assets/icons/apple.png', width: 30, height: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;
    final Color effectiveText = enabled ? textColor : textColor.withOpacity(0.6);
    final Color surface = bgColor ?? const Color(0xFFF5F6FA);

    final button = MaterialButton(
      onPressed: enabled ? onPressed : null,
      color: surface,
      disabledColor: surface.withOpacity(0.6),
      elevation: 0,
      padding: EdgeInsets.zero, // inner padding handled below
      minWidth: 0, // 👈 don't force full width
      height: height,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Container(
        height: height,
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min, // 👈 shrink to content
          children: [
            SizedBox(
              width: leftSlotWidth,
              child: Center(child: icon),
            ),
            // Center label / loader
            SizedBox(
              // label area grows naturally; keep layout neat
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(effectiveText),
                      ),
                    )
                  : _buildCenteredLabel(effectiveText),
            ),
            // Right spacer to balance left icon width
            SizedBox(width: leftSlotWidth),
          ],
        ),
      ),
    );

    // Width control
    if (fullWidth) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(width: double.infinity, child: button),
      );
    }
    if (width != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(width: width, child: button),
      );
    }
    // Shrink to content by default
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: button);
  }

  Widget _buildCenteredLabel(Color color) {
    if (emphasize == null || emphasize!.isEmpty || !label.contains(emphasize!)) {
      return Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      );
    }

    final parts = label.split(emphasize!);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: parts.first,
            style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
          ),
          TextSpan(
            text: emphasize!,
            style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w700),
          ),
          if (parts.length > 1)
            TextSpan(
              text: parts.sublist(1).join(emphasize!),
              style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
            ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
