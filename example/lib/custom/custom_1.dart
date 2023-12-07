import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class Custom1 extends StatefulWidget {
  const Custom1({Key? key}) : super(key: key);

  @override
  State<Custom1> createState() => _Custom1State();
}

class _Custom1State extends State<Custom1> {
  final controller = MultiImagePickerController(
      maxImages: 12,
      picker: (allowMultiple) =>
          imagePickerExtension(imagePicker: ImagePicker(), allowMultiple: allowMultiple));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom 1'),
      ),
      body: MultiImagePickerView(
        controller: controller,
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 170,
          childAspectRatio: 1,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        builder: (context, imageFile) {
          return Stack(
            children: [
              Positioned.fill(child: ImageFileView(imageFile: imageFile)),
              Positioned(
                  top: 4,
                  right: 4,
                  child: DraggableItemAction(
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
                          color: Theme.of(context).colorScheme.background,
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
                backgroundColor: Colors.blue.withOpacity(0.2),
                shape: const CircleBorder(),
              ),
              onPressed: controller.pickImages,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
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
