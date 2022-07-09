import 'dart:typed_data';

class ImageFile {
  final String name;
  final String extension;
  final Uint8List? bytes;
  final String? path;

  bool get hasPath => path != null;
  int get size => bytes?.length ?? 0;

  ImageFile({required this.name, required this.extension, this.bytes, this.path});
}

