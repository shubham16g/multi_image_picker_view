import 'package:flutter/material.dart';

import '../image_file.dart';

class ImagePreview extends StatelessWidget {
  final ImageFile file;
  final double radius;
  final BoxFit fit;

  const ImagePreview({super.key, required this.file, this.radius = 4, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.memory(
        file.bytes!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('No Preview'));
        },
      ),
    );
  }
}
