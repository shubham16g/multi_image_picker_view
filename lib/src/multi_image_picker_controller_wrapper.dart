import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class MultiImagePickerControllerWrapper extends InheritedWidget {
  const MultiImagePickerControllerWrapper({
    super.key,
    required this.controller,
    required this.padding,
    required Widget child,
  }) : super(child: child);

  final MultiImagePickerController controller;
  final EdgeInsetsGeometry? padding;

  static MultiImagePickerControllerWrapper of(BuildContext context) {
    final MultiImagePickerControllerWrapper? result =
        context.dependOnInheritedWidgetOfExactType<
            MultiImagePickerControllerWrapper>();
    assert(result != null,
        'No MultiImagePickerControllerWrapper found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(MultiImagePickerControllerWrapper oldWidget) {
    return oldWidget.controller != controller || oldWidget.padding != padding;
  }
}
