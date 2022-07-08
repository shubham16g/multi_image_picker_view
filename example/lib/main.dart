import 'dart:io';

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
        title: Text('Multi Image Picker View'),
      ),
      body: MultiImagePickerView(
        padding: const EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 170,
            childAspectRatio: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0),
        initialContainerBuilder: (context, pickerCallback) {
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
        itemBuilder: (context, file, deleteCallback){
          return ImageCard(file: file, deleteCallback: deleteCallback);
        },
        addMoreBuilder: (context, pickerCallback) {
          return SizedBox(
            height: 170,
            width: double.infinity,
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  shape: CircleBorder(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.add, color: Colors.blue, size: 30,),
                ),
                onPressed: () {
                  pickerCallback();
                },
              ),
            ),
          );
        },
        onChange: (list) {
          // print('got the list');
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


class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.file, required this.deleteCallback})
      : super(key: key);

  final ImageFile file;
  final Function(ImageFile file) deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: !file.hasPath
              ? Image.memory(
            file.bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('No Preview'));
            },
          )
              : Image.file(
            File(file.path!),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            excludeFromSemantics: true,
            onLongPress: () {
            },
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 20,)),
            onTap: (){
              deleteCallback(file);
            },
          ),
        ),
      ],
    );
  }
}
