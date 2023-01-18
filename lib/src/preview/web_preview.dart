import 'package:flutter/material.dart';

import '../image_file.dart';

class ImagePreview extends StatelessWidget {
  final ImageFile file;

  const ImagePreview({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.memory(
        file.bytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('No Preview'));
        },
      ),
    );
  }
}
