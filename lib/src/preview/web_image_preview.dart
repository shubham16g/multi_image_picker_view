import 'package:flutter/material.dart';

import '../image_file.dart';

class ImagePreview extends StatelessWidget {
  final ImageFile file;
  final BoxFit fit;

  const ImagePreview({super.key, required this.file, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      file.bytes!,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Text('No Preview'));
      },
    );
  }
}
