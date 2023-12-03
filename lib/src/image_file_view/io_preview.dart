import 'dart:io';
import 'package:flutter/material.dart';
import '../image_file.dart';

class ImageFileView extends StatelessWidget {
  final ImageFile file;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ImageFileView(
      {super.key,
      required this.file,
      this.fit = BoxFit.cover,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.file(
        File(file.path!),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('No Preview'));
        },
      ),
    );
  }
}
