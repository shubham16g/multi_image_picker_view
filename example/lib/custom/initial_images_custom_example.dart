import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../picker.dart';

class InitialImagesCustomExample extends StatefulWidget {
  const InitialImagesCustomExample({super.key});

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
        path:
            "https://cdn.pixabay.com/photo/2024/06/18/21/37/bali-8838762_640.jpg",
      ),
      ImageFile(
        UniqueKey().toString(),
        name: "test-image-2.jpg",
        extension: "jpg",
        path:
            "https://cdn.pixabay.com/photo/2024/07/20/18/49/stars-8908843_640.jpg",
      ),
    ],
    picker: (int imageCount, Object? params) {
      return pickImagesUsingImagePicker(imageCount);
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
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
