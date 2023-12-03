import 'package:flutter/material.dart';

import 'default_close_button_widget.dart';

class MultiImagePickerCloseButton {
  final BoxDecoration? boxDecoration;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;

  final int type;
  final Widget? widget;
  final Widget Function(BuildContext context, VoidCallback closeCallback)?
      builder;

  const MultiImagePickerCloseButton._(this.type, this.widget, this.builder,
      this.alignment, this.margin, this.boxDecoration, this.padding);

  const MultiImagePickerCloseButton.defaultButton(
      {Alignment? alignment, EdgeInsetsGeometry? margin})
      : this._(0, null, null, alignment ?? Alignment.topRight,
            margin ?? const EdgeInsets.all(4), null, const EdgeInsets.all(3));

  const MultiImagePickerCloseButton.customIcon(
      {required Widget icon,
      Alignment? alignment,
      EdgeInsetsGeometry? margin,
      BoxDecoration? boxDecoration,
      EdgeInsetsGeometry? padding})
      : this._(
            1,
            icon,
            null,
            alignment ?? Alignment.topRight,
            margin ?? const EdgeInsets.all(4),
            boxDecoration,
            padding ?? const EdgeInsets.all(3));

  const MultiImagePickerCloseButton.customButton(
      {required Widget Function(
              BuildContext context, VoidCallback closeCallback)
          builder,
      Alignment? alignment,
      EdgeInsetsGeometry? margin})
      : this._(2, null, builder, alignment ?? Alignment.topRight,
            margin ?? const EdgeInsets.all(4), null, null);

  static MultiImagePickerCloseButton get none =>
      const MultiImagePickerCloseButton._(
          -1, null, null, Alignment.topRight, EdgeInsets.zero, null, null);

  Widget? getWidget(BuildContext context, bool isMouse, VoidCallback closeCallback) {
    switch (type) {
      case -1:
        return null;
      case 2:
        return builder!(context, closeCallback);
      default:
        return DefaultCloseButtonWidget(
          onPressed: closeCallback,
          boxDecoration: boxDecoration,
          icon: widget,
          isMouse: isMouse,
          margin: margin,
          padding: padding!,
          alignment: alignment,
        );
    }
  }
}
