import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_controller_wrapper.dart';

typedef DescriptionFieldCallback = Function(ImageFile, String);

class DefaultDraggableItemWidget extends StatelessWidget {
  DefaultDraggableItemWidget({
    super.key,
    required this.imageFile,
    this.fit = BoxFit.cover,
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
    this.showDescriptionField = false,
    this.descriptionFieldText = "",
    this.descriptionFieldReadOnly = false,
    this.descriptionFieldHint = "Description",
    this.descriptionFieldPadding =
        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.descriptionFieldCallback,
  }) {
    descriptionController
      ..text = descriptionFieldText
      ..addListener(() => descriptionFieldCallback?.call(
          imageFile, descriptionController.text));
  }

  final ImageFile imageFile;
  final BoxFit fit;
  final BoxDecoration? boxDecoration;
  final bool showCloseButton;
  final Alignment closeButtonAlignment;
  final Widget? closeButtonIcon;
  final BoxDecoration? closeButtonBoxDecoration;
  final EdgeInsetsGeometry closeButtonMargin;
  final EdgeInsetsGeometry closeButtonPadding;
  final TextEditingController descriptionController = TextEditingController();
  final bool showDescriptionField;
  final String descriptionFieldText;
  final bool descriptionFieldReadOnly;
  final String descriptionFieldHint;
  final EdgeInsetsGeometry descriptionFieldPadding;
  final DescriptionFieldCallback? descriptionFieldCallback;

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
                      decoration: closeButtonBoxDecoration,
                      child:
                          closeButtonIcon ?? const Icon(Icons.close, size: 18)),
                ),
              ),
            ),
          ),
        if (showDescriptionField)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: descriptionFieldPadding,
              child: TextField(
                decoration: InputDecoration(
                  hintText: descriptionFieldHint,
                  filled: true,
                  fillColor: Colors.white70,
                  isDense: true,
                ),
                readOnly: descriptionFieldReadOnly,
                controller: descriptionController,
                maxLines: 1,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
      ],
    );
  }
}
