
import 'package:flutter/material.dart';

import '../image_file.dart';
import '../list_image_item.dart';

class MultiImagePickerImageWidget {
  final int type;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final BoxDecoration? boxDecoration;
  final BoxDecoration? boxDecorationOnDrag;
  final Widget Function(BuildContext context, ImageFile imageFile)? builder;

  const MultiImagePickerImageWidget._(this.type, this.fit, this.boxDecoration,
      this.boxDecorationOnDrag, this.borderRadius, this.builder);

  /// default image
  const MultiImagePickerImageWidget.defaultImage(
      {BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
        BoxFit fit = BoxFit.cover})
      : this._(0, fit, null, null, null, null);

  /// decorated image
  const MultiImagePickerImageWidget.decoratedImage(
      {BoxDecoration? boxDecoration,
        BoxDecoration? boxDecorationOnDrag,
        BoxFit fit = BoxFit.cover})
      : this._(1, fit, boxDecoration, boxDecorationOnDrag, null, null);

  /// custom image
  const MultiImagePickerImageWidget.customImage(
      {required Widget Function(BuildContext context, ImageFile imageFile)
      builder})
      : this._(2, null, null, null, null, builder);

  Widget getWidget(BuildContext context, ImageFile imageFile) {
    switch (type) {
      case 2:
        return builder!(context, imageFile);
      default:
        return PreviewItem(
          file: imageFile,
          fit: fit!,
          boxDecoration: boxDecoration,
          defaultImageBorderRadius: borderRadius,
        );
    }
  }
}