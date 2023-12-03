import 'package:flutter/material.dart';
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
          imagePickerExtension(allowMultiple: allowMultiple));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom 1'),
      ),
      body: MultiImagePickerView(
        controller: controller,
        padding: const EdgeInsets.all(0),
        onChange: (list) {
          debugPrint(list.toString());
        },
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 170,
          childAspectRatio: 1,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        // todo default border radius
        closeButton: MultiImagePickerCloseButton.customIcon(
            icon: const Icon(
              Icons.close,
              size: 20,
            ),
            boxDecoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            )),
        initialWidget: MultiImagePickerInitialWidget.customWidget(
          builder: (context, pickerCallback) {
            return SizedBox(
              height: 170,
              width: double.infinity,
              child: Center(
                child: ElevatedButton(
                  child: const Text('Add Images'),
                  onPressed: () {
                    pickerCallback();
                  },
                ),
              ),
            );
          },
        ),
        addMoreButton: MultiImagePickerAddMoreButton.customButton(
            builder: (context, pickerCallback) {
          return SizedBox(
            height: 170,
            width: double.infinity,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  shape: const CircleBorder(),
                ),
                onPressed: pickerCallback,
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
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
