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
