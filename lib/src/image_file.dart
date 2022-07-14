import 'dart:typed_data';

/// Store the image data and other information.
class ImageFile {
  final String name;
  final String extension;
  final Uint8List? bytes;
  final String? path;

  /// returns true if image has path. (For web path is not available)
  bool get hasPath => path != null;

  /// returns size of bytes if image has bytes, else 0.
  int get size => bytes?.length ?? 0;

  ImageFile(
      {required this.name, required this.extension, this.bytes, this.path});
}
