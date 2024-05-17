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
        path:
            "https://cc-prod.scene7.com/is/image/CCProdAuthor/What-is-Stock-Photography_P1_mobile",
      ),
      ImageFile(
        UniqueKey().toString(),
        name: "test-document.pdf",
        extension: "pdf",
        path:
            "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
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
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
