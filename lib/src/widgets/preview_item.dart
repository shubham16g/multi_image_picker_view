import 'package:flutter/material.dart';

import '../image_file.dart';
import '../image_file_view/image_file_view.dart';

class PreviewItem extends StatelessWidget {
  const PreviewItem({
    super.key,
    required this.file,
    required this.fit,
    this.boxDecoration,
    required this.defaultImageBorderRadius,
  });

  final ImageFile file;
  final BoxFit fit;
  final BoxDecoration? boxDecoration;

  final BorderRadius? defaultImageBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: boxDecoration ??
          BoxDecoration(
            borderRadius: defaultImageBorderRadius,
          ),
      child: ImageFileView(
        fit: fit,
        file: file,
      ),
    );
  }
}
