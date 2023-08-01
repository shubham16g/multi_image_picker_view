import 'package:flutter/material.dart';

import '../multi_image_picker_view.dart';

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
}

class MultiImagePickerAddMoreButton {
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
}

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
}

class MultiImagePickerImageWidget {
  final int type;
  final BoxDecoration? boxDecoration;
  final BoxDecoration? boxDecorationOnDrag;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Widget Function(BuildContext context, ImageFile imageFile)? builder;

  const MultiImagePickerImageWidget._(this.type, this.fit, this.boxDecoration,
      this.boxDecorationOnDrag, this.borderRadius, this.builder);

  const MultiImagePickerImageWidget.defaultImage(
      {BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
        BoxFit fit = BoxFit.cover})
      : this._(0, fit, null, null, null, null);

  const MultiImagePickerImageWidget.decoratedImage(
      {BoxDecoration? boxDecoration,
        BoxDecoration? boxDecorationOnDrag,
        BoxFit fit = BoxFit.cover})
      : this._(1, fit, boxDecoration, boxDecorationOnDrag, null, null);

  const MultiImagePickerImageWidget.customImage(
      {required Widget Function(BuildContext context, ImageFile imageFile)
      builder})
      : this._(2, null, null, null, null, builder);
}

