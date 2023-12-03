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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
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
      maxImages: 100,
      picker: (allowMultiple) =>
          filePickerExtension(allowMultiple: allowMultiple));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomExamples(),
          const SizedBox(height: 32),
          Expanded(
            child: MultiImagePickerView(
              controller: controller,
              padding: const EdgeInsets.all(10),
              onChange: (list) {
                debugPrint(list.toString());
              },
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Multi Image Picker View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () {
              controller.pickImages();
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
