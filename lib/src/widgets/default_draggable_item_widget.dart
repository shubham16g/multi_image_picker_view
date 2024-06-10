import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_controller_wrapper.dart';

class DefaultDraggableItemWidget extends StatelessWidget {
  const DefaultDraggableItemWidget({
    super.key,
    required this.imageFile,
    this.fit = BoxFit.cover,
    this.boxDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    this.showCloseButton = true,
    this.closeButtonAlignment = Alignment.topRight,
    this.closeButtonIcon,
    this.closeButtonBoxDecoration,
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
                child: DraggableItemInkWell(
                  onPressed: () => MultiImagePickerControllerWrapper.of(context)
                      .controller
                      .removeImage(imageFile),
                  child: Container(
                      padding: closeButtonPadding,
                      decoration: closeButtonBoxDecoration ??
                          BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                      child: closeButtonIcon ??
                          Icon(Icons.close,
                              size: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
