
import 'dart:typed_data';

import 'package:multi_image_picker_view/src/image_type.dart';

class ImageFile {
  final String name;
  final String extension;
  final Uint8List bytes;
  final String? path;

  bool get hasPath => path != null;
  int get size => bytes.length;

  ImageFile({required this.name, required this.extension, required this.bytes, this.path});
}

