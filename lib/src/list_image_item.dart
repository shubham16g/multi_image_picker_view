import 'package:flutter/material.dart';

import 'image_file.dart';
import 'image_file_view/image_file_view.dart';

class PreviewItem extends StatelessWidget {
  const PreviewItem(
      {super.key,
      required this.file,
      required this.fit,
      this.boxDecoration,
      // this.closeButtonBoxDecoration,
      // required this.onDelete,
      // this.closeButtonIcon,
      // required this.showCloseButton,
      // required this.closeButtonAlignment,
      // required this.closeButtonMargin,
      // required this.closeButtonPadding,
      required this.defaultImageBorderRadius, this.closeButtonWidget});

  final ImageFile file;
  final BoxFit fit;
  final BoxDecoration? boxDecoration;
  // final BoxDecoration? closeButtonBoxDecoration;
  // final EdgeInsetsGeometry closeButtonMargin;
  // final EdgeInsetsGeometry closeButtonPadding;
  // final Widget? closeButtonIcon;
  // final bool showCloseButton;
  final BorderRadius? defaultImageBorderRadius;
  // final Alignment closeButtonAlignment;
  // final Function(ImageFile path) onDelete;
  final Widget? closeButtonWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        Positioned.fill(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: boxDecoration ??
                BoxDecoration(
                  borderRadius: defaultImageBorderRadius,
                ),
            child: ImageFileView(
              fit: fit,
              file: file,
            ),
          ),
        ),
        if (closeButtonWidget != null)
          Positioned.fill(
            child: closeButtonWidget!,
          ),
      ],
    );
  }
}
