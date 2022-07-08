library multi_image_picker_view;

import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/src/multi_image_picker_view.dart';

// export 'src/multi_image_picker_view.dart';

void main(){
  runApp(MaterialApp(
    title: 'Test App',
    home: Scaffold(
      appBar: AppBar(
        title: Text('Test App'),
      ),
      body: MultiImagePickerView(
        controller: MultiImagePickerController(),
        padding: const EdgeInsets.all(10),
        allowedImageTypes: const [ImageType.jpeg, ImageType.png],
      ),
    ),
  ));
}