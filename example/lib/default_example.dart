import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
    final controller = MultiImagePickerController(
      maxImages: 10,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
    );

    /// You can use given functionality with this controller.
    // controller.pickImages();
    // controller.images; // returns images
    // check documentation for more info

    return Scaffold(
      body: MultiImagePickerView(
        controller: controller,
        padding: const EdgeInsets.all(10),
      ),
      appBar: AppBar(
        title: Text('Multi Image Picker View'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: () {
              final images = controller.images;
              /// use these images
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${images.length} images selected'),
              ));
            },
          ),
        ],
      ),
    );
  }
}

