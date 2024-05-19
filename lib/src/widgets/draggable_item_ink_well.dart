import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_controller_wrapper.dart';

class DraggableItemInkWell extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final BorderRadius? borderRadius;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? focusColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;

  const DraggableItemInkWell({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.hoverColor,
    this.highlightColor,
    this.focusColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
  });

  @override
  Widget build(BuildContext context) {
    final isMouse =
        MultiImagePickerControllerWrapper.of(context).controller.isMouse;
    return InkWell(
      borderRadius: borderRadius,
      splashFactory: splashFactory,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusColor: focusColor,
      highlightColor: highlightColor,
      overlayColor: overlayColor,
      onTap: isMouse
          ? null
          : () {
              onPressed();
            },
      onTapDown: isMouse
          ? (d) {
              onPressed();
            }
          : null,
      child: child,
    );
  }
}
