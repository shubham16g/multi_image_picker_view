import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/src/image_file_view/error_preview.dart';

import '../image_file.dart';

class ImageFileView extends StatelessWidget {
  final ImageFile imageFile;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final ImageErrorWidgetBuilder? errorBuilder;

  const ImageFileView(
      {super.key,
      required this.imageFile,
      this.fit = BoxFit.cover,
      this.borderRadius,
      this.errorBuilder});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: imageFile.path == null
          ? Image.memory(
              imageFile.bytes!,
              fit: fit,
              errorBuilder: errorBuilder ?? (context, error, stackTrace) {
                return ErrorPreview(imageFile: imageFile);
              },
            )
          : Image.network(
              imageFile.path!,
              fit: fit,
              errorBuilder: errorBuilder ?? (context, error, stackTrace) {
                return ErrorPreview(imageFile: imageFile);
              },
            ),
    );
  }
}
