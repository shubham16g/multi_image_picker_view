import 'package:flutter/material.dart';

import 'default_add_more_widget.dart';

class MultiImagePickerAddMoreButton  {
  final int type;
  final Widget? widget;
  final Widget Function(BuildContext context, VoidCallback pickerCallback)?
      builder;

  const MultiImagePickerAddMoreButton._(this.type, this.widget, this.builder);

  const MultiImagePickerAddMoreButton.defaultButton() : this._(0, null, null);

  const MultiImagePickerAddMoreButton.customIcon({required Widget icon})
      : this._(1, icon, null);

  const MultiImagePickerAddMoreButton.customButton(
      {required Widget Function(
              BuildContext context, VoidCallback pickerCallback)
          builder})
      : this._(2, null, builder);

  static MultiImagePickerAddMoreButton get none =>
      const MultiImagePickerAddMoreButton._(-1, null, null);

  Widget? getWidget(BuildContext context, VoidCallback pickImages) {
    switch (type) {
      case -1:
        return null;
      case 2:
        return builder!(context, pickImages);
      default:
        return DefaultAddMoreWidget(
            onPressed: pickImages,
            icon: widget);
    }
  }
}
