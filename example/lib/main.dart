import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

void main() {
  runApp(MaterialApp(
    title: 'Mutli Image Picker View Example',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const DemoPage(),
  ));
}

class DemoPage extends StatelessWidget {
  const DemoPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Image Picker View Example'),
      ),
      body: MultiImagePickerView(
        padding: const EdgeInsets.all(10),
        initialContainerBuilder: (context, pickerCallback) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.red.withOpacity(0.05),
            ),
            height: 160,
            width: double.infinity,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: TextButton(
                child: const Text('Add Images'),
                onPressed: () {
                  pickerCallback();
                },
              ),
            ),
          );
        },
        onChange: (list) {
          print('got the list');
        },
        controller: MultiImagePickerController(
            maxImages: 12,
            allowedImageTypes: const [
              ImageType.jpeg,
              ImageType.jpg,
              ImageType.png
            ]),
      ),
    );
  }
}
