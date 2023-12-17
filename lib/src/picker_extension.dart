import 'package:flutter/foundation.dart';

import 'image_file.dart';

Future<List<ImageFile>> imagePickerExtension({
  required dynamic imagePicker,
  required bool allowMultiple,
  double? maxWidth,
  double? maxHeight,
  bool requestFullMetaData = true,
}) async {
  final xFiles = await imagePicker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      requestFullMetadata: requestFullMetaData);
  if (xFiles.isNotEmpty) {
    return xFiles
        .map<ImageFile>((e) => ImageFile(
              UniqueKey().toString(),
              name: e.name,
              extension: e.name.contains(".") ? e.name.split(".").last : "",
              path: e.path,
            ))
        .toList();
  }
  return [];
}

Future<List<ImageFile>> filePickerExtension({
  required dynamic filePicker,
  required bool allowMultiple,
  bool withData = false,
  bool withReadStream = false,
  List<String> allowedExtensions = /*const ['png', 'jpeg', 'jpg']*/ const [],
}) async {
  final result = await filePicker.pickFiles(
      allowMultiple: allowMultiple,
      // type: FileType.custom,
      withData: kIsWeb ? true : withData,
      withReadStream: withReadStream);
  if (result != null && result.files.isNotEmpty) {
    print("files got: ${result.count}");
    return result.files
        /*.where((e) =>
            e.extension != null &&
            allowedExtensions.contains(e.extension?.toLowerCase()))
        */
        .map((e) => ImageFile(UniqueKey().toString(),
            name: e.name,
            extension: e.extension!,
            bytes: e.bytes,
            path: !kIsWeb ? e.path : null))
        .toList();
  }
  return [];
}
