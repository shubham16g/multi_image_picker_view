import 'package:example/custom_examples.dart';
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

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final controller = MultiImagePickerController(
    pickerBuilder: (){
      return Future.delayed(Duration(seconds: 1));
    },
    maxImages: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MultiImagePickerView(
            draggable: true,
            controller: controller,
            padding: const EdgeInsets.all(10),
          ),
          const SizedBox(height: 32),
          CustomExamples()
        ],
      ),
      appBar: AppBar(
        title: Text('Multi Image Picker View'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: () {
              final images = controller.images;
              // use these images
              print(images);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
