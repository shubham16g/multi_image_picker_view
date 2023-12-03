import 'package:flutter/material.dart';

import 'default_initial_widget.dart';

class MultiImagePickerInitialWidget {
  final int type;
  final Widget? widget;
  final Widget Function(BuildContext context, VoidCallback pickerCallback)?
  builder;

  const MultiImagePickerInitialWidget._(this.type, this.widget, this.builder);

  const MultiImagePickerInitialWidget.defaultWidget() : this._(0, null, null);

  const MultiImagePickerInitialWidget.centerWidget({required Widget child})
      : this._(1, child, null);

  const MultiImagePickerInitialWidget.customWidget(
      {required Widget Function(
          BuildContext context, VoidCallback pickerCallback)
      builder})
      : this._(2, null, builder);

  static MultiImagePickerInitialWidget get none =>
      const MultiImagePickerInitialWidget._(-1, null, null);

  Widget? getWidget(BuildContext context, EdgeInsetsGeometry? padding, VoidCallback pickImages) {
    switch (type) {
      case -1:
        return null;
      case 2:
        return builder!(context, pickImages);
      default:
        return DefaultInitialWidget(
            margin: padding,
            onPressed: pickImages,
            centerWidget: widget);
    }
  }
}


