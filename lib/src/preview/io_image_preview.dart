import 'dart:io';
import 'package:flutter/material.dart';
import '../image_file.dart';

class ImagePreview extends StatelessWidget {
  final ImageFile file;
  final BoxFit fit;

  const ImagePreview({super.key, required this.file, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(file.path!),
      fit: fit,
    );
  }
}
