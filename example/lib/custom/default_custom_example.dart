import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class DefaultCustomExample extends StatefulWidget {
  const DefaultCustomExample({Key? key}) : super(key: key);

  @override
  State<DefaultCustomExample> createState() => _DefaultCustomExampleState();
}

class _DefaultCustomExampleState extends State<DefaultCustomExample> {
  final controller = MultiImagePickerController(
    maxImages: 12,
    picker: (bool allowMultiple) {
      return imagePickerExtension(
          imagePicker: ImagePicker(), allowMultiple: allowMultiple);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomExamples.defaultCustom.name),
      ),
      body: MultiImagePickerView(
        controller: controller,
        padding: const EdgeInsets.all(10),
        builder: (context, imageFile) {
          return DefaultDraggableItemWidget(
            imageFile: imageFile,
            boxDecoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20)),
            closeButtonAlignment: Alignment.topLeft,
            closeButtonBoxDecoration: null,
            showCloseButton: true,
            closeButtonMargin: const EdgeInsets.all(3),
            closeButtonPadding: const EdgeInsets.all(3),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
