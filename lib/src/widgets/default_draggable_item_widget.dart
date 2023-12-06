import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_controller_wrapper.dart';

import '../image_file.dart';
import '../image_file_view/image_file_view.dart';

class DefaultDraggableItemWidget extends StatelessWidget {
  const DefaultDraggableItemWidget({
    super.key,
    required this.imageFile,
    required this.fit,
    this.boxDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.showCloseButton = true,
    this.closeButtonAlignment = Alignment.topRight,
    this.closeButtonIcon,
    this.closeButtonBoxDecoration = const BoxDecoration(
      color: Color(0x55AAAAAA),
      shape: BoxShape.circle,
    ),
    this.closeButtonMargin = const EdgeInsets.all(4),
    this.closeButtonPadding = const EdgeInsets.all(3),
  });

  final ImageFile imageFile;
  final BoxFit fit;
  final BoxDecoration? boxDecoration;
  final bool showCloseButton;
  final Alignment closeButtonAlignment;
  final Widget? closeButtonIcon;
  final BoxDecoration? closeButtonBoxDecoration;
  final EdgeInsetsGeometry closeButtonMargin;
  final EdgeInsetsGeometry closeButtonPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: boxDecoration,
            child: ImageFileView(
              fit: fit,
              imageFile: imageFile,
            ),
          ),
        ),
        if (showCloseButton)
          Positioned.fill(
            child: Align(
              alignment: closeButtonAlignment,
              child: Padding(
                padding: closeButtonMargin,
                child: DraggableItemAction(
                  onPressed: () => MultiImagePickerControllerWrapper.of(context)
                      .controller
                      .removeImage(imageFile),
                  child: Container(
                      padding: closeButtonPadding,
                      decoration: closeButtonBoxDecoration,
                      child:
                          closeButtonIcon ?? const Icon(Icons.close, size: 18)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
