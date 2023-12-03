import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'image_file.dart';

Future<List<ImageFile>> imagePickerExtension({
  required bool allowMultiple,
  double? maxWidth,
  double? maxHeight,
  bool requestFullMetaData = true,
}) async {
  ImagePicker picker = ImagePicker();
  final xFiles = await picker.pickMultiImage(maxWidth: maxWidth,
      maxHeight: maxHeight,
      requestFullMetadata: requestFullMetaData);
  if (xFiles.isNotEmpty) {
    return xFiles.map<ImageFile>((e) =>
        ImageFile(UniqueKey().toString(), name: e.name,
          extension: e.mimeType ?? '',
          path: e.path, )).toList();
  }
  return [];
}
