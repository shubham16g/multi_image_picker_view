import 'package:flutter/material.dart';
import '../image_file.dart';

class ImageFileView extends StatelessWidget {
  final ImageFile file;
  final BoxFit fit;

  const ImageFileView({super.key, required this.file, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        file.path!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('No Preview'));
        },
      ),
    );
  }
}
