import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/src/image_file_view/error_preview.dart';

import '../image_file.dart';

class ImageFileView extends StatelessWidget {
  final ImageFile imageFile;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final ImageErrorWidgetBuilder? errorBuilder;

  const ImageFileView(
      {super.key,
      required this.imageFile,
      this.fit = BoxFit.cover,
      this.borderRadius,
      this.errorBuilder,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: imageFile.path == null
          ? Image.memory(
              imageFile.bytes!,
              fit: fit,
              errorBuilder: errorBuilder ??
                  (context, error, stackTrace) {
                    return ErrorPreview(imageFile: imageFile);
                  },
            )
          : Image.network(
              imageFile.path!,
              fit: fit,
              errorBuilder: errorBuilder ??
                  (context, error, stackTrace) {
                    return ErrorPreview(imageFile: imageFile);
                  },
            ),
    );
  }
}
