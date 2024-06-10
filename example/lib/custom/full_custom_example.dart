import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../picker.dart';

class FullCustomExample extends StatefulWidget {
  const FullCustomExample({Key? key}) : super(key: key);

  @override
  State<FullCustomExample> createState() => _FullCustomExampleState();
}

class _FullCustomExampleState extends State<FullCustomExample> {
  final controller = MultiImagePickerController(
    maxImages: 12,
    picker: (bool allowMultiple) async {
      return await pickImagesUsingImagePicker(allowMultiple);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CustomExamples.fullCustom.name),
      ),
      body: MultiImagePickerView(
        controller: controller,
        draggable: true,
        longPressDelayMilliseconds: 250,
        onDragBoxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
              blurRadius: 5,
            ),
          ],
        ),
        shrinkWrap: false,
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 170,
          childAspectRatio: 0.8,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        builder: (context, imageFile) {
          return Stack(
            children: [
              Positioned.fill(child: ImageFileView(imageFile: imageFile)),
              Positioned(
                  top: 4,
                  right: 4,
                  child: DraggableItemInkWell(
                    borderRadius: BorderRadius.circular(2),
                    onPressed: () => controller.removeImage(imageFile),
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_forever_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.surface,
                        )),
                  )),
            ],
          );
        },
        initialWidget: SizedBox(
          height: 170,
          width: double.infinity,
          child: Center(
            child: ElevatedButton(
              child: const Text('Add Images'),
              onPressed: () {
                controller.pickImages();
              },
            ),
          ),
        ),
        addMoreButton: SizedBox(
          height: 170,
          width: double.infinity,
          child: Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                surfaceTintColor: Colors.black,
                backgroundColor: Colors.black.withOpacity(0.2),
                shape: const CircleBorder(),
              ),
              onPressed: controller.pickImages,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
          ),
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
