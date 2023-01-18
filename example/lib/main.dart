import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Multi Image Picker View Example',
    darkTheme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(color: Colors.blue.shade100),
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
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MultiImagePickerView(
            controller: controller,
            padding: const EdgeInsets.all(10),
          ),
          const SizedBox(height: 32),
          const CustomExamples()
        ],
      ),
      appBar: AppBar(
        title: const Text('Multi Image Picker View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () {
              final images = controller.images;
              // use these images
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(images.toString())));
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
