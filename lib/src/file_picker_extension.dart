import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'image_file.dart';

Future<List<ImageFile>> filePickerExtension({
  required bool allowMultiple,
  bool withData = false,
  bool withReadStream = false,
  List<String> allowedExtensions = const ['png', 'jpeg', 'jpg'],
}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      withData: kIsWeb ? true : withData,
      withReadStream: withReadStream,
      allowedExtensions: allowedExtensions);
  if (result != null && result.files.isNotEmpty) {
    return result.files
        .where((e) =>
            e.extension != null &&
            allowedExtensions.contains(e.extension?.toLowerCase()))
        .map((e) => ImageFile(UniqueKey().toString(),
            name: e.name,
            extension: e.extension!,
            bytes: e.bytes,
            path: !kIsWeb ? e.path : null))
        .toList();
  }
  return [];
}
