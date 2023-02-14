import 'package:flutter/material.dart';

import 'image_file.dart';
import 'image_file_view/image_file_view.dart';

class PreviewItem extends StatelessWidget {
  const PreviewItem({super.key,
    required this.file,
    required this.onDelete,
    required this.isMouse,
    required this.fit,
    this.boxDecoration, this.closeButtonBoxDecoration, this.closeButtonIcon, required this.showCloseButton, required this.closeButtonAlignment, required this.closeButtonMargin, required this.closeButtonPadding});

  final ImageFile file;
  final BoxFit fit;
  final bool isMouse;
  final BoxDecoration? boxDecoration;
  final BoxDecoration? closeButtonBoxDecoration;
  final EdgeInsetsGeometry closeButtonMargin;
  final EdgeInsetsGeometry closeButtonPadding;
  final Widget? closeButtonIcon;
  final bool showCloseButton;
  final Alignment closeButtonAlignment;
  final Function(ImageFile path) onDelete;

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
                  borderRadius: BorderRadius.circular(4),
                ),
            child: ImageFileView(
              fit: fit,
              file: file,
            ),
          ),
        ),
        if (showCloseButton) Positioned.fill(
          child: Align(
            alignment: closeButtonAlignment,
            child: InkWell(
              onTap: isMouse
                  ? null
                  : () {
                onDelete(file);
              },
              onTapDown: isMouse
                  ? (d) {
                onDelete(file);
              }
                  : null,
              child: Container(
                  margin: closeButtonMargin,
                  padding: closeButtonPadding,
                  decoration: closeButtonBoxDecoration ?? BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: closeButtonIcon ?? Image.asset(
                    'assets/close-48.png',
                    package: 'multi_image_picker_view',
                    height: 18,
                    width: 18,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
