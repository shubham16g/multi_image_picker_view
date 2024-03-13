import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../picker.dart';

class InitialImagesCustomExample extends StatefulWidget {
  const InitialImagesCustomExample({Key? key}) : super(key: key);

  @override
  State<InitialImagesCustomExample> createState() =>
      _InitialImagesCustomExampleState();
}

class _InitialImagesCustomExampleState
    extends State<InitialImagesCustomExample> {
  final controller = MultiImagePickerController(
    maxImages: 12,
    images: [
      ImageFile(
        UniqueKey().toString(),
        name: "test-image.jpg",
        extension: "jpg",
        path: "https://t.ly/F4XOS",
      ),
    ],
    picker: (bool allowMultiple) {
      return pickImagesUsingImagePicker(allowMultiple);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomExamples.initialImages.name),
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
            fit: BoxFit.cover,
            closeButtonIcon:
                const Icon(Icons.delete_rounded, color: Colors.red),
            closeButtonBoxDecoration: null,
            showCloseButton: true,
            closeButtonMargin: const EdgeInsets.all(3),
            closeButtonPadding: const EdgeInsets.all(3),
          );
        },
        initialWidget: DefaultInitialWidget(
          centerWidget: Icon(Icons.image_search_outlined,
              color: Theme.of(context).colorScheme.secondary),
        ),
        addMoreButton: DefaultAddMoreWidget(
          icon: Icon(Icons.image_search_outlined,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
