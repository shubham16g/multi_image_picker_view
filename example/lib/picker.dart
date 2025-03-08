import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

Future<List<ImageFile>> pickImagesUsingImagePicker(int imageCount) async {
  final picker = ImagePicker();
  final List<XFile> xFiles;
  if (imageCount > 1) {
    xFiles = await picker.pickMultiImage(maxWidth: 1080, maxHeight: 1080, limit: imageCount);
  } else {
    xFiles = [];
    final xFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    if (xFile != null) {
      xFiles.add(xFile);
    }
  }
  if (xFiles.isNotEmpty) {
    return xFiles.map<ImageFile>((e) => convertXFileToImageFile(e)).toList();
  }
  return [];
}

Future<List<ImageFile>> pickImagesUsingFilePicker(int imageCount) async {
  const allowedExtensions = ['png', 'jpeg', 'jpg'];
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: imageCount > 1,
    type: FileType.custom,
    withData: kIsWeb,
    allowedExtensions: allowedExtensions,
  );
  if (result != null && result.files.isNotEmpty) {
    return result.files
        .where((e) =>
            e.extension != null &&
            allowedExtensions.contains(e.extension?.toLowerCase()))
        .map(
          (e) => ImageFile(UniqueKey().toString(),
              name: e.name,
              extension: e.extension!,
              bytes: e.bytes,
              path: !kIsWeb ? e.path : null),
        )
        .toList();
  }
  return [];
}

Future<List<ImageFile>> pickFilesUsingFilePicker(int fileCount) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: fileCount > 1,
    withData: kIsWeb,
  );
  if (result != null && result.files.isNotEmpty) {
    return result.files
        .map(
          (e) => convertPlatformFileToImageFile(e),
        )
        .toList();

    /*
    the below code can be used if not using convertPlatformFileToImageFile extension.
    return result.files
        .map(
          (e) => ImageFile(UniqueKey().toString(),
              name: e.name,
              extension: e.extension!,
              bytes: e.bytes,
              path: !kIsWeb ? e.path : null),
        )
        .toList();*/
  }
  return [];
}
