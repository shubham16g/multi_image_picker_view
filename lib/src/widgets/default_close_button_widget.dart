import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class DefaultCloseButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final BoxDecoration? boxDecoration;
  final Widget? icon;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  const DefaultCloseButtonWidget(
      {super.key,
      required this.onPressed,
      this.boxDecoration,
      this.icon,
      required this.margin,
      required this.padding,
      required this.alignment});

  @override
  State<DefaultCloseButtonWidget> createState() => _DefaultCloseButtonWidgetState();
}

class _DefaultCloseButtonWidgetState extends State<DefaultCloseButtonWidget> {


  @override
  Widget build(BuildContext context) {
    final isMouse = MultiImagePickerView.of(context).controller.isMouse;
    print("isMouse: $isMouse");
    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: widget.margin,
        child: InkWell(
          onTap: isMouse ? null : () {
            widget.onPressed();
          },
          onTapDown: isMouse ? (d) {
            widget.onPressed();
          }: null,
          child: Container(
              padding: widget.padding,
              decoration: widget.boxDecoration ??
                  BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
              child: widget.icon ?? const Icon(Icons.close, size: 18)),
        ),
      ),
    );
  }
}
