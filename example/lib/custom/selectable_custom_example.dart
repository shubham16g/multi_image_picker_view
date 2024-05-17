import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../picker.dart';

class SelectableCustomExample extends StatefulWidget {
  const SelectableCustomExample({Key? key}) : super(key: key);

  @override
  State<SelectableCustomExample> createState() =>
      _SelectableCustomExampleState();
}

class _SelectableCustomExampleState extends State<SelectableCustomExample> {
  final selectedImages = <ImageFile>[];

  void addSelectedImage(ImageFile imageFile) {
    setState(() {
      selectedImages.add(imageFile);
    });
  }

  void removeSelectedImage(ImageFile imageFile) {
    setState(() {
      selectedImages.remove(imageFile);
    });
  }

  final controller = MultiImagePickerController(
    maxImages: 10,
    picker: (allowMultiple) => pickImagesUsingImagePicker(allowMultiple),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomExamples.selectableCustom.name),
        actions: [
          if (selectedImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                for (final imageFile in selectedImages) {
                  controller.removeImage(imageFile);
                }
                setState(() {
                  selectedImages.clear();
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected Images:\n$selectedImages")));
            },
          ),
        ],
      ),
      body: MultiImagePickerView(
        controller: controller,
        padding: const EdgeInsets.all(10),
        builder: (context, imageFile) {
          return DraggableItemInkWell(
            borderRadius: BorderRadius.circular(8),
            onPressed: () {
              if (selectedImages.contains(imageFile)) {
                removeSelectedImage(imageFile);
              } else {
                addSelectedImage(imageFile);
              }
            },
            child: Stack(
              children: [
                Positioned.fill(
                    child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: ImageFileView(
                    imageFile: imageFile,
                    borderRadius: BorderRadius.circular(8),
                  ),
                )),
                if (selectedImages.contains(imageFile))
                  Positioned.fill(
                      child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 10),
                    ),
                  )),
                if (selectedImages.contains(imageFile))
                  Positioned.fill(
                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 10),
                    ),
                  )),
              ],
            ),
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
