import 'dart:io';
import 'package:flutter/material.dart';
import '../image_file.dart';

class ImageFileView extends StatelessWidget {
  final ImageFile file;

  const ImageFileView({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        File(file.path!),
        fit: BoxFit.cover,
      ),
    );
  }
}
