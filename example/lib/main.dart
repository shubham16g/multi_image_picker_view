import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Multi Image Picker View Example',
    theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.blue.shade50)),
        )),
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
    maxImages: 10,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            MultiImagePickerView(
              onChange: (list) {
                debugPrint(list.toString());
              },
              controller: controller,
              padding: const EdgeInsets.all(10),
            ),
            const SizedBox(height: 32),
            const CustomExamples()
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Multi Image Picker View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () {
              final images = controller.images;
              // use these images
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(images.map((e) => e.name).toString())));
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
