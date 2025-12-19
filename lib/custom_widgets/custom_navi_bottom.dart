import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/utils/colors.dart';

typedef _LetIndexPage = bool Function(int value);

class CurvedNavigationBar extends StatefulWidget {
  /// Defines the appearance of the [CurvedNavigationBarItem] list that are
  /// arrayed within the bottom navigation bar.
  final List<CurvedNavigationBarItem> items;

  /// The index into [items] for the current active [CurvedNavigationBarItem].
  final int index;

  /// The color of the [CurvedNavigationBar] itself, default Colors.white.
  final Color color;

  /// The background color of floating button, default same as [color] attribute.
  final Color? buttonBackgroundColor;

  /// The color of [CurvedNavigationBar]'s background, default Colors.blueAccent.
  final Color backgroundColor;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int>? onTap;

  /// Function which takes page index as argument and returns bool. If function
  /// returns false then page is not changed on button tap. It returns true by
  /// default.
  final _LetIndexPage letIndexChange;

  /// Curves interpolating button change animation, default Curves.easeOut.
  final Curve animationCurve;

  /// Duration of button change animation, default Duration(milliseconds: 600).
  final Duration animationDuration;

  /// Height of [CurvedNavigationBar].
  final double height;

  /// Max width of [CurvedNavigationBar].
  final double? maxWidth;

  /// Padding of icon in floating button.
  final double iconPadding;

  /// Check if [CurvedNavigationBar] has label.
  final bool hasLabel;

  CurvedNavigationBar({
    Key? key,
    required this.items,
    this.index = 0,
    this.color = whiteColor,
    this.buttonBackgroundColor,
    this.backgroundColor = blueAccentColor,
    this.onTap,
    _LetIndexPage? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.iconPadding = 12.0,
    this.maxWidth,
    double? height,
  }) : letIndexChange = letIndexChange ?? ((_) => true),
       assert(items.isNotEmpty),
       assert(0 <= index && index < items.length),
       assert(maxWidth == null || 0 <= maxWidth),
       height = height ?? (Platform.isAndroid ? 70.0 : 80.0),
       hasLabel = items.any((item) => item.label != null),
       super(key: key);

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late double _startingPos;
  late int _endingIndex;
  late double _pos;
  late Widget _icon;
  late AnimationController _animationController;
  late int _length;
  double _buttonHide = 0;

  @override
  void initState() {
    super.initState();
    _icon = widget.items[widget.index].child;
    _length = widget.items.length;
    _pos = widget.index / _length;
    _startingPos = widget.index / _length;
    _endingIndex = widget.index;
    _animationController = AnimationController(vsync: this, value: _pos);
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos = _endingIndex / widget.items.length;
        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
          _icon = widget.items[_endingIndex].child;
        }
        _buttonHide = (1 - ((middle - _pos) / (_startingPos - middle)).abs())
            .abs();
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(
        newPosition,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    }
    if (!_animationController.isAnimating) {
      _icon = widget.items[_endingIndex].child;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = min(
            constraints.maxWidth,
            widget.maxWidth ?? constraints.maxWidth,
          );
          return Align(
            alignment: textDirection == TextDirection.ltr
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            child: CustomContainer(
              width: maxWidth,
              conColor: widget.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  // FLOATING BUTTON
                  Positioned(
                    bottom: widget.height - 105.0,
                    left: textDirection == TextDirection.rtl
                        ? null
                        : _pos * maxWidth,
                    right: textDirection == TextDirection.rtl
                        ? _pos * maxWidth
                        : null,
                    width: maxWidth / _length,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, (_buttonHide - 1) * 80),
                        child: Material(
                          color: widget.buttonBackgroundColor ?? widget.color,
                          type: MaterialType.circle,
                          child: Padding(
                            padding: EdgeInsets.all(widget.iconPadding),
                            child: _icon,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // CURVE BACKGROUND
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CustomPaint(
                        painter: NavCustomPainter(
                          startingLoc: _pos,
                          itemsLength: _length,
                          color: widget.color,
                          textDirection: textDirection,
                          hasLabel: widget.hasLabel,
                        ),
                        child: Container(height: widget.height),
                      ),
                    ),
                  ),

                  // BUTTONS ROW
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: widget.height,
                      child: Row(
                        children: widget.items.map((item) {
                          return NavBarItemWidget(
                            onTap: _buttonTap,
                            position: _pos,
                            length: _length,
                            index: widget.items.indexOf(item),
                            child: Center(child: item.child),
                            label: item.label,
                            labelStyle: item.labelStyle,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (!widget.letIndexChange(index) || _animationController.isAnimating) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
    final newPosition = index / _length;
    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(
        newPosition,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    });
  }
}

const s = 0.2;

class NavCustomPainter extends CustomPainter {
  late double loc;
  late double bottom;
  Color color;
  bool hasLabel;
  TextDirection textDirection;

  NavCustomPainter({
    required double startingLoc,
    required int itemsLength,
    required this.color,
    required this.textDirection,
    this.hasLabel = false,
  }) {
    final span = 1.0 / itemsLength;
    final l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    bottom = hasLabel
        ? (Platform.isAndroid ? 0.55 : 0.45)
        : (Platform.isAndroid ? 0.6 : 0.5);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * (loc - 0.05), 0)
      ..cubicTo(
        size.width * (loc + s * 0.2), // topX
        size.height * 0.05, // topY
        size.width * loc, // bottomX
        size.height * bottom, // bottomY
        size.width * (loc + s * 0.5), // centerX
        size.height * bottom, // centerY
      )
      ..cubicTo(
        size.width * (loc + s), // bottomX
        size.height * bottom, // bottomY
        size.width * (loc + s * 0.8), // topX
        size.height * 0.05, // topY
        size.width * (loc + s + 0.05),
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}

class CurvedNavigationBarItem {
  /// Icon of [CurvedNavigationBarItem].
  final Widget child;

  /// Text of [CurvedNavigationBarItem].
  final String? label;

  /// TextStyle for [label].
  final TextStyle? labelStyle;

  const CurvedNavigationBarItem({
    required this.child,
    this.label,
    this.labelStyle,
  });
}

class NavBarItemWidget extends StatelessWidget {
  final double position;
  final int length;
  final int index;
  final ValueChanged<int> onTap;
  final Widget child;
  final String? label;
  final TextStyle? labelStyle;

  NavBarItemWidget({
    required this.onTap,
    required this.position,
    required this.length,
    required this.index,
    required this.child,
    this.label,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap(index),
        child: _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    if (label == null) {
      return Column(
        children: [
          Expanded(child: _buildIcon()),
          SizedBox(height: Platform.isIOS ? 20.0 : 0),
        ],
      );
    }
    return Column(
      children: [
        Expanded(flex: 2, child: _buildIcon()),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 4),
            child: Text(label ?? '', style: labelStyle),
          ),
        ),
        SizedBox(height: Platform.isIOS ? 20.0 : 10.0),
      ],
    );
  }

  Widget _buildIcon() {
    final desiredPosition = 1.0 / length * index;
    final difference = (position - desiredPosition).abs();
    final verticalAlignment = 1 - length * difference;
    final opacity = length * difference;
    return Transform.translate(
      offset: Offset(0, difference < 1.0 / length ? verticalAlignment * 40 : 0),
      child: Opacity(
        opacity: difference < 1.0 / length * 0.99 ? opacity : 1.0,
        child: child,
      ),
    );
  }
}
