import 'package:example/custom_examples.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import 'picker.dart';

void main() {
  // timeDilation = 4;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Multi Image Picker View Example',
    theme: ThemeData(
        useMaterial3: true,
        splashFactory: InkSparkle.splashFactory,
        appBarTheme: AppBarTheme(color: Colors.purple.shade100),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(Colors.purple.shade50)),
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
      picker: (allowMultiple) async {
        return await pickImagesUsingImagePicker(allowMultiple);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomExamplesWidget(),
          const SizedBox(height: 32),
          Expanded(
            child: MultiImagePickerView(
              controller: controller,
              padding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Multi Image Picker View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              controller.pickImages();
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(controller.images.toString())));
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
