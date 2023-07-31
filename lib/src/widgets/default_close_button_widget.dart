import 'package:flutter/material.dart';

class DefaultCloseButtonWidget extends StatelessWidget {
  final bool isMouse;
  final VoidCallback onPressed;
  final BoxDecoration? boxDecoration;
  final Widget? icon;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  const DefaultCloseButtonWidget(
      {super.key,
      required this.isMouse,
      required this.onPressed,
      this.boxDecoration,
      this.icon,
      required this.margin,
      required this.padding,
      required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: margin,
        child: InkWell(
          onTap: isMouse ? null : onPressed,
          onTapDown: isMouse
              ? (d) {
                  onPressed();
                }
              : null,
          child: Container(
              padding: padding,
              decoration: boxDecoration ??
                  BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
              child: icon ?? const Icon(Icons.close, size: 18)),
        ),
      ),
    );
  }
}
